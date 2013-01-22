Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3AVFw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 00:52:59 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19739 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab3AVFw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 00:52:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 21 Jan 2013 21:51:15 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <arnd@arndb.de>, <olof@lixom.net>, <santosh.shilimkar@ti.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex A9
Date: Tue, 22 Jan 2013 07:52:02 +0200
Message-ID: <1358833924-24535-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358833924-24535-1-git-send-email-hdoyu@nvidia.com>
References: <1358833924-24535-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip scu_enable(scu_base) if CPU is not Cortex A9 with SCU.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mach-tegra/platsmp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index 689ee4b..8853bd2 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -38,7 +38,6 @@
 extern void tegra_secondary_startup(void);
 
 static cpumask_t tegra_cpu_init_mask;
-static void __iomem *scu_base = IO_ADDRESS(TEGRA_ARM_PERIF_BASE);
 
 #define EVP_CPU_RESET_VECTOR \
 	(IO_ADDRESS(TEGRA_EXCEPTION_VECTORS_BASE) + 0x100)
@@ -187,7 +186,8 @@ static void __init tegra_smp_prepare_cpus(unsigned int max_cpus)
 	/* Always mark the boot CPU (CPU0) as initialized. */
 	cpumask_set_cpu(0, &tegra_cpu_init_mask);
 
-	scu_enable(scu_base);
+	if (scu_a9_has_base())
+		scu_enable(IO_ADDRESS(scu_a9_get_base()));
 }
 
 struct smp_operations tegra_smp_ops __initdata = {
-- 
1.7.9.5

