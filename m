Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139AbaCSQYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:24:22 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43162 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbaCSQYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:24:19 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        james.hogan@imgtec.com, cmetcalf@tilera.com, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: dietmar.eggemann@arm.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v3 6/6] sched: powerpc: Add SD_SHARE_POWERDOMAIN for SMT level
Date: Wed, 19 Mar 2014 17:22:45 +0100
Message-Id: <1395246165-31150-7-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395246165-31150-1-git-send-email-vincent.guittot@linaro.org>
References: <1395246165-31150-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the power domain dependency at SMT level of Power8 but keep the flag
clear at CPU level. The goal is to consolidate tasks on the threads of a
core up to a level as explained by Preeti:
"On powerpc we would want to clear the SD_SHARE_POWERDOMAIN flag at the CPU
domain. On Power8, considering we have 8 threads per core, we would want to
consolidate tasks atleast upto 4 threads without significant performance
impact before spilling over to the other cores. By doing so, besides making
use of the higher power of the core we could do cpuidle management at the
core level for the remaining idle cores as a result of this consolidation."

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index c9cade5..fbbac3c 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -759,7 +759,7 @@ int setup_profiling_timer(unsigned int multiplier)
 /* cpumask of CPUs with asymetric SMT dependancy */
 static const int powerpc_smt_flags(void)
 {
-	int flags = SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
+	int flags = SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES | SD_SHARE_POWERDOMAIN;
 
 	if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
 		printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
-- 
1.9.0

