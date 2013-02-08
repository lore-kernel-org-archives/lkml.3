Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946020Ab3BHHaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:30:24 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11501 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759700Ab3BHHaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:30:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 07 Feb 2013 23:30:12 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: <arnd@arndb.de>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] ARM: tegra: Unify tegra{20,30,114}_init_early()
Date: Fri, 8 Feb 2013 09:29:31 +0200
Message-ID: <1360308574-19658-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360308574-19658-1-git-send-email-hdoyu@nvidia.com>
References: <1360308574-19658-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactored tegra{20,30,114}_init_early() so that we have the unified
tegra_init_early().

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mach-tegra/board-dt-tegra114.c |    2 +-
 arch/arm/mach-tegra/board-dt-tegra20.c  |    2 +-
 arch/arm/mach-tegra/board-dt-tegra30.c  |    4 ++--
 arch/arm/mach-tegra/board.h             |    4 +---
 arch/arm/mach-tegra/common.c            |   26 ++------------------------
 arch/arm/mach-tegra/hotplug.c           |   31 +++++++++++++++++--------------
 arch/arm/mach-tegra/sleep.h             |   10 +++++-----
 7 files changed, 29 insertions(+), 50 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra114.c b/arch/arm/mach-tegra/board-dt-tegra114.c
index 085d636..08e8294 100644
--- a/arch/arm/mach-tegra/board-dt-tegra114.c
+++ b/arch/arm/mach-tegra/board-dt-tegra114.c
@@ -36,7 +36,7 @@ static const char * const tegra114_dt_board_compat[] = {
 DT_MACHINE_START(TEGRA114_DT, "NVIDIA Tegra114 (Flattened Device Tree)")
 	.smp		= smp_ops(tegra_smp_ops),
 	.map_io		= tegra_map_common_io,
-	.init_early	= tegra114_init_early,
+	.init_early	= tegra_init_early,
 	.init_irq	= tegra_dt_init_irq,
 	.init_time	= clocksource_of_init,
 	.init_machine	= tegra114_dt_init,
diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index a0edf25..fca18e9 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -145,7 +145,7 @@ static const char *tegra20_dt_board_compat[] = {
 DT_MACHINE_START(TEGRA_DT, "nVidia Tegra20 (Flattened Device Tree)")
 	.map_io		= tegra_map_common_io,
 	.smp		= smp_ops(tegra_smp_ops),
-	.init_early	= tegra20_init_early,
+	.init_early	= tegra_init_early,
 	.init_irq	= tegra_dt_init_irq,
 	.init_time	= clocksource_of_init,
 	.init_machine	= tegra_dt_init,
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index bf68567..63f8139 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -3,7 +3,7 @@
  *
  * NVIDIA Tegra30 device tree board support
  *
- * Copyright (C) 2011 NVIDIA Corporation
+ * Copyright (C) 2011, 2013, NVIDIA Corporation
  *
  * Derived from:
  *
@@ -50,7 +50,7 @@ static const char *tegra30_dt_board_compat[] = {
 DT_MACHINE_START(TEGRA30_DT, "NVIDIA Tegra30 (Flattened Device Tree)")
 	.smp		= smp_ops(tegra_smp_ops),
 	.map_io		= tegra_map_common_io,
-	.init_early	= tegra30_init_early,
+	.init_early	= tegra_init_early,
 	.init_irq	= tegra_dt_init_irq,
 	.init_time	= clocksource_of_init,
 	.init_machine	= tegra30_dt_init,
diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h
index 86851c8..60431de 100644
--- a/arch/arm/mach-tegra/board.h
+++ b/arch/arm/mach-tegra/board.h
@@ -26,9 +26,7 @@
 
 void tegra_assert_system_reset(char mode, const char *cmd);
 
-void __init tegra20_init_early(void);
-void __init tegra30_init_early(void);
-void __init tegra114_init_early(void);
+void __init tegra_init_early(void);
 void __init tegra_map_common_io(void);
 void __init tegra_init_irq(void);
 void __init tegra_dt_init_irq(void);
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 5449a3f..f0315c9 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -94,7 +94,7 @@ static void __init tegra_init_cache(void)
 
 }
 
-static void __init tegra_init_early(void)
+void __init tegra_init_early(void)
 {
 	tegra_cpu_reset_handler_init();
 	tegra_apb_io_init();
@@ -102,31 +102,9 @@ static void __init tegra_init_early(void)
 	tegra_init_cache();
 	tegra_pmc_init();
 	tegra_powergate_init();
+	tegra_hotplug_init();
 }
 
-#ifdef CONFIG_ARCH_TEGRA_2x_SOC
-void __init tegra20_init_early(void)
-{
-	tegra_init_early();
-	tegra20_hotplug_init();
-}
-#endif
-
-#ifdef CONFIG_ARCH_TEGRA_3x_SOC
-void __init tegra30_init_early(void)
-{
-	tegra_init_early();
-	tegra30_hotplug_init();
-}
-#endif
-
-#ifdef CONFIG_ARCH_TEGRA_114_SOC
-void __init tegra114_init_early(void)
-{
-	tegra_init_early();
-}
-#endif
-
 void __init tegra_init_late(void)
 {
 	tegra_powergate_debugfs_init();
diff --git a/arch/arm/mach-tegra/hotplug.c b/arch/arm/mach-tegra/hotplug.c
index a599f6e..9bcecb8 100644
--- a/arch/arm/mach-tegra/hotplug.c
+++ b/arch/arm/mach-tegra/hotplug.c
@@ -1,8 +1,7 @@
 /*
- *
  *  Copyright (C) 2002 ARM Ltd.
  *  All Rights Reserved
- *  Copyright (c) 2010, 2012 NVIDIA Corporation. All rights reserved.
+ *  Copyright (c) 2010, 2012-2013, NVIDIA Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -15,6 +14,7 @@
 #include <asm/cacheflush.h>
 #include <asm/smp_plat.h>
 
+#include "fuse.h"
 #include "sleep.h"
 
 static void (*tegra_hotplug_shutdown)(void);
@@ -56,18 +56,21 @@ int tegra_cpu_disable(unsigned int cpu)
 	return cpu == 0 ? -EPERM : 0;
 }
 
-#ifdef CONFIG_ARCH_TEGRA_2x_SOC
-extern void tegra20_hotplug_shutdown(void);
-void __init tegra20_hotplug_init(void)
+void __init tegra_hotplug_init(void)
 {
-	tegra_hotplug_shutdown = tegra20_hotplug_shutdown;
-}
+	switch (tegra_chip_id) {
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
+	case TEGRA20:
+		tegra_hotplug_shutdown = tegra20_hotplug_shutdown;
+		break;
 #endif
-
-#ifdef CONFIG_ARCH_TEGRA_3x_SOC
-extern void tegra30_hotplug_shutdown(void);
-void __init tegra30_hotplug_init(void)
-{
-	tegra_hotplug_shutdown = tegra30_hotplug_shutdown;
-}
+#if defined(CONFIG_ARCH_TEGRA_3x_SOC)
+	case TEGRA30:
+		tegra_hotplug_shutdown = tegra30_hotplug_shutdown;
+		break;
 #endif
+	default:
+		BUG_ON(IS_ENABLED(CONFIG_HOTPLUG_CPU));
+		break;
+	}
+}
diff --git a/arch/arm/mach-tegra/sleep.h b/arch/arm/mach-tegra/sleep.h
index 4ffae54..970ebd5 100644
--- a/arch/arm/mach-tegra/sleep.h
+++ b/arch/arm/mach-tegra/sleep.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010-2012, NVIDIA Corporation. All rights reserved.
+ * Copyright (c) 2010-2013, NVIDIA Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -124,11 +124,11 @@ int tegra_sleep_cpu_finish(unsigned long);
 void tegra_disable_clean_inv_dcache(void);
 
 #ifdef CONFIG_HOTPLUG_CPU
-void tegra20_hotplug_init(void);
-void tegra30_hotplug_init(void);
+void tegra20_hotplug_shutdown(void);
+void tegra30_hotplug_shutdown(void);
+void tegra_hotplug_init(void);
 #else
-static inline void tegra20_hotplug_init(void) {}
-static inline void tegra30_hotplug_init(void) {}
+static inline void tegra_hotplug_init(void) {}
 #endif
 
 void tegra20_cpu_shutdown(int cpu);
-- 
1.7.9.5

