Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaAZFAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 00:00:36 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:28357 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750885AbaAZFAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 00:00:35 -0500
Message-Id: <20140126050030.145193258@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 25 Jan 2014 23:59:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [for-next][PATCH 1/3] tracing/README: Add event file usage to tracing mini-HOWTO
References: <20140126045941.796589415@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-README-Add-event-file-usage-to-tracing-mini-.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

It would be useful to have a cheat-sheet for everything under
tracing/events/ alongside the existing text describing the other files
in the tracing/ dir.

Add short descriptions of the directories and files under events/
along with examples, similar to the existing text for the other files
in tracing/.

Also clean up a few minor alignment problems noticed when adding the
new text.

Link: http://lkml.kernel.org/r/1389993104.3040.445.camel@empanada

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 20c755e..2ced5e5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3523,9 +3523,9 @@ static const char readme_msg[] =
 #ifdef CONFIG_DYNAMIC_FTRACE
 	"\n  available_filter_functions - list of functions that can be filtered on\n"
 	"  set_ftrace_filter\t- echo function name in here to only trace these functions\n"
-	"            accepts: func_full_name, *func_end, func_begin*, *func_middle*\n"
-	"            modules: Can select a group via module\n"
-	"             Format: :mod:<module-name>\n"
+	"             accepts: func_full_name, *func_end, func_begin*, *func_middle*\n"
+	"             modules: Can select a group via module\n"
+	"              Format: :mod:<module-name>\n"
 	"             example: echo :mod:ext3 > set_ftrace_filter\n"
 	"            triggers: a command to perform when function is hit\n"
 	"              Format: <function>:<trigger>[:count]\n"
@@ -3573,6 +3573,37 @@ static const char readme_msg[] =
 	"  stack_trace_filter\t- Like set_ftrace_filter but limits what stack_trace traces\n"
 #endif
 #endif /* CONFIG_STACK_TRACER */
+	"  events/\t\t- Directory containing all trace event subsystems:\n"
+	"      enable\t\t- Write 0/1 to enable/disable tracing of all events\n"
+	"  events/<system>/\t- Directory containing all trace events for <system>:\n"
+	"      enable\t\t- Write 0/1 to enable/disable tracing of all <system> events\n"
+	"      filter\t\t- If set, only events passing filter are traced\n"
+	"  events/<system>/<event>/\t- Directory containing control files for <event>:\n"
+	"      enable\t\t- Write 0/1 to enable/disable tracing of <event>\n"
+	"      filter\t\t- If set, only events passing filter are traced\n"
+	"      trigger\t\t- If set, a command to perform when event is hit\n"
+	"            Format: <trigger>[:count][if <filter>]\n"
+	"           trigger: traceon, traceoff\n"
+	"                    enable_event:<system>:<event>\n"
+	"                    disable_event:<system>:<event>\n"
+#ifdef CONFIG_STACKTRACE
+	"                    stacktrace\n"
+#endif
+#ifdef CONFIG_TRACER_SNAPSHOT
+	"                    snapshot\n"
+#endif
+	"           example: echo traceoff > events/block/block_unplug/trigger\n"
+	"                    echo traceoff:3 > events/block/block_unplug/trigger\n"
+	"                    echo 'enable_event:kmem:kmalloc:3 if nr_rq > 1' > events/block/block_unplug/trigger\n"
+	"           The first disables tracing every time block_unplug is hit.\n"
+	"           The second disables tracing the first 3 times block_unplug is hit.\n"
+	"           The third enables the kmalloc event the first 3 times block_unplug\n"
+	"             is hit and has value of greater than 1 for the 'nr_rq' event field.\n"
+	"           To remove a trigger without a count:\n"
+	"             echo '!<trigger> > <system>/<event>/trigger\n"
+	"           To remove a trigger with a count:\n"
+	"             echo '!<trigger>:0 > <system>/<event>/trigger\n"
+	"           Filters can be ignored when removing a trigger.\n"
 ;
 
 static ssize_t
-- 
1.8.4.3


