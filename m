Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab3DXJnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:43:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39370 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758452Ab3DXJjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:39:12 -0400
Date: Wed, 24 Apr 2013 02:37:27 -0700
From: tip-bot for Joonsoo Kim <tipbot@zytor.com>
Message-ID: <tip-e6252c3ef4b9cd251b53f7b68035f395d20b044e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, davidlohr.bueso@hp.com, a.p.zijlstra@chello.nl,
        peterz@infradead.org, jason.low2@hp.com, tglx@linutronix.de,
        iamjoonsoo.kim@lge.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, davidlohr.bueso@hp.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, jason.low2@hp.com,
        iamjoonsoo.kim@lge.com, tglx@linutronix.de
In-Reply-To: <1366705662-3587-6-git-send-email-iamjoonsoo.kim@lge.com>
References: <1366705662-3587-6-git-send-email-iamjoonsoo.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Rename load_balance_tmpmask to load_balance_mask
Git-Commit-ID: e6252c3ef4b9cd251b53f7b68035f395d20b044e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6252c3ef4b9cd251b53f7b68035f395d20b044e
Gitweb:     http://git.kernel.org/tip/e6252c3ef4b9cd251b53f7b68035f395d20b044e
Author:     Joonsoo Kim <iamjoonsoo.kim@lge.com>
AuthorDate: Tue, 23 Apr 2013 17:27:41 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Apr 2013 08:52:45 +0200

sched: Rename load_balance_tmpmask to load_balance_mask

This name doesn't represent specific meaning.
So rename it to imply it's purpose.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Jason Low <jason.low2@hp.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1366705662-3587-6-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 4 ++--
 kernel/sched/fair.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

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
