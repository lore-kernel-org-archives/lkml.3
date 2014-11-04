Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaKDBqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:46:07 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:38543 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751081AbaKDBqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:46:03 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] ftrace: Document ftrace command line limitations
Date: Mon,  3 Nov 2014 20:45:25 -0500
Message-Id: <1415065525-8267-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the function or function_graph tracers from the command
line, certain command line options have limitations.

Document that only kernel built-in functions can be filtered via
ftrace_filter= or ftrace_graph_filter=. Also document that tracer-
specific options cannot be set on the command line via trace_options.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 Documentation/kernel-parameters.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4c81a86..6f9dfa0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1121,6 +1121,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			list of functions. This list can be changed at run
 			time by the set_ftrace_filter file in the debugfs
 			tracing directory.
+			Only built-in functions can be traced when specified
+			this way.
 
 	ftrace_notrace=[function-list]
 			[FTRACE] Do not trace the functions specified in
@@ -1134,6 +1136,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			function-list is a comma separated list of functions
 			that can be changed at run time by the
 			set_graph_function file in the debugfs tracing directory.
+			Only built-in functions can be traced when specified
+			this way.
 
 	ftrace_graph_notrace=[function-list]
 			[FTRACE] Do not trace from the functions specified in
@@ -3521,6 +3525,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 			      trace_options=stacktrace
 
+			Tracer-specific options are ignored when set this way.
+			For example, the 'func_stack_trace' option cannot be
+			set here.
+
 			See also Documentation/trace/ftrace.txt "trace options"
 			section.
 
-- 
2.1.1

