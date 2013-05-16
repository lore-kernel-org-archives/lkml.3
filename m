Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3EPNmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:42:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39035 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab3EPNmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:42:42 -0400
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Kumar Gala <galak@kernel.crashing.org>,
        U Bhaskar-B22300 <B22300@freescale.com>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] can: flexcan: allow compilation on arm and powerpc
Date: Thu, 16 May 2013 15:42:36 +0200
Message-Id: <1368711756-22324-1-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc2
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the Kconfig symbols HAVE_CAN_FLEXCAN and
IMX_HAVE_PLATFORM_FLEXCAN from arch/{arm,powerpc} and allowing compilation on
all arm and powerpc platforms.

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
Hello,

if the arm and powerpc people are okay with this, I'm taking this patch (and
then will go upstream via David Miller's net-next).

regards,
Marc

 arch/arm/mach-imx/Kconfig         | 8 --------
 arch/arm/mach-imx/devices/Kconfig | 4 ----
 arch/arm/mach-mxs/Kconfig         | 1 -
 arch/powerpc/Kconfig              | 1 -
 drivers/net/can/Kconfig           | 5 +----
 5 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index ba44328..239d084 100644
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
@@ -208,7 +206,6 @@ comment "MX25 platforms:"
 
 config MACH_MX25_3DS
 	bool "Support MX25PDK (3DS) Platform"
-	select IMX_HAVE_PLATFORM_FLEXCAN
 	select IMX_HAVE_PLATFORM_FSL_USB2_UDC
 	select IMX_HAVE_PLATFORM_IMX2_WDT
 	select IMX_HAVE_PLATFORM_IMXDI_RTC
@@ -223,7 +220,6 @@ config MACH_MX25_3DS
 
 config MACH_EUKREA_CPUIMX25SD
 	bool "Support Eukrea CPUIMX25 Platform"
-	select IMX_HAVE_PLATFORM_FLEXCAN
 	select IMX_HAVE_PLATFORM_FSL_USB2_UDC
 	select IMX_HAVE_PLATFORM_IMX2_WDT
 	select IMX_HAVE_PLATFORM_IMXDI_RTC
@@ -629,7 +625,6 @@ comment "MX35 platforms:"
 
 config MACH_PCM043
 	bool "Support Phytec pcm043 (i.MX35) platforms"
-	select IMX_HAVE_PLATFORM_FLEXCAN
 	select IMX_HAVE_PLATFORM_FSL_USB2_UDC
 	select IMX_HAVE_PLATFORM_IMX2_WDT
 	select IMX_HAVE_PLATFORM_IMX_I2C
@@ -665,7 +660,6 @@ config MACH_MX35_3DS
 
 config MACH_EUKREA_CPUIMX35SD
 	bool "Support Eukrea CPUIMX35 Platform"
-	select IMX_HAVE_PLATFORM_FLEXCAN
 	select IMX_HAVE_PLATFORM_FSL_USB2_UDC
 	select IMX_HAVE_PLATFORM_IMX2_WDT
 	select IMX_HAVE_PLATFORM_IMX_I2C
@@ -776,7 +770,6 @@ comment "Device tree only"
 
 config	SOC_IMX53
 	bool "i.MX53 support"
-	select HAVE_CAN_FLEXCAN if CAN
 	select HAVE_IMX_SRC
 	select IMX_HAVE_PLATFORM_IMX2_WDT
 	select PINCTRL
@@ -799,7 +792,6 @@ config SOC_IMX6Q
 	select CPU_V7
 	select HAVE_ARM_SCU if SMP
 	select HAVE_ARM_TWD if LOCAL_TIMERS
-	select HAVE_CAN_FLEXCAN if CAN
 	select HAVE_IMX_ANATOP
 	select HAVE_IMX_GPC
 	select HAVE_IMX_MMDC
diff --git a/arch/arm/mach-imx/devices/Kconfig b/arch/arm/mach-imx/devices/Kconfig
index 3dd2b1b..b0a629d 100644
--- a/arch/arm/mach-imx/devices/Kconfig
+++ b/arch/arm/mach-imx/devices/Kconfig
@@ -2,10 +2,6 @@ config IMX_HAVE_PLATFORM_FEC
 	bool
 	default y if ARCH_MX25 || SOC_IMX27 || SOC_IMX35 || SOC_IMX51 || SOC_IMX53
 
-config IMX_HAVE_PLATFORM_FLEXCAN
-	bool
-	select HAVE_CAN_FLEXCAN if CAN
-
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

