Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaKDRq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:46:28 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43728 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751228AbaKDRqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:46:24 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2] ftrace: Document filter and option limitations
Date: Tue,  4 Nov 2014 12:46:05 -0500
Message-Id: <1415123165-3020-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the function or function_graph tracers from the command
line, certain command line options have limitations.

Document that only kernel built-in functions can be filtered via
ftrace_filter= or ftrace_graph_filter=. Document that tracer-specific
options cannot be set on the command line via trace_options.
Document that ftrace cannot do late binding for function
filters.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 Documentation/kernel-parameters.txt | 6 ++++++
 Documentation/trace/ftrace.txt      | 7 +++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4c81a86..d098ead 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1121,6 +1121,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			list of functions. This list can be changed at run
 			time by the set_ftrace_filter file in the debugfs
 			tracing directory.
+			Only kernel built-in functions can be filtered.
 
 	ftrace_notrace=[function-list]
 			[FTRACE] Do not trace the functions specified in
@@ -1134,6 +1135,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			function-list is a comma separated list of functions
 			that can be changed at run time by the
 			set_graph_function file in the debugfs tracing directory.
+			Only kernel built-in functions can be filtered.
 
 	ftrace_graph_notrace=[function-list]
 			[FTRACE] Do not trace from the functions specified in
@@ -3521,6 +3523,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 			      trace_options=stacktrace
 
+			Tracer-specific options are ignored when set this way.
+			For example, the 'func_stack_trace' option cannot be
+			set here.
+
 			See also Documentation/trace/ftrace.txt "trace options"
 			section.
 
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 4da4261..d540273 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -188,7 +188,8 @@ of ftrace. Here is a list of some of the key files:
 	in with practically no overhead in performance.  This also
 	has a side effect of enabling or disabling specific functions
 	to be traced. Echoing names of functions into this file
-	will limit the trace to only those functions.
+	will limit the trace to only those functions. Only already-
+	loaded functions can be filtered.
 
 	This interface also allows for commands to be used. See the
 	"Filter commands" section for more details.
@@ -208,7 +209,9 @@ of ftrace. Here is a list of some of the key files:
 
 	Set a "trigger" function where tracing should start
 	with the function graph tracer (See the section
-	"dynamic ftrace" for more details).
+	"dynamic ftrace" for more details). As with set_ftrace_filter,
+	only names of already-loaded functions can be written to
+	this file.
 
   available_filter_functions:
 
-- 
2.1.1

