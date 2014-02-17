Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaBQU4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:56:12 -0500
Received: from sauhun.de ([89.238.76.85]:41067 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbaBQU4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:56:06 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <damm@opensource.se>, khilman@linaro.org, arnd@arndb.de,
        linux-sh@vger.kernel.org, daniel.lezcano@linaro.org,
        horms@verge.net.au, john.stultz@linaro.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH V6 2/3] ARM: shmobile: Remove CMT, TMU and STI Kconfig entries
Date: Mon, 17 Feb 2014 21:55:31 +0100
Message-Id: <1392670532-21523-3-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1392670532-21523-1-git-send-email-wsa@the-dreams.de>
References: <1392670532-21523-1-git-send-email-wsa@the-dreams.de>
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
[wsa: rebased to renesas-devel-v3.14-rc3-20140217]
Signed-off-by: Wolfram Sang <wsa@sang-engineering.com>
---
 arch/arm/mach-shmobile/Kconfig | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index 4b89116..d80df50 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -25,17 +25,21 @@ comment "Renesas ARM SoCs System Type"
 
 config ARCH_EMEV2
 	bool "Emma Mobile EV2"
+	select SYS_SUPPORTS_EM_STI
 
 config ARCH_R7S72100
 	bool "RZ/A1H (R7S72100)"
+	select SYS_SUPPORTS_SH_MTU2
 
 config ARCH_R8A7790
 	bool "R-Car H2 (R8A77900)"
 	select RENESAS_IRQC
+	select SYS_SUPPORTS_SH_CMT
 
 config ARCH_R8A7791
 	bool "R-Car M2 (R8A77910)"
 	select RENESAS_IRQC
+	select SYS_SUPPORTS_SH_CMT
 
 comment "Renesas ARM SoCs Board Type"
 
@@ -72,6 +76,8 @@ config ARCH_SH7372
 	select ARM_CPU_SUSPEND if PM || CPU_IDLE
 	select CPU_V7
 	select SH_CLK_CPG
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_SH73A0
 	bool "SH-Mobile AG5 (R8A73A00)"
@@ -81,6 +87,8 @@ config ARCH_SH73A0
 	select I2C
 	select SH_CLK_CPG
 	select RENESAS_INTC_IRQPIN
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_R8A73A4
 	bool "R-Mobile APE6 (R8A73A40)"
@@ -91,6 +99,8 @@ config ARCH_R8A73A4
 	select RENESAS_IRQC
 	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_OPP
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_R8A7740
 	bool "R-Mobile A1 (R8A77400)"
@@ -99,6 +109,8 @@ config ARCH_R8A7740
 	select CPU_V7
 	select SH_CLK_CPG
 	select RENESAS_INTC_IRQPIN
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_R8A7778
 	bool "R-Car M1A (R8A77781)"
@@ -108,6 +120,7 @@ config ARCH_R8A7778
 	select ARM_GIC
 	select USB_ARCH_HAS_EHCI
 	select USB_ARCH_HAS_OHCI
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_R8A7779
 	bool "R-Car H1 (R8A77790)"
@@ -118,6 +131,7 @@ config ARCH_R8A7779
 	select USB_ARCH_HAS_EHCI
 	select USB_ARCH_HAS_OHCI
 	select RENESAS_INTC_IRQPIN
+	select SYS_SUPPORTS_SH_TMU
 
 config ARCH_R8A7790
 	bool "R-Car H2 (R8A77900)"
@@ -128,6 +142,7 @@ config ARCH_R8A7790
 	select SH_CLK_CPG
 	select RENESAS_IRQC
 	select ARCH_DMA_ADDR_T_64BIT if ARM_LPAE
+	select SYS_SUPPORTS_SH_CMT
 
 config ARCH_R8A7791
 	bool "R-Car M2 (R8A77910)"
@@ -138,6 +153,7 @@ config ARCH_R8A7791
 	select SH_CLK_CPG
 	select RENESAS_IRQC
 	select ARCH_DMA_ADDR_T_64BIT if ARM_LPAE
+	select SYS_SUPPORTS_SH_CMT
 
 config ARCH_R7S72100
 	bool "RZ/A1H (R7S72100)"
@@ -145,6 +161,7 @@ config ARCH_R7S72100
 	select ARM_GIC
 	select CPU_V7
 	select SH_CLK_CPG
+	select SYS_SUPPORTS_SH_MTU2
 
 comment "Renesas ARM SoCs Board Type"
 
@@ -325,24 +342,6 @@ config SHMOBILE_TIMER_HZ
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
-- 
1.8.5.1

