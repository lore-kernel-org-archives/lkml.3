Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3CUCCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 22:02:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7820 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab3CUCCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 22:02:20 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=l-zTcuvMFTkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=An5aTDfC5mAA:10 a=VNb1y3VvAi-bEhrbFysA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363831337.6345.49.camel@gandalf.local.home>
Subject: Re: [for-next][PATCH 9/9] tracing: Update debugfs README file
From: Steven Rostedt <rostedt@goodmis.org>
To: Keun-O Park <kpark3469@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Date: Wed, 20 Mar 2013 22:02:17 -0400
In-Reply-To: <CA+KhAHadpCEFvLaZDU1ahwDc7zxDJu_rUtAz2a55T_K8EN+G5g@mail.gmail.com>
References: <20130316032412.416651612@goodmis.org>
	 <20130316033143.744766877@goodmis.org> <87hak9jewo.fsf@sejong.aot.lge.com>
	 <CA+KhAHadpCEFvLaZDU1ahwDc7zxDJu_rUtAz2a55T_K8EN+G5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the new version of the patch.

The diff between versions is:

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 83ad596..829b2be 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3311,7 +3311,7 @@ static const char readme_msg[] =
 	"  buffer_size_kb\t- view and modify size of per cpu buffer\n"
 	"  buffer_total_size_kb  - view total size of all cpu buffers\n\n"
 	"  trace_clock\t\t-change the clock used to order events\n"
-	"       local:   Per cpu clock but may not be synced across CPUS\n"
+	"       local:   Per cpu clock but may not be synced across CPUs\n"
 	"      global:   Synced across CPUs but slows tracing down.\n"
 	"     counter:   Not a clock, but just an increment\n"
 	"      uptime:   Jiffy counter from time of boot\n"
@@ -3345,8 +3345,11 @@ static const char readme_msg[] =
 #endif
 	"             example: echo do_fault:traceoff > set_ftrace_filter\n"
 	"                      echo do_trap:traceoff:3 > set_ftrace_filter\n"
-	"             The first one will disable tracing everytime do_fault is hit\n"
-	"             The second will disable tracing at most 3 times whne do_trap is hit\n"
+	"             The first one will disable tracing every time do_fault is hit\n"
+	"             The second will disable tracing at most 3 times when do_trap is hit\n"
+	"               The first time do trap is hit and it disables tracing, the counter\n"
+	"               will decrement to 2. If tracing is already disabled, the counter\n"
+	"               will not decrement. It only decrements when the trigger did work\n"
 	"             To remove trigger without count:\n"
 	"               echo '!<function>:<trigger> > set_ftrace_filter\n"
 	"             To remove trigger with a count:\n"
@@ -3364,8 +3367,8 @@ static const char readme_msg[] =
 	"  max_graph_depth\t- Trace a limited depth of nested calls (0 is unlimited)\n"
 #endif
 #ifdef CONFIG_TRACER_SNAPSHOT
-	"\n  snashot\t\t- Like 'trace' but shows the content of the static snapshot buffer\n"
-	"\t\t\t  Read the contents for more infromation\n"
+	"\n  snapshot\t\t- Like 'trace' but shows the content of the static snapshot buffer\n"
+	"\t\t\t  Read the contents for more information\n"
 #endif
 #ifdef CONFIG_STACKTRACE
 	"  stack_trace\t\t- Shows the max stack trace when active\n"


And here's the real patch:

tracing: Update debugfs README file

Update the README file in debugfs/tracing to something more useful.
What's currently in the file is very old and what it shows doesn't
have much use. Heck, it tells you how to mount debugfs! But to read
this file you would have already needed to mount it.

Replace the file with current up-to-date information. It's rather
limited, but what do you expect from a pseudo README file.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   92 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 78 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3dc7999..829b2be 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3300,20 +3300,84 @@ static const struct file_operations tracing_iter_fops = {
 
 static const char readme_msg[] =
 	"tracing mini-HOWTO:\n\n"
-	"# mount -t debugfs nodev /sys/kernel/debug\n\n"
-	"# cat /sys/kernel/debug/tracing/available_tracers\n"
-	"wakeup wakeup_rt preemptirqsoff preemptoff irqsoff function nop\n\n"
-	"# cat /sys/kernel/debug/tracing/current_tracer\n"
-	"nop\n"
-	"# echo wakeup > /sys/kernel/debug/tracing/current_tracer\n"
-	"# cat /sys/kernel/debug/tracing/current_tracer\n"
-	"wakeup\n"
-	"# cat /sys/kernel/debug/tracing/trace_options\n"
-	"noprint-parent nosym-offset nosym-addr noverbose\n"
-	"# echo print-parent > /sys/kernel/debug/tracing/trace_options\n"
-	"# echo 1 > /sys/kernel/debug/tracing/tracing_on\n"
-	"# cat /sys/kernel/debug/tracing/trace > /tmp/trace.txt\n"
-	"# echo 0 > /sys/kernel/debug/tracing/tracing_on\n"
+	"# echo 0 > tracing_on : quick way to disable tracing\n"
+	"# echo 1 > tracing_on : quick way to re-enable tracing\n\n"
+	" Important files:\n"
+	"  trace\t\t\t- The static contents of the buffer\n"
+	"\t\t\t  To clear the buffer write into this file: echo > trace\n"
+	"  trace_pipe\t\t- A consuming read to see the contents of the buffer\n"
+	"  current_tracer\t- function and latency tracers\n"
+	"  available_tracers\t- list of configured tracers for current_tracer\n"
+	"  buffer_size_kb\t- view and modify size of per cpu buffer\n"
+	"  buffer_total_size_kb  - view total size of all cpu buffers\n\n"
+	"  trace_clock\t\t-change the clock used to order events\n"
+	"       local:   Per cpu clock but may not be synced across CPUs\n"
+	"      global:   Synced across CPUs but slows tracing down.\n"
+	"     counter:   Not a clock, but just an increment\n"
+	"      uptime:   Jiffy counter from time of boot\n"
+	"        perf:   Same clock that perf events use\n"
+#ifdef CONFIG_X86_64
+	"     x86-tsc:   TSC cycle counter\n"
+#endif
+	"\n  trace_marker\t\t- Writes into this file writes into the kernel buffer\n"
+	"  tracing_cpumask\t- Limit which CPUs to trace\n"
+	"  instances\t\t- Make sub-buffers with: mkdir instances/foo\n"
+	"\t\t\t  Remove sub-buffer with rmdir\n"
+	"  trace_options\t\t- Set format or modify how tracing happens\n"
+	"\t\t\t  Disable an option by adding a suffix 'no' to the option name\n"
+#ifdef CONFIG_DYNAMIC_FTRACE
+	"\n  available_filter_functions - list of functions that can be filtered on\n"
+	"  set_ftrace_filter\t- echo function name in here to only trace these functions\n"
+	"            accepts: func_full_name, *func_end, func_begin*, *func_middle*\n"
+	"            modules: Can select a group via module\n"
+	"             Format: :mod:<module-name>\n"
+	"             example: echo :mod:ext3 > set_ftrace_filter\n"
+	"            triggers: a command to perform when function is hit\n"
+	"              Format: <function>:<trigger>[:count]\n"
+	"             trigger: traceon, traceoff\n"
+	"                      enable_event:<system>:<event>\n"
+	"                      disable_event:<system>:<event>\n"
+#ifdef CONFIG_STACKTRACE
+	"                      stacktrace\n"
+#endif
+#ifdef CONFIG_TRACER_SNAPSHOT
+	"                      snapshot\n"
+#endif
+	"             example: echo do_fault:traceoff > set_ftrace_filter\n"
+	"                      echo do_trap:traceoff:3 > set_ftrace_filter\n"
+	"             The first one will disable tracing every time do_fault is hit\n"
+	"             The second will disable tracing at most 3 times when do_trap is hit\n"
+	"               The first time do trap is hit and it disables tracing, the counter\n"
+	"               will decrement to 2. If tracing is already disabled, the counter\n"
+	"               will not decrement. It only decrements when the trigger did work\n"
+	"             To remove trigger without count:\n"
+	"               echo '!<function>:<trigger> > set_ftrace_filter\n"
+	"             To remove trigger with a count:\n"
+	"               echo '!<function>:<trigger>:0 > set_ftrace_filter\n"
+	"  set_ftrace_notrace\t- echo function name in here to never trace.\n"
+	"            accepts: func_full_name, *func_end, func_begin*, *func_middle*\n"
+	"            modules: Can select a group via module command :mod:\n"
+	"            Does not accept triggers\n"
+#endif /* CONFIG_DYNAMIC_FTRACE */
+#ifdef CONFIG_FUNCTION_TRACER
+	"  set_ftrace_pid\t- Write pid(s) to only function trace those pids (function)\n"
+#endif
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	"  set_graph_function\t- Trace the nested calls of a function (function_graph)\n"
+	"  max_graph_depth\t- Trace a limited depth of nested calls (0 is unlimited)\n"
+#endif
+#ifdef CONFIG_TRACER_SNAPSHOT
+	"\n  snapshot\t\t- Like 'trace' but shows the content of the static snapshot buffer\n"
+	"\t\t\t  Read the contents for more information\n"
+#endif
+#ifdef CONFIG_STACKTRACE
+	"  stack_trace\t\t- Shows the max stack trace when active\n"
+	"  stack_max_size\t- Shows current max stack size that was traced\n"
+	"\t\t\t  Write into this file to reset the max size (trigger a new trace)\n"
+#ifdef CONFIG_DYNAMIC_FTRACE
+	"  stack_trace_filter\t- Like set_ftrace_filter but limits what stack_trace traces\n"
+#endif
+#endif /* CONFIG_STACKTRACE */
 ;
 
 static ssize_t
-- 
1.7.10.4



