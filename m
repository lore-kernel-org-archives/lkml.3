Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3DWI2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 04:28:37 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60389 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab3DWI1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 04:27:49 -0400
X-AuditID: 9c93016f-b7c5fae00000791a-92-517646007822
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Jason Low <jason.low2@hp.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 5/6] sched: rename load_balance_tmpmask to load_balance_mask
Date: Tue, 23 Apr 2013 17:27:41 +0900
Message-Id: <1366705662-3587-6-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366705662-3587-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1366705662-3587-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This name doesn't represent specific meaning.
So rename it to imply it's purpose.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ee8c1bd..cb49b2a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6873,7 +6873,7 @@ struct task_group root_task_group;
 LIST_HEAD(task_groups);
 #endif
 
-DECLARE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
+DECLARE_PER_CPU(cpumask_var_t, load_balance_mask);
 
 void __init sched_init(void)
 {
@@ -6910,7 +6910,7 @@ void __init sched_init(void)
 #endif /* CONFIG_RT_GROUP_SCHED */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 		for_each_possible_cpu(i) {
-			per_cpu(load_balance_tmpmask, i) = (void *)ptr;
+			per_cpu(load_balance_mask, i) = (void *)ptr;
 			ptr += cpumask_size();
 		}
 #endif /* CONFIG_CPUMASK_OFFSTACK */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b8ef321..5b1e966 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4977,7 +4977,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 #define MAX_PINNED_INTERVAL	512
 
 /* Working cpumask for load_balance and load_balance_newidle. */
-DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
+DEFINE_PER_CPU(cpumask_var_t, load_balance_mask);
 
 static int need_active_balance(struct lb_env *env)
 {
@@ -5012,7 +5012,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	struct sched_group *group;
 	struct rq *busiest;
 	unsigned long flags;
-	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
+	struct cpumask *cpus = __get_cpu_var(load_balance_mask);
 
 	struct lb_env env = {
 		.sd		= sd,
-- 
1.7.9.5

