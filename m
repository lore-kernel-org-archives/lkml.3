Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaATMk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:40:57 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51835 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaATMkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:40:09 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC v2 PATCH 11/11] sched: un-export struct sched_domain
Date: Mon, 20 Jan 2014 12:39:48 +0000
Message-Id: <1390221588-20473-12-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
References: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 20 Jan 2014 12:40:06.0566 (UTC) FILETIME=[BF6DB460:01CF15DC]
X-MC-Unique: 114012012400709701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s0KCf7aP003790

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

Since all occurrences of SD_FOO_INIT have been deleted, there is no
need to export struct sched_domain any more.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 include/linux/sched.h |   87 ----------------------------
 kernel/sched/sched.h  |  153 ++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 119 insertions(+), 121 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 055d79e594ef..cd86c651f476 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -801,93 +801,6 @@ struct sched_domain_attr {
 
 extern int sched_domain_level_max;
 
-struct sched_group;
-
-struct sched_domain {
-	/* These fields must be setup */
-	struct sched_domain *parent;	/* top domain must be null terminated */
-	struct sched_domain *child;	/* bottom domain must be null terminated */
-	struct sched_group *groups;	/* the balancing groups of the domain */
-	unsigned long min_interval;	/* Minimum balance interval ms */
-	unsigned long max_interval;	/* Maximum balance interval ms */
-	unsigned int busy_factor;	/* less balancing by factor if busy */
-	unsigned int imbalance_pct;	/* No balance until over watermark */
-	unsigned int cache_nice_tries;	/* Leave cache hot tasks for # tries */
-	unsigned int busy_idx;
-	unsigned int idle_idx;
-	unsigned int newidle_idx;
-	unsigned int wake_idx;
-	unsigned int forkexec_idx;
-	unsigned int smt_gain;
-
-	int nohz_idle;			/* NOHZ IDLE status */
-	int flags;			/* See SD_* */
-	int level;
-
-	/* Runtime fields. */
-	unsigned long last_balance;	/* init to jiffies. units in jiffies */
-	unsigned int balance_interval;	/* initialise to 1. units in ms. */
-	unsigned int nr_balance_failed; /* initialise to 0 */
-
-	/* idle_balance() stats */
-	u64 max_newidle_lb_cost;
-	unsigned long next_decay_max_lb_cost;
-
-#ifdef CONFIG_SCHEDSTATS
-	/* load_balance() stats */
-	unsigned int lb_count[CPU_MAX_IDLE_TYPES];
-	unsigned int lb_failed[CPU_MAX_IDLE_TYPES];
-	unsigned int lb_balanced[CPU_MAX_IDLE_TYPES];
-	unsigned int lb_imbalance[CPU_MAX_IDLE_TYPES];
-	unsigned int lb_gained[CPU_MAX_IDLE_TYPES];
-	unsigned int lb_hot_gained[CPU_MAX_IDLE_TYPES];
-	unsigned int lb_nobusyg[CPU_MAX_IDLE_TYPES];
-	unsigned int lb_nobusyq[CPU_MAX_IDLE_TYPES];
-
-	/* Active load balancing */
-	unsigned int alb_count;
-	unsigned int alb_failed;
-	unsigned int alb_pushed;
-
-	/* SD_BALANCE_EXEC stats */
-	unsigned int sbe_count;
-	unsigned int sbe_balanced;
-	unsigned int sbe_pushed;
-
-	/* SD_BALANCE_FORK stats */
-	unsigned int sbf_count;
-	unsigned int sbf_balanced;
-	unsigned int sbf_pushed;
-
-	/* try_to_wake_up() stats */
-	unsigned int ttwu_wake_remote;
-	unsigned int ttwu_move_affine;
-	unsigned int ttwu_move_balance;
-#endif
-#ifdef CONFIG_SCHED_DEBUG
-	char *name;
-#endif
-	union {
-		void *private;		/* used during construction */
-		struct rcu_head rcu;	/* used during destruction */
-	};
-
-	unsigned int span_weight;
-	/*
-	 * Span of all CPUs in this domain.
-	 *
-	 * NOTE: this field is variable length. (Allocated dynamically
-	 * by attaching extra space to the end of the structure,
-	 * depending on how many CPUs the kernel has booted up with)
-	 */
-	unsigned long span[0];
-};
-
-static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
-{
-	return to_cpumask(sd->span);
-}
-
 extern void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 				    struct sched_domain_attr *dattr_new);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fcf2d4317217..796b7f99743d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -585,40 +585,6 @@ extern int migrate_swap(struct task_struct *, struct task_struct *);
 
 #define for_each_lower_domain(sd) for (; sd; sd = sd->child)
 
-/**
- * highest_flag_domain - Return highest sched_domain containing flag.
- * @cpu:	The cpu whose highest level of sched domain is to
- *		be returned.
- * @flag:	The flag to check for the highest sched_domain
- *		for the given cpu.
- *
- * Returns the highest sched_domain of a cpu which contains the given flag.
- */
-static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
-{
-	struct sched_domain *sd, *hsd = NULL;
-
-	for_each_domain(cpu, sd) {
-		if (!(sd->flags & flag))
-			break;
-		hsd = sd;
-	}
-
-	return hsd;
-}
-
-static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
-{
-	struct sched_domain *sd;
-
-	for_each_domain(cpu, sd) {
-		if (sd->flags & flag)
-			break;
-	}
-
-	return sd;
-}
-
 DECLARE_PER_CPU(struct sched_domain *, sd_llc);
 DECLARE_PER_CPU(int, sd_llc_size);
 DECLARE_PER_CPU(int, sd_llc_id);
@@ -660,11 +626,130 @@ struct sched_group {
 	unsigned long cpumask[0];
 };
 
+struct sched_domain {
+	/* These fields must be setup */
+	struct sched_domain *parent;	/* top domain must be null terminated */
+	struct sched_domain *child;	/* bottom domain must be null terminated */
+	struct sched_group *groups;	/* the balancing groups of the domain */
+	unsigned long min_interval;	/* Minimum balance interval ms */
+	unsigned long max_interval;	/* Maximum balance interval ms */
+	unsigned int busy_factor;	/* less balancing by factor if busy */
+	unsigned int imbalance_pct;	/* No balance until over watermark */
+	unsigned int cache_nice_tries;	/* Leave cache hot tasks for # tries */
+	unsigned int busy_idx;
+	unsigned int idle_idx;
+	unsigned int newidle_idx;
+	unsigned int wake_idx;
+	unsigned int forkexec_idx;
+	unsigned int smt_gain;
+
+	int nohz_idle;			/* NOHZ IDLE status */
+	int flags;			/* See SD_* */
+	int level;
+
+	/* Runtime fields. */
+	unsigned long last_balance;	/* init to jiffies. units in jiffies */
+	unsigned int balance_interval;	/* initialise to 1. units in ms. */
+	unsigned int nr_balance_failed; /* initialise to 0 */
+
+	/* idle_balance() stats */
+	u64 max_newidle_lb_cost;
+	unsigned long next_decay_max_lb_cost;
+
+#ifdef CONFIG_SCHEDSTATS
+	/* load_balance() stats */
+	unsigned int lb_count[CPU_MAX_IDLE_TYPES];
+	unsigned int lb_failed[CPU_MAX_IDLE_TYPES];
+	unsigned int lb_balanced[CPU_MAX_IDLE_TYPES];
+	unsigned int lb_imbalance[CPU_MAX_IDLE_TYPES];
+	unsigned int lb_gained[CPU_MAX_IDLE_TYPES];
+	unsigned int lb_hot_gained[CPU_MAX_IDLE_TYPES];
+	unsigned int lb_nobusyg[CPU_MAX_IDLE_TYPES];
+	unsigned int lb_nobusyq[CPU_MAX_IDLE_TYPES];
+
+	/* Active load balancing */
+	unsigned int alb_count;
+	unsigned int alb_failed;
+	unsigned int alb_pushed;
+
+	/* SD_BALANCE_EXEC stats */
+	unsigned int sbe_count;
+	unsigned int sbe_balanced;
+	unsigned int sbe_pushed;
+
+	/* SD_BALANCE_FORK stats */
+	unsigned int sbf_count;
+	unsigned int sbf_balanced;
+	unsigned int sbf_pushed;
+
+	/* try_to_wake_up() stats */
+	unsigned int ttwu_wake_remote;
+	unsigned int ttwu_move_affine;
+	unsigned int ttwu_move_balance;
+#endif
+#ifdef CONFIG_SCHED_DEBUG
+	char *name;
+#endif
+	union {
+		void *private;		/* used during construction */
+		struct rcu_head rcu;	/* used during destruction */
+	};
+
+	unsigned int span_weight;
+	/*
+	 * Span of all CPUs in this domain.
+	 *
+	 * NOTE: this field is variable length. (Allocated dynamically
+	 * by attaching extra space to the end of the structure,
+	 * depending on how many CPUs the kernel has booted up with)
+	 */
+	unsigned long span[0];
+};
+
+static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
+{
+	return to_cpumask(sd->span);
+}
+
 static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
 {
 	return to_cpumask(sg->cpumask);
 }
 
+/**
+ * highest_flag_domain - Return highest sched_domain containing flag.
+ * @cpu:	The cpu whose highest level of sched domain is to
+ *		be returned.
+ * @flag:	The flag to check for the highest sched_domain
+ *		for the given cpu.
+ *
+ * Returns the highest sched_domain of a cpu which contains the given flag.
+ */
+static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
+{
+	struct sched_domain *sd, *hsd = NULL;
+
+	for_each_domain(cpu, sd) {
+		if (!(sd->flags & flag))
+			break;
+		hsd = sd;
+	}
+
+	return hsd;
+}
+
+static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
+{
+	struct sched_domain *sd;
+
+	for_each_domain(cpu, sd) {
+		if (sd->flags & flag)
+			break;
+	}
+
+	return sd;
+}
+
 /*
  * cpumask masking which cpus in the group are allowed to iterate up the domain
  * tree.
-- 
1.7.9.5


