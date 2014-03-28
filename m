Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaC1N2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:28:43 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55087 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaC1N2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:28:42 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC 4/4] sched: add per group cpu_power_orig
Date: Fri, 28 Mar 2014 14:27:26 +0100
Message-Id: <1396013246-6577-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new field cpu_power_orig reflects the available capacity of a CPUs unlike
the cpu_power which reflects the current capacity that can be altered by
frequency and rt tasks.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/core.c  | 2 +-
 kernel/sched/fair.c  | 1 +
 kernel/sched/sched.h | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5b20b27..8513f83 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6911,7 +6911,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
-		rq->cpu_power = SCHED_POWER_SCALE;
+		rq->cpu_power = rq->cpu_power_orig = SCHED_POWER_SCALE;
 		rq->post_schedule = 0;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7387c05..f1e4db6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5611,6 +5611,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 
 	power >>= SCHED_POWER_SHIFT;
 
+	cpu_rq(cpu)->cpu_power_orig = power;
 	sdg->sgp->power_orig = power;
 
 	if (sched_feat(ARCH_POWER))
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 46c3784..2abdf5c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -578,6 +578,7 @@ struct rq {
 	struct sched_domain *sd;
 
 	unsigned long cpu_power;
+	unsigned long cpu_power_orig;
 
 	unsigned char idle_balance;
 	/* For active balancing */
-- 
1.9.0

