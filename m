Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaANVvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:51:55 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51013 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaANVvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:51:51 -0500
From: John Tobias <john.tobias.ph@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, kernel@pengutronix.de, shawn.guo@linaro.org,
        festevam@gmail.com
Cc: John Tobias <john.tobias.ph@gmail.com>
Subject: [PATCH v5] ARM: imx: add select on ARCH_MXC for cpufreq support
Date: Tue, 14 Jan 2014 06:36:47 -0800
Message-Id: <1389710207-19761-1-git-send-email-john.tobias.ph@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ARCH_HAS_CPUFREQ, ARCH_HAS_OPP and PM_OPP on ARCH_MXC so that
the user can enable the cpufreq support for iMX6Q and/or iMX6SL.

Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
---
 arch/arm/mach-imx/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 7a6e6f7..4a500a4 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -1,5 +1,7 @@
 config ARCH_MXC
 	bool "Freescale i.MX family" if ARCH_MULTI_V4_V5 || ARCH_MULTI_V6_V7
+	select ARCH_HAS_CPUFREQ
+	select ARCH_HAS_OPP
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_CPU_SUSPEND if PM
 	select ARM_PATCH_PHYS_VIRT
@@ -11,6 +13,7 @@ config ARCH_MXC
 	select GENERIC_IRQ_CHIP
 	select MIGHT_HAVE_CACHE_L2X0 if ARCH_MULTI_V6_V7
 	select MULTI_IRQ_HANDLER
+	select PM_OPP if PM
 	select SOC_BUS
 	select SPARSE_IRQ
 	select USE_OF
@@ -779,8 +782,6 @@ config	SOC_IMX53
 
 config SOC_IMX6Q
 	bool "i.MX6 Quad/DualLite support"
-	select ARCH_HAS_CPUFREQ
-	select ARCH_HAS_OPP
 	select ARM_ERRATA_754322
 	select ARM_ERRATA_764369 if SMP
 	select ARM_ERRATA_775420
@@ -801,7 +802,6 @@ config SOC_IMX6Q
 	select PL310_ERRATA_588369 if CACHE_PL310
 	select PL310_ERRATA_727915 if CACHE_PL310
 	select PL310_ERRATA_769419 if CACHE_PL310
-	select PM_OPP if PM
 
 	help
 	  This enables support for Freescale i.MX6 Quad processor.
-- 
1.8.3.2

