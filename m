Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab3CFOkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:40:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44317 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758234Ab3CFOkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:40:10 -0500
Date: Wed, 6 Mar 2013 06:38:53 -0800
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-c82ba9fa7588dfd02d4dc99ad1af486304bc424c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <5135A79F.8090502@huawei.com>
References: <5135A79F.8090502@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Move struct sched_class to kernel/sched/
 sched.h
Git-Commit-ID: c82ba9fa7588dfd02d4dc99ad1af486304bc424c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 06:38:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c82ba9fa7588dfd02d4dc99ad1af486304bc424c
Gitweb:     http://git.kernel.org/tip/c82ba9fa7588dfd02d4dc99ad1af486304bc424c
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Tue, 5 Mar 2013 16:06:55 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Mar 2013 11:24:33 +0100

sched: Move struct sched_class to kernel/sched/sched.h

It's used internally only.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5135A79F.8090502@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
