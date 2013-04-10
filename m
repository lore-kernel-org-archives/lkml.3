Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936646Ab3DJD1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 23:27:35 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:26588 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934499Ab3DJD12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 23:27:28 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH v3 09/12] tracing: remove ftrace(...) function
Date: Wed, 10 Apr 2013 11:26:30 +0800
Message-ID: <1365564393-10972-10-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>
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
index 9964695..bb3fd1b 100644
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


