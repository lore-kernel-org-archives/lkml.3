Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab3BKGGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 01:06:42 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2149 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab3BKGGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 01:06:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 10 Feb 2013 22:06:30 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: <arnd@arndb.de>, <marvin24@gmx.de>, <balbi@ti.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [v2 3/3] ARM: tegra: Unify Device tree board files
Date: Mon, 11 Feb 2013 08:05:43 +0200
Message-ID: <1360562743-21689-3-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360562743-21689-1-git-send-email-hdoyu@nvidia.com>
References: <1360562743-21689-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify board-dt-tegra{30,114} to the Tegra20 DT board file, "tegra.c".

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mach-tegra/Makefile            |    5 ++-
 arch/arm/mach-tegra/board-dt-tegra114.c |   46 ------------------------
 arch/arm/mach-tegra/board-dt-tegra30.c  |   60 -------------------------------
 arch/arm/mach-tegra/tegra.c             |   24 +++++++------
 4 files changed, 16 insertions(+), 119 deletions(-)
 delete mode 100644 arch/arm/mach-tegra/board-dt-tegra114.c
 delete mode 100644 arch/arm/mach-tegra/board-dt-tegra30.c

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index c6d6be2..ee866337 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -27,9 +27,8 @@ obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
 obj-$(CONFIG_CPU_FREQ)                  += cpu-tegra.o
 obj-$(CONFIG_TEGRA_PCI)			+= pcie.o
 
-obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra.o
-obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= board-dt-tegra30.o
-obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= board-dt-tegra114.o
+obj-y					+= tegra.o
+
 ifeq ($(CONFIG_CPU_IDLE),y)
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= cpuidle-tegra114.o
 endif
diff --git a/arch/arm/mach-tegra/board-dt-tegra114.c b/arch/arm/mach-tegra/board-dt-tegra114.c
deleted file mode 100644
index 08e8294..0000000
--- a/arch/arm/mach-tegra/board-dt-tegra114.c
+++ /dev/null
@@ -1,46 +0,0 @@
-/*
- * NVIDIA Tegra114 device tree board support
- *
- * Copyright (C) 2013 NVIDIA Corporation
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/of.h>
-#include <linux/of_platform.h>
-#include <linux/clocksource.h>
-
-#include <asm/mach/arch.h>
-
-#include "board.h"
-#include "common.h"
-
-static void __init tegra114_dt_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-}
-
-static const char * const tegra114_dt_board_compat[] = {
-	"nvidia,tegra114",
-	NULL,
-};
-
-DT_MACHINE_START(TEGRA114_DT, "NVIDIA Tegra114 (Flattened Device Tree)")
-	.smp		= smp_ops(tegra_smp_ops),
-	.map_io		= tegra_map_common_io,
-	.init_early	= tegra_init_early,
-	.init_irq	= tegra_dt_init_irq,
-	.init_time	= clocksource_of_init,
-	.init_machine	= tegra114_dt_init,
-	.init_late	= tegra_init_late,
-	.restart	= tegra_assert_system_reset,
-	.dt_compat	= tegra114_dt_board_compat,
-MACHINE_END
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
deleted file mode 100644
index 63f8139..0000000
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- * arch/arm/mach-tegra/board-dt-tegra30.c
- *
- * NVIDIA Tegra30 device tree board support
- *
- * Copyright (C) 2011, 2013, NVIDIA Corporation
- *
- * Derived from:
- *
- * arch/arm/mach-tegra/board-dt-tegra20.c
- *
- * Copyright (C) 2010 Secret Lab Technologies, Ltd.
- * Copyright (C) 2010 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/clocksource.h>
-#include <linux/kernel.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_fdt.h>
-#include <linux/of_irq.h>
-#include <linux/of_platform.h>
-
-#include <asm/mach/arch.h>
-
-#include "board.h"
-#include "common.h"
-#include "iomap.h"
-
-static void __init tegra30_dt_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-}
-
-static const char *tegra30_dt_board_compat[] = {
-	"nvidia,tegra30",
-	NULL
-};
-
-DT_MACHINE_START(TEGRA30_DT, "NVIDIA Tegra30 (Flattened Device Tree)")
-	.smp		= smp_ops(tegra_smp_ops),
-	.map_io		= tegra_map_common_io,
-	.init_early	= tegra_init_early,
-	.init_irq	= tegra_dt_init_irq,
-	.init_time	= clocksource_of_init,
-	.init_machine	= tegra30_dt_init,
-	.init_late	= tegra_init_late,
-	.restart	= tegra_assert_system_reset,
-	.dt_compat	= tegra30_dt_board_compat,
-MACHINE_END
diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
index fca18e9..00debef 100644
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -1,6 +1,7 @@
 /*
- * nVidia Tegra device tree board support
+ * NVIDIA Tegra SoC device tree board support
  *
+ * Copyright (C) 2011, 2013, NVIDIA Corporation
  * Copyright (C) 2010 Secret Lab Technologies, Ltd.
  * Copyright (C) 2010 Google, Inc.
  *
@@ -67,13 +68,15 @@ static struct tegra_ehci_platform_data tegra_ehci3_pdata = {
 	.vbus_gpio = -1,
 };
 
-static struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
+static struct of_dev_auxdata tegra_auxdata_lookup[] __initdata = {
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
 	OF_DEV_AUXDATA("nvidia,tegra20-ehci", 0xC5000000, "tegra-ehci.0",
 		       &tegra_ehci1_pdata),
 	OF_DEV_AUXDATA("nvidia,tegra20-ehci", 0xC5004000, "tegra-ehci.1",
 		       &tegra_ehci2_pdata),
 	OF_DEV_AUXDATA("nvidia,tegra20-ehci", 0xC5008000, "tegra-ehci.2",
 		       &tegra_ehci3_pdata),
+#endif
 	{}
 };
 
@@ -84,29 +87,25 @@ static void __init tegra_dt_init(void)
 	 * devices
 	 */
 	of_platform_populate(NULL, of_default_bus_match_table,
-				tegra20_auxdata_lookup, NULL);
+				tegra_auxdata_lookup, NULL);
 }
 
 static void __init trimslice_init(void)
 {
-#ifdef CONFIG_TEGRA_PCI
 	int ret;
 
 	ret = tegra_pcie_init(true, true);
 	if (ret)
 		pr_err("tegra_pci_init() failed: %d\n", ret);
-#endif
 }
 
 static void __init harmony_init(void)
 {
-#ifdef CONFIG_TEGRA_PCI
 	int ret;
 
 	ret = harmony_pcie_init();
 	if (ret)
 		pr_err("harmony_pcie_init() failed: %d\n", ret);
-#endif
 }
 
 static void __init paz00_init(void)
@@ -129,6 +128,9 @@ static void __init tegra_dt_init_late(void)
 
 	tegra_init_late();
 
+	if (IS_ENABLED(CONFIG_PCI) && IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC))
+		return;
+
 	for (i = 0; i < ARRAY_SIZE(board_init_funcs); i++) {
 		if (of_machine_is_compatible(board_init_funcs[i].machine)) {
 			board_init_funcs[i].init();
@@ -137,12 +139,14 @@ static void __init tegra_dt_init_late(void)
 	}
 }
 
-static const char *tegra20_dt_board_compat[] = {
+static const char * const tegra_dt_board_compat[] = {
 	"nvidia,tegra20",
+	"nvidia,tegra30",
+	"nvidia,tegra114",
 	NULL
 };
 
-DT_MACHINE_START(TEGRA_DT, "nVidia Tegra20 (Flattened Device Tree)")
+DT_MACHINE_START(TEGRA_DT, "NVIDIA Tegra SoC (Flattened Device Tree)")
 	.map_io		= tegra_map_common_io,
 	.smp		= smp_ops(tegra_smp_ops),
 	.init_early	= tegra_init_early,
@@ -151,5 +155,5 @@ DT_MACHINE_START(TEGRA_DT, "nVidia Tegra20 (Flattened Device Tree)")
 	.init_machine	= tegra_dt_init,
 	.init_late	= tegra_dt_init_late,
 	.restart	= tegra_assert_system_reset,
-	.dt_compat	= tegra20_dt_board_compat,
+	.dt_compat	= tegra_dt_board_compat,
 MACHINE_END
-- 
1.7.9.5

