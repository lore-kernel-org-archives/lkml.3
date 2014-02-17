Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaBQB50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 20:57:26 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:56059 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaBQB5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 20:57:23 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com
Subject: [PATCH v2 08/11] sched: remove weighted_load()
Date: Mon, 17 Feb 2014 09:55:14 +0800
Message-Id: <1392602117-20773-9-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1392602117-20773-1-git-send-email-alex.shi@linaro.org>
References: <1392602117-20773-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although weighted_load is a inline founction, it's not needed in fact.
so remove it.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5cdc838..6c37ee1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3939,31 +3939,16 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 }
 
 #ifdef CONFIG_SMP
-/* Used instead of source_load when we know the type == 0 */
-static inline unsigned long weighted_cpuload(const int cpu)
-{
-	return cpu_rq(cpu)->cfs.runnable_load_avg;
-}
-
-/*
- * Return a low guess at the load of a migration-source cpu weighted
- * according to the scheduling class and "nice" value.
- *
- * We want to under-estimate the load of migration sources, to
- * balance conservatively.
- */
+/* Return the real load of 'cpu' */
 static unsigned long source_load(int cpu)
 {
-	return weighted_cpuload(cpu);
+	return cpu_rq(cpu)->cfs.runnable_load_avg;
 }
 
-/*
- * Return a high guess at the load of a migration-target cpu weighted
- * according to the scheduling class and "nice" value.
- */
+/* Return a high bias at the load of a migration-target cpu weighted */
 static unsigned long target_load(int cpu, int imbalance_pct)
 {
-	unsigned long total = weighted_cpuload(cpu);
+	unsigned long total = cpu_rq(cpu)->cfs.runnable_load_avg;
 
 	if (!sched_feat(LB_BIAS))
 		return total;
-- 
1.8.1.2

