Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3LQKMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 05:12:19 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:54482 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3LQKMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 05:12:18 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: khilman@linaro.org, arnd@arndb.de, linux-sh@vger.kernel.org,
        daniel.lezcano@linaro.org, horms@verge.net.au, john.stultz@linaro.org,
        olof@lixom.net, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Tue, 17 Dec 2013 19:12:48 +0900
Message-Id: <20131217101248.17491.52424.sendpatchset@w520>
In-Reply-To: <20131217101212.17491.56898.sendpatchset@w520>
References: <20131217101212.17491.56898.sendpatchset@w520>
Subject: [PATCH v5 02/03] ARM: shmobile: Remove CMT, TMU and STI Kconfig entries
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Now when drivers/clocksource/Kconfig has been
updated with entires for CMT, TMU and STI
it is safe to remove these from mach-shmobile.

Also select timers per SoC via SYS_SUPPORTS_xxx.

Signed-off-by: Magnus Damm <damm@opensource.se>
Acked-by: John Stultz <john.stultz@linaro.org>
---

 arch/arm/mach-shmobile/Kconfig |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

--- 0001/arch/arm/mach-shmobile/Kconfig
+++ work/arch/arm/mach-shmobile/Kconfig	2013-12-17 18:52:58.000000000 +0900
@@ -24,13 +24,16 @@ comment "Renesas ARM SoCs System Type"
 
 config ARCH_EMEV2
 	bool "Emma Mobile EV2"
+	select SYS_SUPPORTS_EM_STI
 
 config ARCH_R7S72100
 	bool "RZ/A1H (R7S72100)"
+	select SYS_SUPPORTS_SH_MTU2
 
 config ARCH_R8A7791
 	bool "R-Car M2 (R8A77910)"
 	select RENESAS_IRQC
+	select SYS_SUPPORTS_SH_CMT
 
 comment "Renesas ARM SoCs Board Type"
 
@@ -60,6 +63,8 @@ config ARCH_SH7372
 	select ARM_CPU_SUSPEND if PM || CPU_IDLE
 	select CPU_V7
 	select SH_CLK_CPG
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_SH73A0
 	bool "SH-Mobile AG5 (R8A73A00)"
@@ -69,6 +74,8 @@ config ARCH_SH73A0
 	select I2C
 	select SH_CLK_CPG
 	select RENESAS_INTC_IRQPIN
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_R8A73A4
 	bool "R-Mobile APE6 (R8A73A40)"
@@ -79,6 +86,8 @@ config ARCH_R8A73A4
 	select RENESAS_IRQC
 	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_OPP
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_R8A7740
 	bool "R-Mobile A1 (R8A77400)"
@@ -87,6 +96,8 @@ config ARCH_R8A7740
 	select CPU_V7
 	select SH_CLK_CPG
 	select RENESAS_INTC_IRQPIN
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_R8A7778
 	bool "R-Car M1A (R8A77781)"
@@ -96,6 +107,7 @@ config ARCH_R8A7778
 	select ARM_GIC
 	select USB_ARCH_HAS_EHCI
 	select USB_ARCH_HAS_OHCI
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_R8A7779
 	bool "R-Car H1 (R8A77790)"
@@ -106,6 +118,7 @@ config ARCH_R8A7779
 	select USB_ARCH_HAS_EHCI
 	select USB_ARCH_HAS_OHCI
 	select RENESAS_INTC_IRQPIN
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_R8A7790
 	bool "R-Car H2 (R8A77900)"
@@ -115,6 +128,7 @@ config ARCH_R8A7790
 	select MIGHT_HAVE_PCI
 	select SH_CLK_CPG
 	select RENESAS_IRQC
+	select SYS_SUPPORTS_SH_CMT
 
 config ARCH_R8A7791
 	bool "R-Car M2 (R8A77910)"
@@ -124,6 +138,7 @@ config ARCH_R8A7791
 	select MIGHT_HAVE_PCI
 	select SH_CLK_CPG
 	select RENESAS_IRQC
+	select SYS_SUPPORTS_SH_CMT
 
 config ARCH_EMEV2
 	bool "Emma Mobile EV2"
@@ -133,6 +148,7 @@ config ARCH_EMEV2
 	select MIGHT_HAVE_PCI
 	select USE_OF
 	select AUTO_ZRELADDR
+	select SYS_SUPPORTS_EM_STI
 
 config ARCH_R7S72100
 	bool "RZ/A1H (R7S72100)"
@@ -140,6 +156,7 @@ config ARCH_R7S72100
 	select ARM_GIC
 	select CPU_V7
 	select SH_CLK_CPG
+	select SYS_SUPPORTS_SH_MTU2
 
 comment "Renesas ARM SoCs Board Type"
 
@@ -334,24 +351,6 @@ config SHMOBILE_TIMER_HZ
 	  want to select a HZ value such as 128 that can evenly divide RCLK.
 	  A HZ value that does not divide evenly may cause timer drift.
 
-config SH_TIMER_CMT
-	bool "CMT timer driver"
-	default y
-	help
-	  This enables build of the CMT timer driver.
-
-config SH_TIMER_TMU
-	bool "TMU timer driver"
-	default y
-	help
-	  This enables build of the TMU timer driver.
-
-config EM_TIMER_STI
-	bool "STI timer driver"
-	default y
-	help
-	  This enables build of the STI timer driver.
-
 endmenu
 
 endif
