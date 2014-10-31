Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbaJaIv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:51:28 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45121 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbaJaIsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:48:06 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v8 02/10] sched: remove frequency scaling from cpu_capacity
Date: Fri, 31 Oct 2014 09:47:24 +0100
Message-Id: <1414745252-4895-3-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414745252-4895-1-git-send-email-vincent.guittot@linaro.org>
References: <1414745252-4895-1-git-send-email-vincent.guittot@linaro.org>
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
index c3674da..bd214d2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5784,13 +5784,6 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 	cpu_rq(cpu)->cpu_capacity_orig = capacity;
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

