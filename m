Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3LQKMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 05:12:31 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62222 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab3LQKM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 05:12:28 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: khilman@linaro.org, arnd@arndb.de, linux-sh@vger.kernel.org,
        daniel.lezcano@linaro.org, horms@verge.net.au, john.stultz@linaro.org,
        olof@lixom.net, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Tue, 17 Dec 2013 19:13:19 +0900
Message-Id: <20131217101319.17491.50953.sendpatchset@w520>
In-Reply-To: <20131217101212.17491.56898.sendpatchset@w520>
References: <20131217101212.17491.56898.sendpatchset@w520>
Subject: [PATCH v5 03/03] sh: Remove Kconfig entries for TMU, CMT and MTU2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Now when drivers/clocksource/Kconfig has been
updated with entires for CMT, TMU and MTU2
it is safe to remove these from SH.

Signed-off-by: Magnus Damm <damm@opensource.se>
Acked-by: John Stultz <john.stultz@linaro.org>
---

 arch/sh/Kconfig |   76 ++++++++++++++++---------------------------------------
 1 file changed, 23 insertions(+), 53 deletions(-)

--- 0001/arch/sh/Kconfig
+++ work/arch/sh/Kconfig	2013-12-17 18:56:15.000000000 +0900
@@ -122,15 +122,6 @@ config SYS_SUPPORTS_NUMA
 config SYS_SUPPORTS_PCI
 	bool
 
-config SYS_SUPPORTS_CMT
-	bool
-
-config SYS_SUPPORTS_MTU2
-	bool
-
-config SYS_SUPPORTS_TMU
-	bool
-
 config STACKTRACE_SUPPORT
 	def_bool y
 
@@ -190,14 +181,14 @@ config CPU_SH3
 	bool
 	select CPU_HAS_INTEVT
 	select CPU_HAS_SR_RB
-	select SYS_SUPPORTS_TMU
+	select SYS_SUPPORTS_SH_TMU
 
 config CPU_SH4
 	bool
 	select CPU_HAS_INTEVT
 	select CPU_HAS_SR_RB
 	select CPU_HAS_FPU if !CPU_SH4AL_DSP
-	select SYS_SUPPORTS_TMU
+	select SYS_SUPPORTS_SH_TMU
 	select SYS_SUPPORTS_HUGETLBFS if MMU
 
 config CPU_SH4A
@@ -212,7 +203,7 @@ config CPU_SH4AL_DSP
 config CPU_SH5
 	bool
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_TMU
+	select SYS_SUPPORTS_SH_TMU
 	select SYS_SUPPORTS_HUGETLBFS if MMU
 
 config CPU_SHX2
@@ -249,7 +240,7 @@ choice
 config CPU_SUBTYPE_SH7619
 	bool "Support SH7619 processor"
 	select CPU_SH2
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 
 # SH-2A Processor Support
 
@@ -257,50 +248,50 @@ config CPU_SUBTYPE_SH7201
 	bool "Support SH7201 processor"
 	select CPU_SH2A
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_MTU2
  
 config CPU_SUBTYPE_SH7203
 	bool "Support SH7203 processor"
 	select CPU_SH2A
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_CMT
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_MTU2
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7206
 	bool "Support SH7206 processor"
 	select CPU_SH2A
-	select SYS_SUPPORTS_CMT
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_MTU2
 
 config CPU_SUBTYPE_SH7263
 	bool "Support SH7263 processor"
 	select CPU_SH2A
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_CMT
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_MTU2
 
 config CPU_SUBTYPE_SH7264
 	bool "Support SH7264 processor"
 	select CPU_SH2A
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_CMT
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_MTU2
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7269
 	bool "Support SH7269 processor"
 	select CPU_SH2A
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_CMT
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_MTU2
 	select PINCTRL
 
 config CPU_SUBTYPE_MXG
 	bool "Support MX-G processor"
 	select CPU_SH2A
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_MTU2
 	help
 	  Select MX-G if running on an R8A03022BG part.
 
@@ -353,7 +344,7 @@ config CPU_SUBTYPE_SH7720
 	bool "Support SH7720 processor"
 	select CPU_SH3
 	select CPU_HAS_DSP
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select USB_ARCH_HAS_OHCI
 	select USB_OHCI_SH if USB_OHCI_HCD
@@ -365,7 +356,7 @@ config CPU_SUBTYPE_SH7721
 	bool "Support SH7721 processor"
 	select CPU_SH3
 	select CPU_HAS_DSP
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 	select USB_ARCH_HAS_OHCI
 	select USB_OHCI_SH if USB_OHCI_HCD
 	help
@@ -421,7 +412,7 @@ config CPU_SUBTYPE_SH7723
 	select CPU_SHX2
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PINCTRL
 	help
@@ -433,7 +424,7 @@ config CPU_SUBTYPE_SH7724
 	select CPU_SHX2
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PINCTRL
 	help
@@ -513,7 +504,7 @@ config CPU_SUBTYPE_SH7343
 	bool "Support SH7343 processor"
 	select CPU_SH4AL_DSP
 	select ARCH_SHMOBILE
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 
 config CPU_SUBTYPE_SH7722
 	bool "Support SH7722 processor"
@@ -522,7 +513,7 @@ config CPU_SUBTYPE_SH7722
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_NUMA
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PINCTRL
 
@@ -533,7 +524,7 @@ config CPU_SUBTYPE_SH7366
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_NUMA
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 
 endchoice
 
@@ -566,27 +557,6 @@ source "arch/sh/boards/Kconfig"
 
 menu "Timer and clock configuration"
 
-config SH_TIMER_TMU
-	bool "TMU timer driver"
-	depends on SYS_SUPPORTS_TMU
-	default y
-	help
-	  This enables the build of the TMU timer driver.
-
-config SH_TIMER_CMT
-	bool "CMT timer driver"
-	depends on SYS_SUPPORTS_CMT
-	default y
-	help
-	  This enables build of the CMT timer driver.
-
-config SH_TIMER_MTU2
-	bool "MTU2 timer driver"
-	depends on SYS_SUPPORTS_MTU2
-	default y
-	help
-	  This enables build of the MTU2 timer driver.
-
 config SH_PCLK_FREQ
 	int "Peripheral clock frequency (in Hz)"
 	depends on SH_CLK_CPG_LEGACY
