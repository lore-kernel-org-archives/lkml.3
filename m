Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab3ENPlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:41:42 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48490 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107Ab3ENPjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:39:22 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>
Cc: linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 13/20] ARM: spear: Remove init_irq declaration in machine description
Date: Tue, 14 May 2013 17:38:46 +0200
Message-Id: <1368545933-7430-14-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
specified") removed the need to explictly setup the init_irq field in
the machine description when using only irqchip_init. Remove that
declaration for spear as well.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mach-spear/spear1310.c | 2 --
 arch/arm/mach-spear/spear1340.c | 2 --
 arch/arm/mach-spear/spear300.c  | 2 --
 arch/arm/mach-spear/spear310.c  | 2 --
 arch/arm/mach-spear/spear320.c  | 2 --
 arch/arm/mach-spear/spear6xx.c  | 2 --
 6 files changed, 12 deletions(-)

diff --git a/arch/arm/mach-spear/spear1310.c b/arch/arm/mach-spear/spear1310.c
index 9eaac2c..7ad0030 100644
--- a/arch/arm/mach-spear/spear1310.c
+++ b/arch/arm/mach-spear/spear1310.c
@@ -14,7 +14,6 @@
 #define pr_fmt(fmt) "SPEAr1310: " fmt
 
 #include <linux/amba/pl022.h>
-#include <linux/irqchip.h>
 #include <linux/of_platform.h>
 #include <linux/pata_arasan_cf_data.h>
 #include <asm/mach/arch.h>
@@ -60,7 +59,6 @@ static void __init spear1310_map_io(void)
 DT_MACHINE_START(SPEAR1310_DT, "ST SPEAr1310 SoC with Flattened Device Tree")
 	.smp		=	smp_ops(spear13xx_smp_ops),
 	.map_io		=	spear1310_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear13xx_timer_init,
 	.init_machine	=	spear1310_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-spear/spear1340.c b/arch/arm/mach-spear/spear1340.c
index a04a7fe..3fb6834 100644
--- a/arch/arm/mach-spear/spear1340.c
+++ b/arch/arm/mach-spear/spear1340.c
@@ -17,7 +17,6 @@
 #include <linux/amba/serial.h>
 #include <linux/delay.h>
 #include <linux/of_platform.h>
-#include <linux/irqchip.h>
 #include <asm/mach/arch.h>
 #include "generic.h"
 #include <mach/spear.h>
@@ -155,7 +154,6 @@ static const char * const spear1340_dt_board_compat[] = {
 DT_MACHINE_START(SPEAR1340_DT, "ST SPEAr1340 SoC with Flattened Device Tree")
 	.smp		=	smp_ops(spear13xx_smp_ops),
 	.map_io		=	spear13xx_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear13xx_timer_init,
 	.init_machine	=	spear1340_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-spear/spear300.c b/arch/arm/mach-spear/spear300.c
index bac56e8..b52e48f 100644
--- a/arch/arm/mach-spear/spear300.c
+++ b/arch/arm/mach-spear/spear300.c
@@ -14,7 +14,6 @@
 #define pr_fmt(fmt) "SPEAr300: " fmt
 
 #include <linux/amba/pl08x.h>
-#include <linux/irqchip.h>
 #include <linux/of_platform.h>
 #include <asm/mach/arch.h>
 #include "generic.h"
@@ -212,7 +211,6 @@ static void __init spear300_map_io(void)
 
 DT_MACHINE_START(SPEAR300_DT, "ST SPEAr300 SoC with Flattened Device Tree")
 	.map_io		=	spear300_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear3xx_timer_init,
 	.init_machine	=	spear300_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-spear/spear310.c b/arch/arm/mach-spear/spear310.c
index 6ffbc63..ed2029d 100644
--- a/arch/arm/mach-spear/spear310.c
+++ b/arch/arm/mach-spear/spear310.c
@@ -15,7 +15,6 @@
 
 #include <linux/amba/pl08x.h>
 #include <linux/amba/serial.h>
-#include <linux/irqchip.h>
 #include <linux/of_platform.h>
 #include <asm/mach/arch.h>
 #include "generic.h"
@@ -254,7 +253,6 @@ static void __init spear310_map_io(void)
 
 DT_MACHINE_START(SPEAR310_DT, "ST SPEAr310 SoC with Flattened Device Tree")
 	.map_io		=	spear310_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear3xx_timer_init,
 	.init_machine	=	spear310_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-spear/spear320.c b/arch/arm/mach-spear/spear320.c
index 6eb3eec..bf634b3 100644
--- a/arch/arm/mach-spear/spear320.c
+++ b/arch/arm/mach-spear/spear320.c
@@ -16,7 +16,6 @@
 #include <linux/amba/pl022.h>
 #include <linux/amba/pl08x.h>
 #include <linux/amba/serial.h>
-#include <linux/irqchip.h>
 #include <linux/of_platform.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -269,7 +268,6 @@ static void __init spear320_map_io(void)
 
 DT_MACHINE_START(SPEAR320_DT, "ST SPEAr320 SoC with Flattened Device Tree")
 	.map_io		=	spear320_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear3xx_timer_init,
 	.init_machine	=	spear320_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-spear/spear6xx.c b/arch/arm/mach-spear/spear6xx.c
index ec8eefb..8b0295a 100644
--- a/arch/arm/mach-spear/spear6xx.c
+++ b/arch/arm/mach-spear/spear6xx.c
@@ -16,7 +16,6 @@
 #include <linux/amba/pl08x.h>
 #include <linux/clk.h>
 #include <linux/err.h>
-#include <linux/irqchip.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
@@ -423,7 +422,6 @@ static const char *spear600_dt_board_compat[] = {
 
 DT_MACHINE_START(SPEAR600_DT, "ST SPEAr600 (Flattened Device Tree)")
 	.map_io		=	spear6xx_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear6xx_timer_init,
 	.init_machine	=	spear600_dt_init,
 	.restart	=	spear_restart,
-- 
1.8.1.2

