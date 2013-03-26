Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006Ab3CZGB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 02:01:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52460 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab3CZGA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 02:00:59 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-56-51513997ce9e
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 5/6] sched: rename load_balance_tmpmask to load_balance_mask
Date: Tue, 26 Mar 2013 15:01:39 +0900
Message-Id: <1364277700-7509-6-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This name doesn't represent specific meaning.
So rename it to imply it's purpose.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..07b4178 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6865,7 +6865,7 @@ struct task_group root_task_group;
 LIST_HEAD(task_groups);
 #endif
 
-DECLARE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
+DECLARE_PER_CPU(cpumask_var_t, load_balance_mask);
 
 void __init sched_init(void)
 {
@@ -6902,7 +6902,7 @@ void __init sched_init(void)
 #endif /* CONFIG_RT_GROUP_SCHED */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 		for_each_possible_cpu(i) {
-			per_cpu(load_balance_tmpmask, i) = (void *)ptr;
+			per_cpu(load_balance_mask, i) = (void *)ptr;
 			ptr += cpumask_size();
 		}
 #endif /* CONFIG_CPUMASK_OFFSTACK */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d3c6011..e3f09f4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4958,7 +4958,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 #define MAX_PINNED_INTERVAL	512
 
 /* Working cpumask for load_balance and load_balance_newidle. */
-DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
+DEFINE_PER_CPU(cpumask_var_t, load_balance_mask);
 
 static int need_active_balance(struct lb_env *env)
 {
@@ -4993,7 +4993,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
-	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
+	struct cpumask *cpus = __get_cpu_var(load_balance_mask);
 
 	struct lb_env env = {
 		.sd		= sd,
-- 
1.7.9.5

