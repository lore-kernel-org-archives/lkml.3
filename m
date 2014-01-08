Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbaAHT47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:56:59 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:52028 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaAHT45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:56:57 -0500
From: John Tobias <john.tobias.ph@gmail.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: shawn.guo@linaro.org, John Tobias <john.tobias.ph@gmail.com>
Subject: [PATCH v3] ARM: imx: add select on ARCH_MXC for cpufreq support
Date: Wed,  8 Jan 2014 11:56:31 -0800
Message-Id: <1389210991-23688-1-git-send-email-john.tobias.ph@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved ARCH_HAS_CPUFREQ, HAVE_IMX_ANATOP and PM_OPP on ARCH_MXC so that
the user can enable the cpufreq support for iMX6Q and/or iMX6SL.

Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
---
 arch/arm/mach-imx/Kconfig | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 7a6e6f7..3c326be 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -1,5 +1,6 @@
 config ARCH_MXC
 	bool "Freescale i.MX family" if ARCH_MULTI_V4_V5 || ARCH_MULTI_V6_V7
+	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_CPU_SUSPEND if PM
 	select ARM_PATCH_PHYS_VIRT
@@ -9,8 +10,10 @@ config ARCH_MXC
 	select GENERIC_ALLOCATOR
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_IRQ_CHIP
+	select HAVE_IMX_ANATOP
 	select MIGHT_HAVE_CACHE_L2X0 if ARCH_MULTI_V6_V7
 	select MULTI_IRQ_HANDLER
+	select PM_OPP if PM
 	select SOC_BUS
 	select SPARSE_IRQ
 	select USE_OF
@@ -779,16 +782,14 @@ config	SOC_IMX53
 
 config SOC_IMX6Q
 	bool "i.MX6 Quad/DualLite support"
-	select ARCH_HAS_CPUFREQ
-	select ARCH_HAS_OPP
+	select ARCH_HAS_OPP	
 	select ARM_ERRATA_754322
 	select ARM_ERRATA_764369 if SMP
 	select ARM_ERRATA_775420
 	select ARM_GIC
 	select CPU_V7
 	select HAVE_ARM_SCU if SMP
-	select HAVE_ARM_TWD if SMP
-	select HAVE_IMX_ANATOP
+	select HAVE_ARM_TWD if SMP	
 	select HAVE_IMX_GPC
 	select HAVE_IMX_MMDC
 	select HAVE_IMX_SRC
@@ -800,8 +801,7 @@ config SOC_IMX6Q
 	select PINCTRL_IMX6Q
 	select PL310_ERRATA_588369 if CACHE_PL310
 	select PL310_ERRATA_727915 if CACHE_PL310
-	select PL310_ERRATA_769419 if CACHE_PL310
-	select PM_OPP if PM
+	select PL310_ERRATA_769419 if CACHE_PL310	
 
 	help
 	  This enables support for Freescale i.MX6 Quad processor.
@@ -812,7 +812,6 @@ config SOC_IMX6SL
 	select ARM_ERRATA_775420
 	select ARM_GIC
 	select CPU_V7
-	select HAVE_IMX_ANATOP
 	select HAVE_IMX_GPC
 	select HAVE_IMX_MMDC
 	select HAVE_IMX_SRC
-- 
1.8.3.2

