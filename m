Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbbAOKRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:17:39 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:46782 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbbAOKMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:12:32 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com
Cc: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        dietmar.eggemann@arm.com, linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH RESEND v9 03/10] sched: remove frequency scaling from cpu_capacity
Date: Thu, 15 Jan 2015 11:09:23 +0100
Message-Id: <1421316570-23097-4-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421316570-23097-1-git-send-email-vincent.guittot@linaro.org>
References: <1421316570-23097-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that arch_scale_cpu_capacity has been introduced to scale the original
capacity, the arch_scale_freq_capacity is no longer used (it was
previously used by ARM arch). Remove arch_scale_freq_capacity from the
computation of cpu_capacity. The frequency invariance will be handled in the
load tracking and not in the CPU capacity. arch_scale_freq_capacity will be
revisited for scaling load with the current frequency of the CPUs in a later
patch.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a171e1b..a96affd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5823,13 +5823,6 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 
 	sdg->sgc->capacity_orig = capacity;
 
-	if (sched_feat(ARCH_CAPACITY))
-		capacity *= arch_scale_freq_capacity(sd, cpu);
-	else
-		capacity *= default_scale_capacity(sd, cpu);
-
-	capacity >>= SCHED_CAPACITY_SHIFT;
-
 	capacity *= scale_rt_capacity(cpu);
 	capacity >>= SCHED_CAPACITY_SHIFT;
 
-- 
1.9.1

