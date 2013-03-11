Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab3CKHPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:15:30 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:27616 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3CKHP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:15:27 -0400
Message-ID: <513D8445.4030008@huawei.com>
Date: Mon, 11 Mar 2013 15:14:13 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 10/13] tracing: deprecate tracing_is_enabled function
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below two commits removed tracing_enabled file, and make function
tracing_is_enable equal to tracing_is_on.

commit(6752ab4): tracing: Deprecate tracing_enabled for tracing_on
commit(0fb9656): tracing: Make tracing_enabled be equal to tracing_on

so we can deprecate old tracing_is_enabled function completely now.

No functionality change.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace.c              |    7 +------
 kernel/trace/trace.h              |    1 -
 kernel/trace/trace_irqsoff.c      |    2 +-
 kernel/trace/trace_sched_wakeup.c |    2 +-
 4 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c7cc915..96c351a9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -227,11 +227,6 @@ static struct trace_array	max_tr;

 static DEFINE_PER_CPU(struct trace_array_cpu, max_tr_data);

-int tracing_is_enabled(void)
-{
-	return tracing_is_on();
-}
-
 /*
  * trace_buf_size is the size in bytes that is allocated
  * for a buffer. Note, the number of bytes is always rounded
@@ -3494,7 +3489,7 @@ static int tracing_wait_pipe(struct file *filp)
 		 *
 		 * iter->pos will be 0 if we haven't read anything.
 		 */
-		if (!tracing_is_enabled() && iter->pos)
+		if (!tracing_is_on() && iter->pos)
 			break;
 	}

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8489d83..4f2b7d8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -434,7 +434,6 @@ trace_buffer_iter(struct trace_iterator *iter, int cpu)
 }

 int tracer_init(struct tracer *t, struct trace_array *tr);
-int tracing_is_enabled(void);
 void tracing_reset(struct trace_array *tr, int cpu);
 void tracing_reset_online_cpus(struct trace_array *tr);
 void tracing_reset_current(int cpu);
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 713a2ca..ca808ae 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -538,7 +538,7 @@ static int start_irqsoff_tracer(struct trace_array *tr, int graph)
 		ret = register_ftrace_graph(&irqsoff_graph_return,
 					    &irqsoff_graph_entry);

-	if (!ret && tracing_is_enabled())
+	if (!ret && tracing_is_on())
 		tracer_enabled = 1;
 	else
 		tracer_enabled = 0;
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 75aa97f..70629a2 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -144,7 +144,7 @@ static int start_func_tracer(int graph)
 		ret = register_ftrace_graph(&wakeup_graph_return,
 					    &wakeup_graph_entry);

-	if (!ret && tracing_is_enabled())
+	if (!ret && tracing_is_on())
 		tracer_enabled = 1;
 	else
 		tracer_enabled = 0;
-- 
1.7.9.7


