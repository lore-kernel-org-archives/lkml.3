Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957Ab3BHHar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:30:47 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11518 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3BHHap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:30:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 07 Feb 2013 23:30:38 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: <arnd@arndb.de>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] ARM: tegra: Unify board-dt-tegra{20,30}.c to tegra.c
Date: Fri, 8 Feb 2013 09:29:33 +0200
Message-ID: <1360308574-19658-4-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360308574-19658-1-git-send-email-hdoyu@nvidia.com>
References: <1360308574-19658-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactored that Tegra{20,30,114} use the same board file.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mach-tegra/Makefile                       |    5 ++--
 .../arm/mach-tegra/{board-dt-tegra30.c => tegra.c} |   27 ++++++++++----------
 2 files changed, 15 insertions(+), 17 deletions(-)
 rename arch/arm/mach-tegra/{board-dt-tegra30.c => tegra.c} (71%)

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 1a08ecd..ee866337 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -27,9 +27,8 @@ obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
 obj-$(CONFIG_CPU_FREQ)                  += cpu-tegra.o
 obj-$(CONFIG_TEGRA_PCI)			+= pcie.o
 
-obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= board-dt-tegra20.o
-obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= board-dt-tegra30.o
-obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= board-dt-tegra30.o
+obj-y					+= tegra.o
+
 ifeq ($(CONFIG_CPU_IDLE),y)
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= cpuidle-tegra114.o
 endif
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/tegra.c
similarity index 71%
rename from arch/arm/mach-tegra/board-dt-tegra30.c
rename to arch/arm/mach-tegra/tegra.c
index 82cd85c..62ae39a 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -1,14 +1,7 @@
 /*
- * arch/arm/mach-tegra/board-dt-tegra30.c
- *
- * NVIDIA Tegra30 device tree board support
+ * NVIDIA Tegra SoC device tree board support
  *
  * Copyright (C) 2011, 2013, NVIDIA Corporation
- *
- * Derived from:
- *
- * arch/arm/mach-tegra/board-dt-tegra20.c
- *
  * Copyright (C) 2010 Secret Lab Technologies, Ltd.
  * Copyright (C) 2010 Google, Inc.
  *
@@ -37,25 +30,31 @@
 #include "common.h"
 #include "iomap.h"
 
-static void __init tegra30_dt_init(void)
+static struct of_dev_auxdata tegra_auxdata_lookup[] __initdata = {
+	{},
+};
+
+static void __init tegra_dt_init(void)
 {
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+	of_platform_populate(NULL, of_default_bus_match_table,
+			     tegra_auxdata_lookup, NULL);
 }
 
-static const char *tegra30_dt_board_compat[] = {
+static const char * const tegra_dt_board_compat[] = {
+	"nvidia,tegra20",
 	"nvidia,tegra30",
 	"nvidia,tegra114",
 	NULL
 };
 
-DT_MACHINE_START(TEGRA30_DT, "NVIDIA Tegra30/114 (Flattened Device Tree)")
+DT_MACHINE_START(TEGRA_DT, "NVIDIA Tegra SoC (Flattened Device Tree)")
 	.smp		= smp_ops(tegra_smp_ops),
 	.map_io		= tegra_map_common_io,
 	.init_early	= tegra_init_early,
 	.init_irq	= tegra_dt_init_irq,
 	.init_time	= clocksource_of_init,
-	.init_machine	= tegra30_dt_init,
+	.init_machine	= tegra_dt_init,
 	.init_late	= tegra_init_late,
 	.restart	= tegra_assert_system_reset,
-	.dt_compat	= tegra30_dt_board_compat,
+	.dt_compat	= tegra_dt_board_compat,
 MACHINE_END
-- 
1.7.9.5

