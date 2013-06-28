Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3F1LKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 07:10:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:4316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab3F1LKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 07:10:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,958,1363158000"; 
   d="scan'208";a="336937781"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, pjt@google.com, kamalesh@linux.vnet.ibm.com
Subject: [patch based tip/sched/core] sched/debug: remove CONFIG_FAIR_GROUP_SCHED mask
Date: Fri, 28 Jun 2013 19:10:35 +0800
Message-Id: <1372417835-4698-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we are using runnable load avg in sched balance. So don't need
keep marking them under CONFIG_FAIR_GROUP_SCHED. Also align the code
style to #ifdef instead of #if defined() and reorder the tg output info.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/debug.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 62632098..3d1fe86 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -209,22 +209,24 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->nr_spread_over);
 	SEQ_printf(m, "  .%-30s: %d\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
-#ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
 	SEQ_printf(m, "  .%-30s: %ld\n", "runnable_load_avg",
 			cfs_rq->runnable_load_avg);
 	SEQ_printf(m, "  .%-30s: %ld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
-	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
-			atomic_long_read(&cfs_rq->tg->load_avg));
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_contrib",
 			cfs_rq->tg_load_contrib);
 	SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
 			cfs_rq->tg_runnable_contrib);
+	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
+			atomic_long_read(&cfs_rq->tg->load_avg));
 	SEQ_printf(m, "  .%-30s: %d\n", "tg->runnable_avg",
 			atomic_read(&cfs_rq->tg->runnable_avg));
 #endif
+#endif
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
 #endif
 }
@@ -566,7 +568,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 		   "nr_involuntary_switches", (long long)p->nivcsw);
 
 	P(se.load.weight);
-#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+#ifdef CONFIG_SMP
 	P(se.avg.runnable_avg_sum);
 	P(se.avg.runnable_avg_period);
 	P(se.avg.load_avg_contrib);
-- 
1.7.5.4

