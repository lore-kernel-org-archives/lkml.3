Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3AXLMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:12:18 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16515 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3AXLLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:11:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 24 Jan 2013 03:11:06 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, Jason Cooper <jason@lakedaemon.net>,
        Shawn Guo <shawn.guo@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Kukjin Kim <kgene.kim@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [v4 1/6] ARM: tegra: Use DT /cpu node to detect number of CPU core
Date: Thu, 24 Jan 2013 13:10:21 +0200
Message-ID: <1359025829-22306-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359025829-22306-1-git-send-email-hdoyu@nvidia.com>
References: <1359025829-22306-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra SoCs does not use SCU based to detect CPU core numbers but they
use DT /cpu node. If it's not provided or failed, it continues as a
single core.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
---
Based on the discussion:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-January/140608.html
---
 arch/arm/mach-tegra/platsmp.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index 3ec7fc4..ee847896 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -177,23 +177,8 @@ done:
 	return status;
 }
 
-/*
- * Initialise the CPU possible map early - this describes the CPUs
- * which may be present or become present in the system.
- */
 static void __init tegra_smp_init_cpus(void)
 {
-	unsigned int i, ncores = scu_get_core_count(scu_base);
-
-	if (ncores > nr_cpu_ids) {
-		pr_warn("SMP: %u cores greater than maximum (%u), clipping\n",
-			ncores, nr_cpu_ids);
-		ncores = nr_cpu_ids;
-	}
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
-
 	set_smp_cross_call(gic_raise_softirq);
 }
 
-- 
1.7.9.5

