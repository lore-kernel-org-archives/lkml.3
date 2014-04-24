Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbaDXQGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:06:05 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:17474 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758620AbaDXQD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:03:26 -0400
Message-Id: <20140424160320.831795066@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:02:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, PaX Team <pageexec@freemail.hu>,
        Mathias Krause <minipli@googlemail.com>
Subject: [for-next][PATCH 7/8] ftrace: Statically initialize pm notifier block
References: <20140424160232.271454710@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0007-ftrace-Statically-initialize-pm-notifier-block.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

Instead of initializing the pm notifier block in register_ftrace_graph(),
initialize it statically. This safes us some code.

Found in the PaX patch, written by the PaX Team.

Link: http://lkml.kernel.org/p/1396186310-3156-1-git-send-email-minipli@googlemail.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8f61ef7..846888e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4860,7 +4860,6 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 static int ftrace_graph_active;
-static struct notifier_block ftrace_suspend_notifier;
 
 int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace)
 {
@@ -5036,6 +5035,10 @@ static void update_function_graph_func(void)
 		ftrace_graph_entry = ftrace_graph_entry_test;
 }
 
+static struct notifier_block ftrace_suspend_notifier = {
+	.notifier_call = ftrace_suspend_notifier_call,
+};
+
 int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 			trace_func_graph_ent_t entryfunc)
 {
@@ -5049,7 +5052,6 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 		goto out;
 	}
 
-	ftrace_suspend_notifier.notifier_call = ftrace_suspend_notifier_call;
 	register_pm_notifier(&ftrace_suspend_notifier);
 
 	ftrace_graph_active++;
-- 
1.8.5.3


