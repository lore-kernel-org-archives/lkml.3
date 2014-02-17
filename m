Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaBQB5A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 20:57:00 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:63844 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaBQB46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 20:56:58 -0500
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
Subject: [PATCH v2 06/11] sched: clean up source_load/target_load
Date: Mon, 17 Feb 2014 09:55:12 +0800
Message-Id: <1392602117-20773-7-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1392602117-20773-1-git-send-email-alex.shi@linaro.org>
References: <1392602117-20773-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't need 'rq' variable now.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a85a10b..2da0e3b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3954,13 +3954,7 @@ static unsigned long weighted_cpuload(const int cpu)
  */
 static unsigned long source_load(int cpu)
 {
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
-
-	if (!sched_feat(LB_BIAS))
-		return total;
-
-	return min(rq->cpu_load, total);
+	return weighted_cpuload(cpu);
 }
 
 /*
@@ -3969,7 +3963,6 @@ static unsigned long source_load(int cpu)
  */
 static unsigned long target_load(int cpu, int imbalance_pct)
 {
-	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
 
 	if (!sched_feat(LB_BIAS))
@@ -3978,9 +3971,7 @@ static unsigned long target_load(int cpu, int imbalance_pct)
 	/*
 	 * Bias target load with imbalance_pct.
 	 */
-	total = total * imbalance_pct / 100;
-
-	return max(rq->cpu_load, total);
+	return total * imbalance_pct / 100;
 }
 
 static unsigned long power_of(int cpu)
-- 
1.8.1.2

