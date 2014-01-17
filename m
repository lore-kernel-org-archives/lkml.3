Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaAQVLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 16:11:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:11224 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbaAQVLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 16:11:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,676,1384329600"; 
   d="scan'208";a="468478577"
Message-ID: <1389993104.3040.445.camel@empanada>
Subject: [PATCH] tracing/README: Add event file usage to tracing mini-HOWTO
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 17 Jan 2014 15:11:44 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be useful to have a cheat-sheet for everything under
tracing/events/ alongside the existing text describing the other files
in the tracing/ dir.

Add short descriptions of the directories and files under events/
along with examples, similar to the existing text for the other files
in tracing/.

Also clean up a few minor alignment problems noticed when adding the
new text.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 kernel/trace/trace.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e32a2f4..058c0ee 100644
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
1.8.3.1



