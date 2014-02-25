Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaBYBwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:52:46 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54549 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaBYBwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:52:43 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com, mgorman@suse.de
Subject: [PATCH 08/11] sched: replace target_load by biased_load
Date: Tue, 25 Feb 2014 09:50:51 +0800
Message-Id: <1393293054-11378-9-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1393293054-11378-1-git-send-email-alex.shi@linaro.org>
References: <1393293054-11378-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no source_load now, It is better to change the target_load
function name to original meaning: biased_load.

Suggested-by: Morten Rasmussen <morten.rasmussen@arm.com>
Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5feb51b..b8423dc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1015,7 +1015,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
 }
 
 static unsigned long weighted_cpuload(const int cpu);
-static unsigned long target_load(int cpu, int imbalance_pct);
+static unsigned long biased_load(int cpu, int imbalance_pct);
 static unsigned long power_of(int cpu);
 static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
 
@@ -3958,7 +3958,7 @@ static unsigned long weighted_cpuload(const int cpu)
  * Return a high guess at the load of a migration-target cpu weighted
  * according to the runnable time and "nice" value.
  */
-static unsigned long target_load(int cpu, int imbalance_pct)
+static unsigned long biased_load(int cpu, int imbalance_pct)
 {
 	unsigned long total = weighted_cpuload(cpu);
 
@@ -4286,7 +4286,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 			if (local_group)
 				load = weighted_cpuload(i);
 			else
-				load = target_load(i, imbalance);
+				load = biased_load(i, imbalance);
 
 			avg_load += load;
 		}
@@ -5737,7 +5737,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 		/* Bias balancing toward cpus of our domain */
 		if (local_group && env->idle != CPU_IDLE)
-			load = target_load(i, bias);
+			load = biased_load(i, bias);
 		else
 			load = weighted_cpuload(i);
 
-- 
1.8.1.2

