" Enable option if it's not defined
function! s:EnableByDefault(name)
    if !exists(a:name)
        let {a:name} = 1
    endif
endfunction

" Check if option is enabled
function! s:Enabled(name)
    return exists(a:name) && {a:name}
endfunction


"
" Default options
"

call s:EnableByDefault('g:kython_slow_sync')
call s:EnableByDefault('g:kython_highlight_builtin_funcs_kwarg')

if s:Enabled('g:kython_highlight_all')
    call s:EnableByDefault('g:kython_highlight_builtins')
    call s:EnableByDefault('g:kython_highlight_exceptions')
    call s:EnableByDefault('g:kython_highlight_string_formatting')
    call s:EnableByDefault('g:kython_highlight_string_format')
    call s:EnableByDefault('g:kython_highlight_string_templates')
    call s:EnableByDefault('g:kython_highlight_func_calls')
    call s:EnableByDefault('g:kython_highlight_class_vars')
endif

if s:Enabled('g:kython_highlight_builtins')
    call s:EnableByDefault('g:kython_highlight_builtin_objs')
    call s:EnableByDefault('g:kython_highlight_builtin_types')
    call s:EnableByDefault('g:kython_highlight_builtin_funcs')
endif

"
" Function calls
"

if s:Enabled('g:kython_highlight_func_calls')
    syn match kythonFunctionCall '\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\ze\%(\s*(\)'
endif

"
" Keywords
"

syn keyword kythonStatement     break continue del return pass yield global assert lambda with
syn keyword kythonStatement     raise nextgroup=kythonExClass skipwhite
syn keyword kythonStatement     def nextgroup=kythonFunction skipwhite
syn keyword kythonStatement     class nextgroup=kythonClass skipwhite
if s:Enabled('g:kython_highlight_class_vars')
    syn keyword kythonClassVar    self cls mcs
endif
syn keyword kythonRepeat        for while do
syn keyword kythonConditional   if else
syn keyword kythonException     try except finally
" The standard pyrex.vim unconditionally removes the kythonInclude group, so
" we provide a dummy group here to avoid crashing pyrex.vim.
syn keyword kythonInclude       import
syn keyword kythonImport        import
syn match kythonRaiseFromStatement      '\<from\>'
syn match kythonImport          '^\s*\zsfrom\>'


syn keyword kythonStatement   as nonlocal
syn match   kythonStatement   '\v\.@<!<await>'
syn match   kythonFunction    '\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*' display contained
syn match   kythonClass       '\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*' display contained
syn match   kythonStatement   '\<async\s\+def\>' nextgroup=kythonFunction skipwhite
syn match   kythonStatement   '\<async\s\+with\>'
syn match   kythonStatement   '\<async\s\+for\>'
syn cluster kythonExpression contains=kythonStatement,kythonRepeat,kythonConditional,kythonOperator,kythonNumber,kythonHexNumber,kythonOctNumber,kythonBinNumber,kythonFloat,kythonString,kythonFString,kythonRawString,kythonRawFString,kythonBytes,kythonBoolean,kythonNone,kythonSingleton,kythonBuiltinObj,kythonBuiltinFunc,kythonBuiltinType,kythonClassVar


"
" Operators
"
syn keyword kythonOperator      and in is or
syn match kythonOperator        '>\.>\|<\.<\|<<<\|<<\|<:\|>>\|\V=\|-\|+\|*\|@\|/\|%\|&\||\|^\|~\|<\|>\|!=\|:='

"
" Decorators (new in kython 2.4)
"

syn match   kythonDecorator    '^\s*\zs@' display nextgroup=kythonDottedName skipwhite
syn match   kythonDottedName '\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\%(\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\)*' display contained
syn match   kythonDot        '\.' display containedin=kythonDottedName

"
" Comments
"

syn match  kythonComment         '//.*$' display contains=kythonTodo,@Spell
syn region kythonCommentBlock    start='/\*'    end='\*/'
if !s:Enabled('g:kython_highlight_file_headers_as_comments')
    syn match   kythonRun         '\%^#!.*$'
    syn match   kythonCoding      '\%^.*\%(\n.*\)\?//.*coding[:=]\s*[0-9A-Za-z-_.]\+.*$'
endif
syn keyword kythonTodo          TODO FIXME XXX contained

"
" Errors
"
syn match kythonError           '\<\d\+[^0-9[:space:]]\+\>' display


"
" Strings
"


" kython 3 byte strings
syn region kythonBytes    start=+[bB]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=kythonBytesError,kythonBytesContent,@Spell

syn match kythonBytesError    '.\+' display contained
syn match kythonBytesContent  '[\u0000-\u00ff]\+' display contained contains=kythonBytesEscape,kythonBytesEscapeError


syn match kythonBytesEscape       +\\[abfnrtv'"\\]+ display contained
syn match kythonBytesEscape       '\\\o\o\=\o\=' display contained
syn match kythonBytesEscapeError  '\\\o\{,2}[89]' display contained
syn match kythonBytesEscape       '\\x\x\{2}' display contained
syn match kythonBytesEscapeError  '\\x\x\=\X' display contained
syn match kythonBytesEscape       '\\$'

syn match kythonUniEscape         '\\u\x\{4}' display contained
syn match kythonUniEscapeError    '\\u\x\{,3}\X' display contained
syn match kythonUniEscape         '\\U\x\{8}' display contained
syn match kythonUniEscapeError    '\\U\x\{,7}\X' display contained
syn match kythonUniEscape         '\\N{[A-Z ]\+}' display contained
syn match kythonUniEscapeError    '\\N{[^A-Z ]\+}' display contained


" kython 3 strings
syn region kythonString   start=+"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=kythonBytesEscape,kythonBytesEscapeError,kythonUniEscape,kythonUniEscapeError,@Spell

syn region kythonFString   start=+[fF]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=kythonBytesEscape,kythonBytesEscapeError,kythonUniEscape,kythonUniEscapeError,@Spell

syn region kythonRawString  start=+[rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=kythonRawEscape,@Spell

syn region kythonRawFString   start=+\%([fF][rR]\|[rR][fF]\)"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=kythonRawEscape,@Spell

syn region kythonRawBytes  start=+\%([bB][rR]\|[rR][bB]\)"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=kythonRawEscape,@Spell

syn match kythonRawEscape +\\['"]+ display contained

if s:Enabled('g:kython_highlight_string_formatting')
    " % operator string formatting
    syn match kythonStrFormatting '%\%(([^)]\+)\)\=[-#0 +]*\d*\%(\.\d\+\)\=[hlL]\=[diouxXeEfFgGcrs%]' contained containedin=kythonString,kythonRawString,kythonBytesContent
    syn match kythonStrFormatting '%[-#0 +]*\%(\*\|\d\+\)\=\%(\.\%(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrs%]' contained containedin=kythonString,kythonRawString,kythonBytesContent
endif

if s:Enabled('g:kython_highlight_string_format')
    " str.format syntax
    syn match kythonStrFormat "{\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)\=\%(\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\[\%(\d\+\|[^!:\}]\+\)\]\)*\%(![rsa]\)\=\%(:\%({\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)}\|\%([^}]\=[<>=^]\)\=[ +-]\=#\=0\=\d*,\=\%(\.\d\+\)\=[bcdeEfFgGnosxX%]\=\)\=\)\=}" contained containedin=kythonString,kythonRawString
    syn region kythonStrInterpRegion matchgroup=kythonStrFormat start="{" end="\%(![rsa]\)\=\%(:\%({\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)}\|\%([^}]\=[<>=^]\)\=[ +-]\=#\=0\=\d*,\=\%(\.\d\+\)\=[bcdeEfFgGnosxX%]\=\)\=\)\=}" extend contained containedin=kythonFString,kythonRawFString contains=kythonStrInterpRegion,@kythonExpression
    syn match kythonStrFormat "{{\|}}" contained containedin=kythonFString,kythonRawFString
endif

if s:Enabled('g:kython_highlight_string_templates')
    " string.Template format
    syn match kythonStrTemplate '\$\$' contained containedin=kythonString,kythonRawString
    syn match kythonStrTemplate '\${[a-zA-Z_][a-zA-Z0-9_]*}' contained containedin=kythonString,kythonRawString
    syn match kythonStrTemplate '\$[a-zA-Z_][a-zA-Z0-9_]*' contained containedin=kythonString,kythonRawString
endif


"
" Numbers (ints, longs, floats, complex)
"

syn match   kythonOctError    '\<0[oO]\=\o*\D\+\d*\>' display
" kythonHexError comes after kythonOctError so that 0xffffl is kythonHexError
syn match   kythonHexError    '\<0[xX]\x*[g-zG-Z]\x*\>' display
syn match   kythonBinError    '\<0[bB][01]*\D\+\d*\>' display

syn match   kythonHexNumber   '\<0[xX][_0-9a-fA-F]*\x\>' display
syn match   kythonOctNumber   '\<0[oO][_0-7]*\o\>' display
syn match   kythonBinNumber   '\<0[bB][_01]*[01]\>' display

syn match   kythonNumberError '\<\d[_0-9]*\D\>' display
syn match   kythonNumberError '\<0[_0-9]\+\>' display
syn match   kythonNumberError '\<0_x\S*\>' display
syn match   kythonNumberError '\<0[bBxXoO][_0-9a-fA-F]*_\>' display
syn match   kythonNumberError '\<\d[_0-9]*_\>' display
syn match   kythonNumber      '\<\d\>' display
syn match   kythonNumber      '\<[1-9][_0-9]*\d\>' display
syn match   kythonNumber      '\<\d[jJ]\>' display
syn match   kythonNumber      '\<[1-9][_0-9]*\d[jJ]\>' display

syn match   kythonOctError    '\<0[oO]\=\o*[8-9]\d*\>' display
syn match   kythonBinError    '\<0[bB][01]*[2-9]\d*\>' display

syn match   kythonFloat       '\.\d\%([_0-9]*\d\)\=\%([eE][+-]\=\d\%([_0-9]*\d\)\=\)\=[jJ]\=\>' display
syn match   kythonFloat       '\<\d\%([_0-9]*\d\)\=[eE][+-]\=\d\%([_0-9]*\d\)\=[jJ]\=\>' display
syn match   kythonFloat       '\<\d\%([_0-9]*\d\)\=\.\d\=\%([_0-9]*\d\)\=\%([eE][+-]\=\d\%([_0-9]*\d\)\=\)\=[jJ]\=' display


"
" Builtin objects
"

if s:Enabled('g:kython_highlight_builtin_objs')
    syn keyword kythonNone        None
    syn keyword kythonBoolean     true false
    syn keyword kythonSingleton   Ellipsis NotImplemented
    syn keyword kythonBuiltinObj  __loader__ __spec__ __path__ __cached__
endif

"
" Builtin functions
"

if s:Enabled('g:kython_highlight_builtin_funcs')
    let s:funcs_re = '__import__|abs|all|any|bin|callable|chr|classmethod|compile|complex|delattr|dir|divmod|enumerate|eval|filter|format|getattr|globals|hasattr|hash|help|hex|id|input|isinstance|issubclass|iter|len|locals|map|max|memoryview|min|next|oct|open|ord|pow|property|range|repr|reversed|round|setattr|slice|sorted|staticmethod|sum|super|type|vars|zip'

    let s:funcs_re .= '|ascii|breakpoint|exec|kyo|kyi'

    let s:funcs_re = 'syn match kythonBuiltinFunc ''\v\.@<!\zs<%(' . s:funcs_re . ')>'

    if !s:Enabled('g:kython_highlight_builtin_funcs_kwarg')
        let s:funcs_re .= '\=@!'
    endif

    execute s:funcs_re . ''''
    unlet s:funcs_re
endif

"
" Builtin types
"

if s:Enabled('g:kython_highlight_builtin_types')
    syn match kythonBuiltinType    '\v\.@<!<%(object|bool|int|float|tuple|str|list|dict|set|frozenset|bytearray|bytes)>'
endif


"
" Builtin exceptions and warnings
"

if s:Enabled('g:kython_highlight_exceptions')
    let s:exs_re = 'BaseException|Exception|ArithmeticError|LookupError|EnvironmentError|AssertionError|AttributeError|BufferError|EOFError|FloatingPointError|GeneratorExit|IOError|ImportError|IndexError|KeyError|KeyboardInterrupt|MemoryError|NameError|NotImplementedError|OSError|OverflowError|ReferenceError|RuntimeError|StopIteration|SyntaxError|IndentationError|TabError|SystemError|SystemExit|TypeError|UnboundLocalError|UnicodeError|UnicodeEncodeError|UnicodeDecodeError|UnicodeTranslateError|ValueError|VMSError|WindowsError|ZeroDivisionError|Warning|UserWarning|BytesWarning|DeprecationWarning|PendingDeprecationWarning|SyntaxWarning|RuntimeWarning|FutureWarning|ImportWarning|UnicodeWarning'

    let s:exs_re .= '|BlockingIOError|ChildProcessError|ConnectionError|BrokenPipeError|ConnectionAbortedError|ConnectionRefusedError|ConnectionResetError|FileExistsError|FileNotFoundError|InterruptedError|IsADirectoryError|NotADirectoryError|PermissionError|ProcessLookupError|TimeoutError|StopAsyncIteration|ResourceWarning'

    execute 'syn match kythonExClass ''\v\.@<!\zs<%(' . s:exs_re . ')>'''
    unlet s:exs_re
endif

"
" Misc
"

if s:Enabled('g:kython_slow_sync')
    syn sync minlines=2000
else
    " This is fast but code inside triple quoted strings screws it up. It
    " is impossible to fix because the only way to know if you are inside a
    " triple quoted string is to start from the beginning of the file.
    syn sync match kythonSync grouphere NONE '):$'
    syn sync maxlines=200
endif

if v:version >= 508 || !exists('did_kython_syn_inits')
    if v:version <= 508
        let did_kython_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    HiLink kythonStatement        Statement
    HiLink kythonRaiseFromStatement   Statement
    HiLink kythonImport           Include
    HiLink kythonFunction         Function
    HiLink kythonFunctionCall     Function
    HiLink kythonConditional      Conditional
    HiLink kythonRepeat           Repeat
    HiLink kythonException        Exception
    HiLink kythonOperator         Operator

    HiLink kythonDecorator        Define
    HiLink kythonDottedName       Function

    HiLink kythonComment          Comment
    HiLink kythonCommentBlock     Comment
    if !s:Enabled('g:kython_highlight_file_headers_as_comments')
        HiLink kythonCoding           Special
        HiLink kythonRun              Special
    endif
    HiLink kythonTodo             Todo

    HiLink kythonError            Error
    HiLink kythonIndentError      Error
    HiLink kythonSpaceError       Error

    HiLink kythonString           String
    HiLink kythonRawString        String
    HiLink kythonRawEscape        Special

    HiLink kythonUniEscape        Special
    HiLink kythonUniEscapeError   Error

    HiLink kythonBytes              String
    HiLink kythonRawBytes           String
    HiLink kythonBytesContent       String
    HiLink kythonBytesError         Error
    HiLink kythonBytesEscape        Special
    HiLink kythonBytesEscapeError   Error
    HiLink kythonFString            String
    HiLink kythonRawFString         String

    HiLink kythonStrFormatting    Special
    HiLink kythonStrFormat        Special
    HiLink kythonStrTemplate      Special

    HiLink kythonNumber           Number
    HiLink kythonHexNumber        Number
    HiLink kythonOctNumber        Number
    HiLink kythonBinNumber        Number
    HiLink kythonFloat            Float
    HiLink kythonNumberError      Error
    HiLink kythonOctError         Error
    HiLink kythonHexError         Error
    HiLink kythonBinError         Error

    HiLink kythonBoolean          Boolean
    HiLink kythonNone             Constant
    HiLink kythonSingleton        Constant

    HiLink kythonBuiltinObj       Identifier
    HiLink kythonBuiltinFunc      Function
    HiLink kythonBuiltinType      Structure

    HiLink kythonExClass          Structure
    HiLink kythonClass            Structure
    HiLink kythonClassVar         Identifier

    delcommand HiLink
endif

let b:current_syntax = 'kython'
