Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3EQI7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:59:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46829 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab3EQI7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:59:20 -0400
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Kumar Gala <galak@kernel.crashing.org>,
        U Bhaskar-B22300 <B22300@freescale.com>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2] can: flexcan: remove HAVE_CAN_FLEXCAN Kconfig symbol
Date: Fri, 17 May 2013 10:59:17 +0200
Message-Id: <1368781157-4646-1-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc2
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the Kconfig symbol HAVE_CAN_FLEXCAN from arch/{arm,powerpc}
and allowing compilation unconditionally on all arm and powerpc platforms.

This brings a bigger compile time coverage and removes the following dependency
warning found by Arnd Bergmann:

    warning: (SOC_IMX28 && SOC_IMX25 && SOC_IMX35 && IMX_HAVE_PLATFORM_FLEXCAN &&
        SOC_IMX53 && SOC_IMX6Q) selects HAVE_CAN_FLEXCAN
    which has unmet direct dependencies (NET && CAN && CAN_DEV)

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: U Bhaskar-B22300 <B22300@freescale.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
Changes since v1:
- don't remove IMX_HAVE_PLATFORM_FLEXCAN, which breaks non DT imx platforms
  tnx Shawn

 arch/arm/mach-imx/Kconfig         | 4 ----
 arch/arm/mach-imx/devices/Kconfig | 1 -
 arch/arm/mach-mxs/Kconfig         | 1 -
 arch/powerpc/Kconfig              | 1 -
 drivers/net/can/Kconfig           | 5 +----
 5 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index ba44328..af8e109 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -111,7 +111,6 @@ config SOC_IMX25
 	select ARCH_MXC_IOMUX_V3
 	select COMMON_CLK
 	select CPU_ARM926T
-	select HAVE_CAN_FLEXCAN if CAN
 	select MXC_AVIC
 
 config SOC_IMX27
@@ -137,7 +136,6 @@ config SOC_IMX35
 	select ARCH_MXC_IOMUX_V3
 	select COMMON_CLK
 	select CPU_V6K
-	select HAVE_CAN_FLEXCAN if CAN
 	select HAVE_EPIT
 	select MXC_AVIC
 	select SMP_ON_UP if SMP
@@ -776,7 +774,6 @@ comment "Device tree only"
 
 config	SOC_IMX53
 	bool "i.MX53 support"
-	select HAVE_CAN_FLEXCAN if CAN
 	select HAVE_IMX_SRC
 	select IMX_HAVE_PLATFORM_IMX2_WDT
 	select PINCTRL
@@ -799,7 +796,6 @@ config SOC_IMX6Q
 	select CPU_V7
 	select HAVE_ARM_SCU if SMP
 	select HAVE_ARM_TWD if LOCAL_TIMERS
-	select HAVE_CAN_FLEXCAN if CAN
 	select HAVE_IMX_ANATOP
 	select HAVE_IMX_GPC
 	select HAVE_IMX_MMDC
diff --git a/arch/arm/mach-imx/devices/Kconfig b/arch/arm/mach-imx/devices/Kconfig
index 3dd2b1b..68c74fb 100644
--- a/arch/arm/mach-imx/devices/Kconfig
+++ b/arch/arm/mach-imx/devices/Kconfig
@@ -4,7 +4,6 @@ config IMX_HAVE_PLATFORM_FEC
 
 config IMX_HAVE_PLATFORM_FLEXCAN
 	bool
-	select HAVE_CAN_FLEXCAN if CAN
 
 config IMX_HAVE_PLATFORM_FSL_USB2_UDC
 	bool
diff --git a/arch/arm/mach-mxs/Kconfig b/arch/arm/mach-mxs/Kconfig
index 4dc2fbb..ce6e7d6 100644
--- a/arch/arm/mach-mxs/Kconfig
+++ b/arch/arm/mach-mxs/Kconfig
@@ -11,7 +11,6 @@ config SOC_IMX28
 	select ARM_AMBA
 	select ARM_CPU_SUSPEND if PM
 	select CPU_ARM926T
-	select HAVE_CAN_FLEXCAN if CAN
 	select HAVE_PWM
 	select PINCTRL_IMX28
 
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index c33e3ad..7754c6b 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -674,7 +674,6 @@ config SBUS
 
 config FSL_SOC
 	bool
-	select HAVE_CAN_FLEXCAN if NET && CAN
 
 config FSL_PCI
  	bool
diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index e456b70..3c06947 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -102,12 +102,9 @@ config CAN_JANZ_ICAN3
 	  This driver can also be built as a module. If so, the module will be
 	  called janz-ican3.ko.
 
-config HAVE_CAN_FLEXCAN
-	bool
-
 config CAN_FLEXCAN
 	tristate "Support for Freescale FLEXCAN based chips"
-	depends on HAVE_CAN_FLEXCAN
+	depends on ARM || PPC
 	---help---
 	  Say Y here if you want to support for Freescale FlexCAN.
 
-- 
1.8.2.rc2

