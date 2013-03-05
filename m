Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab3CEIHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:07:40 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:37180 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3CEIHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:07:38 -0500
Message-ID: <5135A79F.8090502@huawei.com>
Date: Tue, 5 Mar 2013 16:06:55 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/9] sched: Move struct sched_class to kernel/sched/sched.h
References: <5135A736.8050104@huawei.com>
In-Reply-To: <5135A736.8050104@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's used internally only.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/sched.h | 59 ---------------------------------------------------
 kernel/sched/sched.h  | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 59 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 863b505..04b834f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -917,65 +917,6 @@ struct mempolicy;
 struct pipe_inode_info;
 struct uts_namespace;
 
-struct rq;
-struct sched_domain;
-
-#define ENQUEUE_WAKEUP		1
-#define ENQUEUE_HEAD		2
-#ifdef CONFIG_SMP
-#define ENQUEUE_WAKING		4	/* sched_class::task_waking was called */
-#else
-#define ENQUEUE_WAKING		0
-#endif
-
-#define DEQUEUE_SLEEP		1
-
-struct sched_class {
-	const struct sched_class *next;
-
-	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
-	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
-	void (*yield_task) (struct rq *rq);
-	bool (*yield_to_task) (struct rq *rq, struct task_struct *p, bool preempt);
-
-	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
-
-	struct task_struct * (*pick_next_task) (struct rq *rq);
-	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
-
-#ifdef CONFIG_SMP
-	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
-	void (*migrate_task_rq)(struct task_struct *p, int next_cpu);
-
-	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
-	void (*post_schedule) (struct rq *this_rq);
-	void (*task_waking) (struct task_struct *task);
-	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
-
-	void (*set_cpus_allowed)(struct task_struct *p,
-				 const struct cpumask *newmask);
-
-	void (*rq_online)(struct rq *rq);
-	void (*rq_offline)(struct rq *rq);
-#endif
-
-	void (*set_curr_task) (struct rq *rq);
-	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
-	void (*task_fork) (struct task_struct *p);
-
-	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
-	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
-	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
-			     int oldprio);
-
-	unsigned int (*get_rr_interval) (struct rq *rq,
-					 struct task_struct *task);
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	void (*task_move_group) (struct task_struct *p, int on_rq);
-#endif
-};
-
 struct load_weight {
 	unsigned long weight, inv_weight;
 };
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4e5c2af..eca526d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -951,6 +951,61 @@ enum cpuacct_stat_index {
 	CPUACCT_STAT_NSTATS,
 };
 
+#define ENQUEUE_WAKEUP		1
+#define ENQUEUE_HEAD		2
+#ifdef CONFIG_SMP
+#define ENQUEUE_WAKING		4	/* sched_class::task_waking was called */
+#else
+#define ENQUEUE_WAKING		0
+#endif
+
+#define DEQUEUE_SLEEP		1
+
+struct sched_class {
+	const struct sched_class *next;
+
+	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
+	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
+	void (*yield_task) (struct rq *rq);
+	bool (*yield_to_task) (struct rq *rq, struct task_struct *p, bool preempt);
+
+	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
+
+	struct task_struct * (*pick_next_task) (struct rq *rq);
+	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
+
+#ifdef CONFIG_SMP
+	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
+	void (*migrate_task_rq)(struct task_struct *p, int next_cpu);
+
+	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
+	void (*post_schedule) (struct rq *this_rq);
+	void (*task_waking) (struct task_struct *task);
+	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
+
+	void (*set_cpus_allowed)(struct task_struct *p,
+				 const struct cpumask *newmask);
+
+	void (*rq_online)(struct rq *rq);
+	void (*rq_offline)(struct rq *rq);
+#endif
+
+	void (*set_curr_task) (struct rq *rq);
+	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
+	void (*task_fork) (struct task_struct *p);
+
+	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
+	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
+	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
+			     int oldprio);
+
+	unsigned int (*get_rr_interval) (struct rq *rq,
+					 struct task_struct *task);
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	void (*task_move_group) (struct task_struct *p, int on_rq);
+#endif
+};
 
 #define sched_class_highest (&stop_sched_class)
 #define for_each_class(class) \
-- 
1.8.0.2
