Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaAQIJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 03:09:03 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60517 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaAQIIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 03:08:48 -0500
X-AuditID: 9c930197-b7b7cae000000e34-07-52d8e50b24bd
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 1/5] tracing/uprobes: Rename uprobe_{trace,perf}_print() functions
Date: Fri, 17 Jan 2014 17:08:36 +0900
Message-Id: <1389946120-19610-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389946120-19610-1-git-send-email-namhyung@kernel.org>
References: <1389946120-19610-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uprobe_{trace,perf}_print functions are misnomers since what they
do is not printing.  There's also a real print function named
print_uprobe_event() so they'll only increase confusion IMHO.

Rename them with double underscores to follow convention of kprobe.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_uprobe.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 79e52d93860b..c5d2612bf233 100644
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
1.7.11.7

