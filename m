Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaBUCx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:53:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:23969 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753221AbaBUCuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:05 -0500
Message-Id: <20140221025002.829581354@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [for-next][PATCH 12/18] tracing/uprobes: Rename uprobe_{trace,perf}_print() functions
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0012-tracing-uprobes-Rename-uprobe_-trace-perf-_print-fun.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The uprobe_{trace,perf}_print functions are misnomers since what they
do is not printing.  There's also a real print function named
print_uprobe_event() so they'll only increase confusion IMHO.

Rename them with double underscores to follow convention of kprobe.

Link: http://lkml.kernel.org/r/1389946120-19610-2-git-send-email-namhyung@kernel.org

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 79e52d9..c5d2612 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -758,7 +758,7 @@ static void uprobe_buffer_put(struct uprobe_cpu_buffer *ucb)
 	mutex_unlock(&ucb->mutex);
 }
 
-static void uprobe_trace_print(struct trace_uprobe *tu,
+static void __uprobe_trace_func(struct trace_uprobe *tu,
 				unsigned long func, struct pt_regs *regs)
 {
 	struct uprobe_trace_entry_head *entry;
@@ -807,14 +807,14 @@ out:
 static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 {
 	if (!is_ret_probe(tu))
-		uprobe_trace_print(tu, 0, regs);
+		__uprobe_trace_func(tu, 0, regs);
 	return 0;
 }
 
 static void uretprobe_trace_func(struct trace_uprobe *tu, unsigned long func,
 				struct pt_regs *regs)
 {
-	uprobe_trace_print(tu, func, regs);
+	__uprobe_trace_func(tu, func, regs);
 }
 
 /* Event entry printers */
@@ -1014,7 +1014,7 @@ static bool uprobe_perf_filter(struct uprobe_consumer *uc,
 	return ret;
 }
 
-static void uprobe_perf_print(struct trace_uprobe *tu,
+static void __uprobe_perf_func(struct trace_uprobe *tu,
 				unsigned long func, struct pt_regs *regs)
 {
 	struct ftrace_event_call *call = &tu->tp.call;
@@ -1078,14 +1078,14 @@ static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
 		return UPROBE_HANDLER_REMOVE;
 
 	if (!is_ret_probe(tu))
-		uprobe_perf_print(tu, 0, regs);
+		__uprobe_perf_func(tu, 0, regs);
 	return 0;
 }
 
 static void uretprobe_perf_func(struct trace_uprobe *tu, unsigned long func,
 				struct pt_regs *regs)
 {
-	uprobe_perf_print(tu, func, regs);
+	__uprobe_perf_func(tu, func, regs);
 }
 #endif	/* CONFIG_PERF_EVENTS */
 
-- 
1.8.5.3


