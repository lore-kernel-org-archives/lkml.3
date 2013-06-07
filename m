Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3FGHbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:31:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:11064 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab3FGHaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:30:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,820,1363158000"; 
   d="scan'208";a="325673040"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>
Subject: [RFC patch 1/4] sched: change cfs_rq load avg to unsigned long
Date: Fri,  7 Jun 2013 15:29:26 +0800
Message-Id: <1370590169-24804-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1370590169-24804-1-git-send-email-alex.shi@intel.com>
References: <1370590169-24804-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the 'u64 runnable_load_avg, blocked_load_avg' in cfs_rq struct are
smaller than 'unsigned long' cfs_rq->load.weight. We don't need u64
vaiables to describe them. unsigned long is more efficient and convenience.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/debug.c | 4 ++--
 kernel/sched/sched.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 75024a6..160afdc 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -211,9 +211,9 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
-	SEQ_printf(m, "  .%-30s: %lld\n", "runnable_load_avg",
+	SEQ_printf(m, "  .%-30s: %ld\n", "runnable_load_avg",
 			cfs_rq->runnable_load_avg);
-	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
+	SEQ_printf(m, "  .%-30s: %ld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
 	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_avg",
 			(unsigned long long)atomic64_read(&cfs_rq->tg->load_avg));
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 8bc66c6..5a80943 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -277,7 +277,7 @@ struct cfs_rq {
 	 * This allows for the description of both thread and group usage (in
 	 * the FAIR_GROUP_SCHED case).
 	 */
-	u64 runnable_load_avg, blocked_load_avg;
+	unsigned long runnable_load_avg, blocked_load_avg;
 	atomic64_t decay_counter, removed_load;
 	u64 last_decay;
 
-- 
1.7.12

