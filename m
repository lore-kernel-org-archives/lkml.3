Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbaGCOU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:20:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50931 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758346AbaGCOUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:20:18 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 01/18] power: reset: Add if statement isntead of multiple depends on
Date: Thu,  3 Jul 2014 16:14:34 +0200
Message-Id: <1404396906-25194-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the config option so far are depending on the POWER_RESET symbol

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/power/reset/Kconfig | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index bdcf5173e377..19d546c5edfa 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -6,15 +6,17 @@ menuconfig POWER_RESET
 
 	  Say Y here to enable board reset and power off
 
+if POWER_RESET
+
 config POWER_RESET_AS3722
 	bool "ams AS3722 power-off driver"
-	depends on MFD_AS3722 && POWER_RESET
+	depends on MFD_AS3722
 	help
 	  This driver supports turning off board via a ams AS3722 power-off.
 
 config POWER_RESET_AXXIA
 	bool "LSI Axxia reset driver"
-	depends on POWER_RESET && ARCH_AXXIA
+	depends on ARCH_AXXIA
 	help
 	  This driver supports restart for Axxia SoC.
 
@@ -22,7 +24,7 @@ config POWER_RESET_AXXIA
 
 config POWER_RESET_GPIO
 	bool "GPIO power-off driver"
-	depends on OF_GPIO && POWER_RESET
+	depends on OF_GPIO
 	help
 	  This driver supports turning off your board via a GPIO line.
 	  If your board needs a GPIO high/low to power down, say Y and
@@ -30,13 +32,13 @@ config POWER_RESET_GPIO
 
 config POWER_RESET_MSM
 	bool "Qualcomm MSM power-off driver"
-	depends on POWER_RESET && ARCH_QCOM
+	depends on ARCH_QCOM
 	help
 	  Power off and restart support for Qualcomm boards.
 
 config POWER_RESET_QNAP
 	bool "QNAP power-off driver"
-	depends on OF_GPIO && POWER_RESET && PLAT_ORION
+	depends on OF_GPIO && PLAT_ORION
 	help
 	  This driver supports turning off QNAP NAS devices by sending
 	  commands to the microcontroller which controls the main power.
@@ -54,14 +56,13 @@ config POWER_RESET_RESTART
 config POWER_RESET_SUN6I
 	bool "Allwinner A31 SoC reset driver"
 	depends on ARCH_SUNXI
-	depends on POWER_RESET
 	help
 	  Reboot support for the Allwinner A31 SoCs.
 
 config POWER_RESET_VEXPRESS
 	bool "ARM Versatile Express power-off and reset driver"
 	depends on ARM || ARM64
-	depends on POWER_RESET && VEXPRESS_CONFIG
+	depends on VEXPRESS_CONFIG
 	help
 	  Power off and reset support for the ARM Ltd. Versatile
 	  Express boards.
@@ -69,7 +70,6 @@ config POWER_RESET_VEXPRESS
 config POWER_RESET_XGENE
 	bool "APM SoC X-Gene reset driver"
 	depends on ARM64
-	depends on POWER_RESET
 	help
 	  Reboot support for the APM SoC X-Gene Eval boards.
 
@@ -80,3 +80,4 @@ config POWER_RESET_KEYSTONE
 	help
 	  Reboot support for the KEYSTONE SoCs.
 
+endif
-- 
2.0.1

