Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab3BNFsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 00:48:52 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55486 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab3BNFsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 00:48:50 -0500
X-AuditID: 9c93016f-b7b1fae000006419-24-511c7abf9aa6
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 6/8] sched: rename load_balance_tmpmask to load_balance_cpu_active
Date: Thu, 14 Feb 2013 14:48:39 +0900
Message-Id: <1360820921-2513-7-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This name doesn't represent specific meaning.
So rename it to imply it's purpose.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..e6f8783 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6814,7 +6814,7 @@ struct task_group root_task_group;
 LIST_HEAD(task_groups);
 #endif
 
-DECLARE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
+DECLARE_PER_CPU(cpumask_var_t, load_balance_cpu_active);
 
 void __init sched_init(void)
 {
@@ -6851,7 +6851,7 @@ void __init sched_init(void)
 #endif /* CONFIG_RT_GROUP_SCHED */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 		for_each_possible_cpu(i) {
-			per_cpu(load_balance_tmpmask, i) = (void *)ptr;
+			per_cpu(load_balance_cpu_active, i) = (void *)ptr;
 			ptr += cpumask_size();
 		}
 #endif /* CONFIG_CPUMASK_OFFSTACK */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bb373f4..7382fa5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4974,7 +4974,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 #define MAX_PINNED_INTERVAL	512
 
 /* Working cpumask for load_balance and load_balance_newidle. */
-DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
+DEFINE_PER_CPU(cpumask_var_t, load_balance_cpu_active);
 
 static int need_active_balance(struct lb_env *env)
 {
@@ -5009,7 +5009,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
-	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
+	struct cpumask *cpus = __get_cpu_var(load_balance_cpu_active);
 
 	struct lb_env env = {
 		.sd		= sd,
-- 
1.7.9.5

