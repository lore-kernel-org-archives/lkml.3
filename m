Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaAZFAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 00:00:37 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:19199 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750861AbaAZFAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 00:00:35 -0500
Message-Id: <20140126050030.289030791@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 25 Jan 2014 23:59:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 2/3] tracing: Fix formatting of trace README file
References: <20140126045941.796589415@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-formatting-of-trace-README-file.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Fix the formatting of the README file in the trace debugfs to fit in
an 80 character window.

Also add a comment about the event trigger counter with regards to
traceon and traceoff.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 116 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 64 insertions(+), 52 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2ced5e5..7857ea9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3519,91 +3519,103 @@ static const char readme_msg[] =
 	"  instances\t\t- Make sub-buffers with: mkdir instances/foo\n"
 	"\t\t\t  Remove sub-buffer with rmdir\n"
 	"  trace_options\t\t- Set format or modify how tracing happens\n"
-	"\t\t\t  Disable an option by adding a suffix 'no' to the option name\n"
+	"\t\t\t  Disable an option by adding a suffix 'no' to the\n"
+	"\t\t\t  option name\n"
 #ifdef CONFIG_DYNAMIC_FTRACE
 	"\n  available_filter_functions - list of functions that can be filtered on\n"
-	"  set_ftrace_filter\t- echo function name in here to only trace these functions\n"
-	"             accepts: func_full_name, *func_end, func_begin*, *func_middle*\n"
-	"             modules: Can select a group via module\n"
-	"              Format: :mod:<module-name>\n"
-	"             example: echo :mod:ext3 > set_ftrace_filter\n"
-	"            triggers: a command to perform when function is hit\n"
-	"              Format: <function>:<trigger>[:count]\n"
-	"             trigger: traceon, traceoff\n"
-	"                      enable_event:<system>:<event>\n"
-	"                      disable_event:<system>:<event>\n"
+	"  set_ftrace_filter\t- echo function name in here to only trace these\n"
+	"\t\t\t  functions\n"
+	"\t     accepts: func_full_name, *func_end, func_begin*, *func_middle*\n"
+	"\t     modules: Can select a group via module\n"
+	"\t      Format: :mod:<module-name>\n"
+	"\t     example: echo :mod:ext3 > set_ftrace_filter\n"
+	"\t    triggers: a command to perform when function is hit\n"
+	"\t      Format: <function>:<trigger>[:count]\n"
+	"\t     trigger: traceon, traceoff\n"
+	"\t\t      enable_event:<system>:<event>\n"
+	"\t\t      disable_event:<system>:<event>\n"
 #ifdef CONFIG_STACKTRACE
-	"                      stacktrace\n"
+	"\t\t      stacktrace\n"
 #endif
 #ifdef CONFIG_TRACER_SNAPSHOT
-	"                      snapshot\n"
+	"\t\t      snapshot\n"
 #endif
-	"             example: echo do_fault:traceoff > set_ftrace_filter\n"
-	"                      echo do_trap:traceoff:3 > set_ftrace_filter\n"
-	"             The first one will disable tracing every time do_fault is hit\n"
-	"             The second will disable tracing at most 3 times when do_trap is hit\n"
-	"               The first time do trap is hit and it disables tracing, the counter\n"
-	"               will decrement to 2. If tracing is already disabled, the counter\n"
-	"               will not decrement. It only decrements when the trigger did work\n"
-	"             To remove trigger without count:\n"
-	"               echo '!<function>:<trigger> > set_ftrace_filter\n"
-	"             To remove trigger with a count:\n"
-	"               echo '!<function>:<trigger>:0 > set_ftrace_filter\n"
+	"\t     example: echo do_fault:traceoff > set_ftrace_filter\n"
+	"\t              echo do_trap:traceoff:3 > set_ftrace_filter\n"
+	"\t     The first one will disable tracing every time do_fault is hit\n"
+	"\t     The second will disable tracing at most 3 times when do_trap is hit\n"
+	"\t       The first time do trap is hit and it disables tracing, the\n"
+	"\t       counter will decrement to 2. If tracing is already disabled,\n"
+	"\t       the counter will not decrement. It only decrements when the\n"
+	"\t       trigger did work\n"
+	"\t     To remove trigger without count:\n"
+	"\t       echo '!<function>:<trigger> > set_ftrace_filter\n"
+	"\t     To remove trigger with a count:\n"
+	"\t       echo '!<function>:<trigger>:0 > set_ftrace_filter\n"
 	"  set_ftrace_notrace\t- echo function name in here to never trace.\n"
-	"            accepts: func_full_name, *func_end, func_begin*, *func_middle*\n"
-	"            modules: Can select a group via module command :mod:\n"
-	"            Does not accept triggers\n"
+	"\t    accepts: func_full_name, *func_end, func_begin*, *func_middle*\n"
+	"\t    modules: Can select a group via module command :mod:\n"
+	"\t    Does not accept triggers\n"
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #ifdef CONFIG_FUNCTION_TRACER
-	"  set_ftrace_pid\t- Write pid(s) to only function trace those pids (function)\n"
+	"  set_ftrace_pid\t- Write pid(s) to only function trace those pids\n"
+	"\t\t    (function)\n"
 #endif
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	"  set_graph_function\t- Trace the nested calls of a function (function_graph)\n"
 	"  max_graph_depth\t- Trace a limited depth of nested calls (0 is unlimited)\n"
 #endif
 #ifdef CONFIG_TRACER_SNAPSHOT
-	"\n  snapshot\t\t- Like 'trace' but shows the content of the static snapshot buffer\n"
-	"\t\t\t  Read the contents for more information\n"
+	"\n  snapshot\t\t- Like 'trace' but shows the content of the static\n"
+	"\t\t\t  snapshot buffer. Read the contents for more\n"
+	"\t\t\t  information\n"
 #endif
 #ifdef CONFIG_STACK_TRACER
 	"  stack_trace\t\t- Shows the max stack trace when active\n"
 	"  stack_max_size\t- Shows current max stack size that was traced\n"
-	"\t\t\t  Write into this file to reset the max size (trigger a new trace)\n"
+	"\t\t\t  Write into this file to reset the max size (trigger a\n"
+	"\t\t\t  new trace)\n"
 #ifdef CONFIG_DYNAMIC_FTRACE
-	"  stack_trace_filter\t- Like set_ftrace_filter but limits what stack_trace traces\n"
+	"  stack_trace_filter\t- Like set_ftrace_filter but limits what stack_trace\n"
+	"\t\t\t  traces\n"
 #endif
 #endif /* CONFIG_STACK_TRACER */
 	"  events/\t\t- Directory containing all trace event subsystems:\n"
 	"      enable\t\t- Write 0/1 to enable/disable tracing of all events\n"
 	"  events/<system>/\t- Directory containing all trace events for <system>:\n"
-	"      enable\t\t- Write 0/1 to enable/disable tracing of all <system> events\n"
+	"      enable\t\t- Write 0/1 to enable/disable tracing of all <system>\n"
+	"\t\t\t  events\n"
 	"      filter\t\t- If set, only events passing filter are traced\n"
-	"  events/<system>/<event>/\t- Directory containing control files for <event>:\n"
+	"  events/<system>/<event>/\t- Directory containing control files for\n"
+	"\t\t\t  <event>:\n"
 	"      enable\t\t- Write 0/1 to enable/disable tracing of <event>\n"
 	"      filter\t\t- If set, only events passing filter are traced\n"
 	"      trigger\t\t- If set, a command to perform when event is hit\n"
-	"            Format: <trigger>[:count][if <filter>]\n"
-	"           trigger: traceon, traceoff\n"
-	"                    enable_event:<system>:<event>\n"
-	"                    disable_event:<system>:<event>\n"
+	"\t    Format: <trigger>[:count][if <filter>]\n"
+	"\t   trigger: traceon, traceoff\n"
+	"\t            enable_event:<system>:<event>\n"
+	"\t            disable_event:<system>:<event>\n"
 #ifdef CONFIG_STACKTRACE
-	"                    stacktrace\n"
+	"\t\t    stacktrace\n"
 #endif
 #ifdef CONFIG_TRACER_SNAPSHOT
-	"                    snapshot\n"
+	"\t\t    snapshot\n"
 #endif
-	"           example: echo traceoff > events/block/block_unplug/trigger\n"
-	"                    echo traceoff:3 > events/block/block_unplug/trigger\n"
-	"                    echo 'enable_event:kmem:kmalloc:3 if nr_rq > 1' > events/block/block_unplug/trigger\n"
-	"           The first disables tracing every time block_unplug is hit.\n"
-	"           The second disables tracing the first 3 times block_unplug is hit.\n"
-	"           The third enables the kmalloc event the first 3 times block_unplug\n"
-	"             is hit and has value of greater than 1 for the 'nr_rq' event field.\n"
-	"           To remove a trigger without a count:\n"
-	"             echo '!<trigger> > <system>/<event>/trigger\n"
-	"           To remove a trigger with a count:\n"
-	"             echo '!<trigger>:0 > <system>/<event>/trigger\n"
-	"           Filters can be ignored when removing a trigger.\n"
+	"\t   example: echo traceoff > events/block/block_unplug/trigger\n"
+	"\t            echo traceoff:3 > events/block/block_unplug/trigger\n"
+	"\t            echo 'enable_event:kmem:kmalloc:3 if nr_rq > 1' > \\\n"
+	"\t                  events/block/block_unplug/trigger\n"
+	"\t   The first disables tracing every time block_unplug is hit.\n"
+	"\t   The second disables tracing the first 3 times block_unplug is hit.\n"
+	"\t   The third enables the kmalloc event the first 3 times block_unplug\n"
+	"\t     is hit and has value of greater than 1 for the 'nr_rq' event field.\n"
+	"\t   Like function triggers, the counter is only decremented if it\n"
+	"\t    enabled or disabled tracing.\n"
+	"\t   To remove a trigger without a count:\n"
+	"\t     echo '!<trigger> > <system>/<event>/trigger\n"
+	"\t   To remove a trigger with a count:\n"
+	"\t     echo '!<trigger>:0 > <system>/<event>/trigger\n"
+	"\t   Filters can be ignored when removing a trigger.\n"
 ;
 
 static ssize_t
-- 
1.8.4.3


