Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbaCRR6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:58:10 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:59295 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434AbaCRR5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:57:47 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dietmar.eggemann@arm.com, preeti@linux.vnet.ibm.com,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        james.hogan@imgtec.com, cmetcalf@tilera.com, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2 7/7] sched: powerpc: Add SD_SHARE_POWERDOMAIN for SMT level
Date: Tue, 18 Mar 2014 18:56:49 +0100
Message-Id: <1395165409-18055-8-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org>
References: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the power domain dependency at SMT level of Power8 but keep the flag
clear at CPU level. The goal is to consolidate tasks on the threads of a
core up to a level as decribed in the link below:
https://lkml.org/lkml/2014/3/12/16

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
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

