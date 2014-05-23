Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaEWP5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:57:17 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39066 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaEWPyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:54:15 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2 05/11] ARM: topology: use new cpu_power interface
Date: Fri, 23 May 2014 17:52:59 +0200
Message-Id: <1400860385-14555-6-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new arch_scale_cpu_power in order to reflect the original capacity of
a CPU instead of arch_scale_freq_power which is more linked to a scaling of
the capacity linked to the frequency.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/arm/kernel/topology.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 71e1fec..6cc25a8 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -42,7 +42,7 @@
  */
 static DEFINE_PER_CPU(unsigned long, cpu_scale);
 
-unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu)
+unsigned long arch_scale_cpu_power(struct sched_domain *sd, int cpu)
 {
 	return per_cpu(cpu_scale, cpu);
 }
@@ -166,7 +166,7 @@ static void update_cpu_power(unsigned int cpu)
 	set_power_scale(cpu, cpu_capacity(cpu) / middle_capacity);
 
 	printk(KERN_INFO "CPU%u: update cpu_power %lu\n",
-		cpu, arch_scale_freq_power(NULL, cpu));
+		cpu, arch_scale_cpu_power(NULL, cpu));
 }
 
 #else
-- 
1.9.1

