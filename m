Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3C0JuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:50:04 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45833 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab3C0JuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:50:00 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 10/14] tracing: remove ftrace(...) function
Date: Wed, 27 Mar 2013 17:48:52 +0800
Message-ID: <1364377737-10540-12-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

The only caller of function ftrace(...) was removed at long time ago,
so remove the function body also.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace.c |    9 ---------
 kernel/trace/trace.h |    5 -----
 2 files changed, 14 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 224b152..dd0c122 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1534,15 +1534,6 @@ trace_function(struct trace_array *tr,
 		__buffer_unlock_commit(buffer, event);
 }
 
-void
-ftrace(struct trace_array *tr, struct trace_array_cpu *data,
-       unsigned long ip, unsigned long parent_ip, unsigned long flags,
-       int pc)
-{
-	if (likely(!atomic_read(&data->disabled)))
-		trace_function(tr, ip, parent_ip, flags, pc);
-}
-
 #ifdef CONFIG_STACKTRACE
 
 #define FTRACE_STACK_MAX_ENTRIES (PAGE_SIZE / sizeof(unsigned long))
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 398ff9e..a244fbc 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -445,11 +445,6 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu);
 
 void poll_wait_pipe(struct trace_iterator *iter);
 
-void ftrace(struct trace_array *tr,
-			    struct trace_array_cpu *data,
-			    unsigned long ip,
-			    unsigned long parent_ip,
-			    unsigned long flags, int pc);
 void tracing_sched_switch_trace(struct trace_array *tr,
 				struct task_struct *prev,
 				struct task_struct *next,
-- 
1.7.9.7


