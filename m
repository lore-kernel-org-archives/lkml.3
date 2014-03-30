Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaC3NcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 09:32:08 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:62251 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaC3NcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 09:32:06 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        PaX Team <pageexec@freemail.hu>
Subject: [PATCH] ftrace: Statically initialize pm notifier block
Date: Sun, 30 Mar 2014 15:31:50 +0200
Message-Id: <1396186310-3156-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of initializing the pm notifier block in register_ftrace_graph(),
initialize it statically. This safes us some code.

Found in the PaX patch, written by the PaX Team.

Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 kernel/trace/ftrace.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cd7f76d1eb..a4d74eb000 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4909,7 +4909,6 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 static int ftrace_graph_active;
-static struct notifier_block ftrace_suspend_notifier;
 
 int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace)
 {
@@ -5086,6 +5085,10 @@ static void update_function_graph_func(void)
 		ftrace_graph_entry = ftrace_graph_entry_test;
 }
 
+static struct notifier_block ftrace_suspend_notifier = {
+	.notifier_call = ftrace_suspend_notifier_call,
+};
+
 int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 			trace_func_graph_ent_t entryfunc)
 {
@@ -5099,7 +5102,6 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 		goto out;
 	}
 
-	ftrace_suspend_notifier.notifier_call = ftrace_suspend_notifier_call;
 	register_pm_notifier(&ftrace_suspend_notifier);
 
 	ftrace_graph_active++;
-- 
1.7.10.4

