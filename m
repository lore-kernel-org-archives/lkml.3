Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaLCMPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:15:42 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36243 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbaLCMPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:15:35 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        horms@verge.net.au, tglx@linutronix.de, jason@lakedaemon.net
Date: Wed, 03 Dec 2014 21:18:13 +0900
Message-Id: <20141203121813.5936.17433.sendpatchset@w520>
In-Reply-To: <20141203121753.5936.36253.sendpatchset@w520>
References: <20141203121753.5936.36253.sendpatchset@w520>
Subject: [PATCH 02/02] ARM: shmobile: marzen-reference: Remove IRLM workaround
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm+renesas@opensource.se>

Adjust the r8a7779 SoC DTS and the Marzen Reference
C board code to use DTS only for INTC-IRQPIN IRLM setup.

Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
---

 Written on top of renesas-devel-20141202-v3.18-rc7 and
 [PATCH] ARM: shmobile: r8a7779 CCF DTS update

 Has a runtime dependency on:
 [PATCH 01/02] irqchip: renesas-intc-irqpin: r8a7779 IRLM setup support

 arch/arm/boot/dts/r8a7779.dtsi                  |    5 +++--
 arch/arm/mach-shmobile/board-marzen-reference.c |    7 -------
 2 files changed, 3 insertions(+), 9 deletions(-)

--- 0002/arch/arm/boot/dts/r8a7779.dtsi
+++ work/arch/arm/boot/dts/r8a7779.dtsi	2014-12-03 20:27:49.000000000 +0900
@@ -139,7 +139,7 @@
 		interrupt-controller;
 	};
 
-	irqpin0: irqpin@fe780010 {
+	irqpin0: irqpin@fe780000 {
 		compatible = "renesas,intc-irqpin-r8a7779", "renesas,intc-irqpin";
 		#interrupt-cells = <2>;
 		status = "disabled";
@@ -148,7 +148,8 @@
 			<0xfe780010 4>,
 			<0xfe780024 4>,
 			<0xfe780044 4>,
-			<0xfe780064 4>;
+			<0xfe780064 4>,
+			<0xfe780000 4>;
 		interrupts = <0 27 IRQ_TYPE_LEVEL_HIGH
 			      0 28 IRQ_TYPE_LEVEL_HIGH
 			      0 29 IRQ_TYPE_LEVEL_HIGH
--- 0001/arch/arm/mach-shmobile/board-marzen-reference.c
+++ work/arch/arm/mach-shmobile/board-marzen-reference.c	2014-12-03 20:28:37.000000000 +0900
@@ -32,12 +32,6 @@ static void __init marzen_init_timer(voi
 	clocksource_of_init();
 }
 
-static void __init marzen_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-	r8a7779_init_irq_extpin_dt(1); /* IRQ1 as individual interrupt */
-}
-
 static const char *marzen_boards_compat_dt[] __initdata = {
 	"renesas,marzen",
 	"renesas,marzen-reference",
@@ -50,7 +44,6 @@ DT_MACHINE_START(MARZEN, "marzen")
 	.init_early	= shmobile_init_delay,
 	.init_time	= marzen_init_timer,
 	.init_irq	= r8a7779_init_irq_dt,
-	.init_machine	= marzen_init,
 	.init_late	= shmobile_init_late,
 	.dt_compat	= marzen_boards_compat_dt,
 MACHINE_END
