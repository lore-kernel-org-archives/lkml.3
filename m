Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaC1N6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:58:23 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:48978 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaC1N6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:58:17 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH 27/28] ktap: add vim syntax file
Date: Fri, 28 Mar 2014 09:47:48 -0400
Message-Id: <1396014469-5937-28-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make ktap script looks more beautiful.

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 tools/ktap/vim/ftdetect/ktap.vim |   3 ++
 tools/ktap/vim/syntax/ktap.vim   | 106 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+)
 create mode 100644 tools/ktap/vim/ftdetect/ktap.vim
 create mode 100644 tools/ktap/vim/syntax/ktap.vim

diff --git a/tools/ktap/vim/ftdetect/ktap.vim b/tools/ktap/vim/ftdetect/ktap.vim
new file mode 100644
index 0000000..439f54c
--- /dev/null
+++ b/tools/ktap/vim/ftdetect/ktap.vim
@@ -0,0 +1,3 @@
+augroup filetype
+  au BufNewFile,BufRead *.kp   set filetype=ktap
+augroup end
diff --git a/tools/ktap/vim/syntax/ktap.vim b/tools/ktap/vim/syntax/ktap.vim
new file mode 100644
index 0000000..a375b79
--- /dev/null
+++ b/tools/ktap/vim/syntax/ktap.vim
@@ -0,0 +1,106 @@
+" Vim syntax file
+" Language:     ktap
+" Maintainer:	Jovi Zhangwei <jovi.zhangwei@gmail.com>
+" First Author:	Jovi Zhangwei <jovi.zhangwei@gmail.com>
+" Last Change:	2013 Dec 19
+
+" For version 5.x: Clear all syntax items
+" For version 6.x: Quit when a syntax file was already loaded
+if version < 600
+  syn clear
+elseif exists("b:current_syntax")
+  finish
+endif
+
+setlocal iskeyword=@,48-57,_,$
+
+syn keyword ktapStatement break continue return
+syn keyword ktapRepeat while for in
+syn keyword ktapConditional if else elseif
+syn keyword ktapDeclaration trace trace_end
+syn keyword ktapIdentifier var
+syn keyword ktapFunction function
+syn match   ktapBraces "[{}\[\]]"
+syn match   ktapParens "[()]"
+syn keyword ktapReserved argstr probename arg0 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
+syn keyword ktapReserved cpu pid tid uid execname
+
+
+syn region ktapTraceDec start="\<trace\>"lc=5 end="{"me=s-1 contains=ktapString,ktapNumber
+syn region ktapTraceDec start="\<trace_end\>"lc=9 end="{"me=s-1 contains=ktapString,ktapNumber
+syn match ktapTrace contained "\<\w\+\>" containedin=ktapTraceDec
+
+syn region ktapFuncDec start="\<function\>"lc=8 end=":\|("me=s-1 contains=ktapString,ktapNumber
+syn match ktapFuncCall contained "\<\w\+\ze\(\s\|\n\)*("
+syn match ktapFunc contained "\<\w\+\>" containedin=ktapFuncDec,ktapFuncCall
+
+syn match ktapStat contained "@\<\w\+\ze\(\s\|\n\)*("
+
+" decimal number
+syn match ktapNumber "\<\d\+\>"
+" octal number
+syn match ktapNumber "\<0\o\+\>" contains=ktapOctalZero
+" Flag the first zero of an octal number as something special
+syn match ktapOctalZero contained "\<0"
+" flag an octal number with wrong digits
+syn match ktapOctalError "\<0\o*[89]\d*"
+" hex number
+syn match ktapNumber "\<0x\x\+\>"
+" numeric arguments
+syn match ktapNumber "\<\$\d\+\>"
+syn match ktapNumber "\<\$#"
+
+syn region ktapString oneline start=+"+ skip=+\\"+ end=+"+ 
+" string arguments
+syn match ktapString "@\d\+\>"
+syn match ktapString "@#"
+syn region ktapString2 matchgroup=ktapString start="\[\z(=*\)\[" end="\]\z1\]" contains=@Spell
+
+" syn keyword ktapTodo contained TODO FIXME XXX
+
+syn match ktapComment "#.*"
+
+" treat ^#! as special
+syn match ktapSharpBang "^#!.*"
+
+
+syn keyword ktapFunc printf print print_hist stack
+syn keyword ktapFunc gettimeofday_us
+syn keyword ktapFunc pairs
+
+
+" Define the default highlighting.
+" For version 5.7 and earlier: only when not done already
+" For version 5.8 and later: only when an item doesn't have highlighting yet
+if version >= 508 || !exists("did_lua_syntax_inits")
+  if version < 508
+    let did_lua_syntax_inits = 1
+    command -nargs=+ HiLink hi link <args>
+  else
+    command -nargs=+ HiLink hi def link <args>
+  endif
+
+  HiLink ktapNumber		Number
+  HiLink ktapOctalZero		PreProc " c.vim does it this way...
+  HiLink ktapOctalError		Error
+  HiLink ktapString		String
+  HiLink ktapString2		String
+  HiLink ktapTodo		Todo
+  HiLink ktapComment		Comment
+  HiLink ktapSharpBang		PreProc
+  HiLink ktapStatement		Statement
+  HiLink ktapConditional	Conditional
+  HiLink ktapRepeat		Repeat
+  HiLink ktapTrace		Function
+  HiLink ktapFunc		Function
+  HiLink ktapStat		Function
+  HiLink ktapFunction		Function
+  HiLink ktapBraces		Function
+  HiLink ktapDeclaration	Typedef
+  HiLink ktapIdentifier		Identifier
+  HiLink ktapReserved		Keyword
+
+  delcommand HiLink
+endif
+
+let b:current_syntax = "ktap"
-- 
1.8.1.4

