Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab3LDUh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:37:56 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:62423 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303Ab3LDUhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:37:51 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: khilman@linaro.org, arnd@arndb.de, linux-sh@vger.kernel.org,
        daniel.lezcano@linaro.org, horms@verge.net.au, john.stultz@linaro.org,
        olof@lixom.net, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Thu, 05 Dec 2013 05:38:37 +0900
Message-Id: <20131204203837.19090.96622.sendpatchset@w520>
In-Reply-To: <20131204203818.19090.92396.sendpatchset@w520>
References: <20131204203818.19090.92396.sendpatchset@w520>
Subject: [PATCH v3 02/03] ARM: shmobile: Remove CMT, TMU and STI Kconfig entries
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Now when drivers/clocksource/Kconfig has been
updated with entires for CMT, TMU and STI
it is safe to remove these from mach-shmobile.

Also select timers per SoC via SYS_SUPPORTS_xxx.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/mach-shmobile/Kconfig |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

--- 0001/arch/arm/mach-shmobile/Kconfig
+++ work/arch/arm/mach-shmobile/Kconfig	2013-12-04 22:04:05.000000000 +0900
@@ -23,13 +23,16 @@ comment "SH-Mobile System Type"
 
 config ARCH_EMEV2
 	bool "Emma Mobile EV2"
+	select SYS_SUPPORTS_STI
 
 config ARCH_R7S72100
 	bool "RZ/A1H (R7S72100)"
+	select SYS_SUPPORTS_MTU2
 
 config ARCH_R8A7791
 	bool "R-Car M2 (R8A77910)"
 	select RENESAS_IRQC
+	select SYS_SUPPORTS_CMT
 
 comment "SH-Mobile Board Type"
 
@@ -59,6 +62,8 @@ config ARCH_SH7372
 	select ARM_CPU_SUSPEND if PM || CPU_IDLE
 	select CPU_V7
 	select SH_CLK_CPG
+	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_TMU
 
 config ARCH_SH73A0
 	bool "SH-Mobile AG5 (R8A73A00)"
@@ -68,6 +73,8 @@ config ARCH_SH73A0
 	select I2C
 	select SH_CLK_CPG
 	select RENESAS_INTC_IRQPIN
+	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_TMU
 
 config ARCH_R8A73A4
 	bool "R-Mobile APE6 (R8A73A40)"
@@ -78,6 +85,8 @@ config ARCH_R8A73A4
 	select RENESAS_IRQC
 	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_OPP
+	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_TMU
 
 config ARCH_R8A7740
 	bool "R-Mobile A1 (R8A77400)"
@@ -86,6 +95,8 @@ config ARCH_R8A7740
 	select CPU_V7
 	select SH_CLK_CPG
 	select RENESAS_INTC_IRQPIN
+	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_TMU
 
 config ARCH_R8A7778
 	bool "R-Car M1A (R8A77781)"
@@ -95,6 +106,7 @@ config ARCH_R8A7778
 	select ARM_GIC
 	select USB_ARCH_HAS_EHCI
 	select USB_ARCH_HAS_OHCI
+	select SYS_SUPPORTS_TMU
 
 config ARCH_R8A7779
 	bool "R-Car H1 (R8A77790)"
@@ -105,6 +117,7 @@ config ARCH_R8A7779
 	select USB_ARCH_HAS_EHCI
 	select USB_ARCH_HAS_OHCI
 	select RENESAS_INTC_IRQPIN
+	select SYS_SUPPORTS_TMU
 
 config ARCH_R8A7790
 	bool "R-Car H2 (R8A77900)"
@@ -113,6 +126,7 @@ config ARCH_R8A7790
 	select CPU_V7
 	select SH_CLK_CPG
 	select RENESAS_IRQC
+	select SYS_SUPPORTS_CMT
 
 config ARCH_R8A7791
 	bool "R-Car M2 (R8A77910)"
@@ -121,6 +135,7 @@ config ARCH_R8A7791
 	select CPU_V7
 	select SH_CLK_CPG
 	select RENESAS_IRQC
+	select SYS_SUPPORTS_CMT
 
 config ARCH_EMEV2
 	bool "Emma Mobile EV2"
@@ -128,6 +143,7 @@ config ARCH_EMEV2
 	select ARM_GIC
 	select CPU_V7
 	select USE_OF
+	select SYS_SUPPORTS_STI
 
 config ARCH_R7S72100
 	bool "RZ/A1H (R7S72100)"
@@ -135,6 +151,7 @@ config ARCH_R7S72100
 	select ARM_GIC
 	select CPU_V7
 	select SH_CLK_CPG
+	select SYS_SUPPORTS_MTU2
 
 comment "SH-Mobile Board Type"
 
@@ -329,24 +346,6 @@ config SHMOBILE_TIMER_HZ
 	  to select a HZ value such as 128 that can evenly divide RCLK.
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
