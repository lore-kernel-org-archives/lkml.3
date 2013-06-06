Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3FFQ2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:28:04 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:49537 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3FFQ1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:27:41 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/6] ARM: kirkwood: convert to DT irqchip and clocksource
Date: Thu,  6 Jun 2013 18:27:14 +0200
Message-Id: <1370536034-23956-7-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent support for true irqchip and clocksource drivers for Orion
SoCs, now make use of it on DT enabled Kirkwood boards.

This also introduces a new Kconfig option for legacy (non-DT) Kirkwood
where old code is moved out to and polishes DT board file a little bit.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-kirkwood/Kconfig    |   24 ++++++++++++++++++++++++
 arch/arm/mach-kirkwood/Makefile   |    4 ++--
 arch/arm/mach-kirkwood/board-dt.c |   28 +++++++++++++++++-----------
 3 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-kirkwood/Kconfig b/arch/arm/mach-kirkwood/Kconfig
index 2c95623..f14914f 100644
--- a/arch/arm/mach-kirkwood/Kconfig
+++ b/arch/arm/mach-kirkwood/Kconfig
@@ -2,62 +2,75 @@ if ARCH_KIRKWOOD
 
 menu "Marvell Kirkwood Implementations"
 
+config KIRKWOOD_LEGACY
+	bool
+
 config MACH_D2NET_V2
 	bool "LaCie d2 Network v2 NAS Board"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  LaCie d2 Network v2 NAS.
 
 config MACH_DOCKSTAR
 	bool "Seagate FreeAgent DockStar"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  Seagate FreeAgent DockStar.
 
 config MACH_ESATA_SHEEVAPLUG
 	bool "Marvell eSATA SheevaPlug Reference Board"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  Marvell eSATA SheevaPlug Reference Board.
 
 config MACH_GURUPLUG
 	bool "Marvell GuruPlug Reference Board"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  Marvell GuruPlug Reference Board.
 
 config MACH_INETSPACE_V2
 	bool "LaCie Internet Space v2 NAS Board"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  LaCie Internet Space v2 NAS.
 
 config MACH_MV88F6281GTW_GE
 	bool "Marvell 88F6281 GTW GE Board"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  Marvell 88F6281 GTW GE Board.
 
 config MACH_NET2BIG_V2
 	bool "LaCie 2Big Network v2 NAS Board"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  LaCie 2Big Network v2 NAS.
 
 config MACH_NET5BIG_V2
 	bool "LaCie 5Big Network v2 NAS Board"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  LaCie 5Big Network v2 NAS.
 
 config MACH_NETSPACE_MAX_V2
 	bool "LaCie Network Space Max v2 NAS Board"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  LaCie Network Space Max v2 NAS.
 
 config MACH_NETSPACE_V2
 	bool "LaCie Network Space v2 NAS Board"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  LaCie Network Space v2 NAS.
@@ -67,6 +80,7 @@ config MACH_OPENRD
 
 config MACH_OPENRD_BASE
 	bool "Marvell OpenRD Base Board"
+	select KIRKWOOD_LEGACY
 	select MACH_OPENRD
 	help
 	  Say 'Y' here if you want your kernel to support the
@@ -74,6 +88,7 @@ config MACH_OPENRD_BASE
 
 config MACH_OPENRD_CLIENT
 	bool "Marvell OpenRD Client Board"
+	select KIRKWOOD_LEGACY
 	select MACH_OPENRD
 	help
 	  Say 'Y' here if you want your kernel to support the
@@ -81,6 +96,7 @@ config MACH_OPENRD_CLIENT
 
 config MACH_OPENRD_ULTIMATE
 	bool "Marvell OpenRD Ultimate Board"
+	select KIRKWOOD_LEGACY
 	select MACH_OPENRD
 	help
 	  Say 'Y' here if you want your kernel to support the
@@ -88,30 +104,35 @@ config MACH_OPENRD_ULTIMATE
 
 config MACH_RD88F6192_NAS
 	bool "Marvell RD-88F6192-NAS Reference Board"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  Marvell RD-88F6192-NAS Reference Board.
 
 config MACH_RD88F6281
 	bool "Marvell RD-88F6281 Reference Board"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  Marvell RD-88F6281 Reference Board.
 
 config MACH_SHEEVAPLUG
 	bool "Marvell SheevaPlug Reference Board"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  Marvell SheevaPlug Reference Board.
 
 config MACH_T5325
 	bool "HP t5325 Thin Client"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  HP t5325 Thin Client.
 
 config MACH_TS219
 	bool "QNAP TS-110, TS-119, TS-119P+, TS-210, TS-219, TS-219P and TS-219P+ Turbo NAS"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  QNAP TS-110, TS-119, TS-119P+, TS-210, TS-219, TS-219P and
@@ -119,6 +140,7 @@ config MACH_TS219
 
 config MACH_TS41X
 	bool "QNAP TS-410, TS-410U, TS-419P, TS-419P+ and TS-419U Turbo NAS"
+	select KIRKWOOD_LEGACY
 	help
 	  Say 'Y' here if you want your kernel to support the
 	  QNAP TS-410, TS-410U, TS-419P, TS-419P+ and TS-419U Turbo
@@ -129,6 +151,8 @@ comment "Device tree entries"
 config ARCH_KIRKWOOD_DT
 	bool "Marvell Kirkwood Flattened Device Tree"
 	select KIRKWOOD_CLK
+	select ORION_IRQCHIP
+	select ORION_TIMER
 	select POWER_SUPPLY
 	select POWER_RESET
 	select POWER_RESET_GPIO
diff --git a/arch/arm/mach-kirkwood/Makefile b/arch/arm/mach-kirkwood/Makefile
index 53caf14..91be973 100644
--- a/arch/arm/mach-kirkwood/Makefile
+++ b/arch/arm/mach-kirkwood/Makefile
@@ -1,5 +1,5 @@
-obj-y				+= common.o irq.o pcie.o mpp.o
-
+obj-y				+= common.o pcie.o
+obj-$(CONFIG_KIRKWOOD_LEGACY)	+= irq.o mpp.o
 obj-$(CONFIG_MACH_D2NET_V2)		+= d2net_v2-setup.o lacie_v2-common.o
 obj-$(CONFIG_MACH_DOCKSTAR)		+= dockstar-setup.o
 obj-$(CONFIG_MACH_ESATA_SHEEVAPLUG)	+= sheevaplug-setup.o
diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
index 1e4eac3..cec736b 100644
--- a/arch/arm/mach-kirkwood/board-dt.c
+++ b/arch/arm/mach-kirkwood/board-dt.c
@@ -15,6 +15,9 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/clk-provider.h>
+#include <linux/clocksource.h>
+#include <linux/dma-mapping.h>
+#include <linux/irqchip.h>
 #include <linux/kexec.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -49,10 +52,6 @@ static void __init kirkwood_legacy_clk_init(void)
 	orion_clkdev_add("1", "pcie",
 			 of_clk_get_from_provider(&clkspec));
 
-	clkspec.args[0] = CGC_BIT_SDIO;
-	orion_clkdev_add(NULL, "mvsdio",
-			 of_clk_get_from_provider(&clkspec));
-
 	/*
 	 * The ethernet interfaces forget the MAC address assigned by
 	 * u-boot if the clocks are turned off. Until proper DT support
@@ -67,10 +66,18 @@ static void __init kirkwood_legacy_clk_init(void)
 	clk_prepare_enable(clk);
 }
 
-static void __init kirkwood_of_clk_init(void)
+static void __init kirkwood_dt_time_init(void)
 {
 	of_clk_init(NULL);
-	kirkwood_legacy_clk_init();
+	clocksource_of_init();
+}
+
+static void __init kirkwood_dt_init_early(void)
+{
+	init_dma_coherent_pool_size(SZ_1M);
+	mvebu_mbus_init("marvell,kirkwood-mbus",
+			BRIDGE_WINS_BASE, BRIDGE_WINS_SZ,
+			DDR_WINDOW_CPU_BASE, DDR_WINDOW_CPU_SZ);
 }
 
 static void __init kirkwood_dt_init(void)
@@ -91,8 +98,8 @@ static void __init kirkwood_dt_init(void)
 
 	kirkwood_cpufreq_init();
 
-	/* Setup root of clk tree */
-	kirkwood_of_clk_init();
+	/* setup clocks for legacy devices */
+	kirkwood_legacy_clk_init();
 
 	kirkwood_cpuidle_init();
 
@@ -117,9 +124,8 @@ static const char * const kirkwood_dt_board_compat[] = {
 DT_MACHINE_START(KIRKWOOD_DT, "Marvell Kirkwood (Flattened Device Tree)")
 	/* Maintainer: Jason Cooper <jason@lakedaemon.net> */
 	.map_io		= kirkwood_map_io,
-	.init_early	= kirkwood_init_early,
-	.init_irq	= orion_dt_init_irq,
-	.init_time	= kirkwood_timer_init,
+	.init_early	= kirkwood_dt_init_early,
+	.init_time	= kirkwood_dt_time_init,
 	.init_machine	= kirkwood_dt_init,
 	.restart	= kirkwood_restart,
 	.dt_compat	= kirkwood_dt_board_compat,
-- 
1.7.2.5

