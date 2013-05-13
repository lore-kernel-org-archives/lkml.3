Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3EMJol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:44:41 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41624 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3EMJoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:44:38 -0400
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
Subject: [PATCH 07/14] ARM: spear: Remove init_irq declaration in machine description
Date: Mon, 13 May 2013 11:44:06 +0200
Message-Id: <1368438253-28218-8-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368438253-28218-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1368438253-28218-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
specified") removed the need to explictly setup the init_irq field in
the machine description when using only irqchip_init. Remove that
declaration for spear as well.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-spear/spear1310.c | 1 -
 arch/arm/mach-spear/spear1340.c | 1 -
 arch/arm/mach-spear/spear300.c  | 1 -
 arch/arm/mach-spear/spear310.c  | 1 -
 arch/arm/mach-spear/spear320.c  | 1 -
 arch/arm/mach-spear/spear6xx.c  | 1 -
 6 files changed, 6 deletions(-)

diff --git a/arch/arm/mach-spear/spear1310.c b/arch/arm/mach-spear/spear1310.c
index 9eaac2c..b2da424 100644
--- a/arch/arm/mach-spear/spear1310.c
+++ b/arch/arm/mach-spear/spear1310.c
@@ -60,7 +60,6 @@ static void __init spear1310_map_io(void)
 DT_MACHINE_START(SPEAR1310_DT, "ST SPEAr1310 SoC with Flattened Device Tree")
 	.smp		=	smp_ops(spear13xx_smp_ops),
 	.map_io		=	spear1310_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear13xx_timer_init,
 	.init_machine	=	spear1310_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-spear/spear1340.c b/arch/arm/mach-spear/spear1340.c
index a04a7fe..dae1167 100644
--- a/arch/arm/mach-spear/spear1340.c
+++ b/arch/arm/mach-spear/spear1340.c
@@ -155,7 +155,6 @@ static const char * const spear1340_dt_board_compat[] = {
 DT_MACHINE_START(SPEAR1340_DT, "ST SPEAr1340 SoC with Flattened Device Tree")
 	.smp		=	smp_ops(spear13xx_smp_ops),
 	.map_io		=	spear13xx_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear13xx_timer_init,
 	.init_machine	=	spear1340_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-spear/spear300.c b/arch/arm/mach-spear/spear300.c
index bac56e8..185b9ba 100644
--- a/arch/arm/mach-spear/spear300.c
+++ b/arch/arm/mach-spear/spear300.c
@@ -212,7 +212,6 @@ static void __init spear300_map_io(void)
 
 DT_MACHINE_START(SPEAR300_DT, "ST SPEAr300 SoC with Flattened Device Tree")
 	.map_io		=	spear300_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear3xx_timer_init,
 	.init_machine	=	spear300_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-spear/spear310.c b/arch/arm/mach-spear/spear310.c
index 6ffbc63..ebc07e6 100644
--- a/arch/arm/mach-spear/spear310.c
+++ b/arch/arm/mach-spear/spear310.c
@@ -254,7 +254,6 @@ static void __init spear310_map_io(void)
 
 DT_MACHINE_START(SPEAR310_DT, "ST SPEAr310 SoC with Flattened Device Tree")
 	.map_io		=	spear310_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear3xx_timer_init,
 	.init_machine	=	spear310_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-spear/spear320.c b/arch/arm/mach-spear/spear320.c
index 6eb3eec..1fa4929 100644
--- a/arch/arm/mach-spear/spear320.c
+++ b/arch/arm/mach-spear/spear320.c
@@ -269,7 +269,6 @@ static void __init spear320_map_io(void)
 
 DT_MACHINE_START(SPEAR320_DT, "ST SPEAr320 SoC with Flattened Device Tree")
 	.map_io		=	spear320_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear3xx_timer_init,
 	.init_machine	=	spear320_dt_init,
 	.restart	=	spear_restart,
diff --git a/arch/arm/mach-spear/spear6xx.c b/arch/arm/mach-spear/spear6xx.c
index ec8eefb..0359f2e 100644
--- a/arch/arm/mach-spear/spear6xx.c
+++ b/arch/arm/mach-spear/spear6xx.c
@@ -423,7 +423,6 @@ static const char *spear600_dt_board_compat[] = {
 
 DT_MACHINE_START(SPEAR600_DT, "ST SPEAr600 (Flattened Device Tree)")
 	.map_io		=	spear6xx_map_io,
-	.init_irq	=	irqchip_init,
 	.init_time	=	spear6xx_timer_init,
 	.init_machine	=	spear600_dt_init,
 	.restart	=	spear_restart,
-- 
1.8.1.2

