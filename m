Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaLBRMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:12:39 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:60874 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaLBRMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:12:20 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@roeck-us.net,
        arnd@arndb.de, sre@kernel.org, fkan@apm.com, mark.rutland@arm.com
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH v3 3/3] ARM: imx_v6_v7_defconfig: add POWER_RESET_SYSCON
Date: Tue,  2 Dec 2014 18:12:00 +0100
Message-Id: <1417540320-2385-4-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417540320-2385-1-git-send-email-stefan@agner.ch>
References: <1417540320-2385-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add POWER_RESET_SYSCON since Vybrid SoC's now make use of this
driver to provide software reset capabilities through the SRC
module.

Also regenerated using savedefconfig which removed the config
BACKLIGHT_LCD_SUPPORT which is now selected by default since
commit 9c8ee3c734139 ("video: mx3fb: always enable
BACKLIGHT_LCD_SUPPORT").

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/configs/imx_v6_v7_defconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index f707cd2..e928075 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -163,13 +163,14 @@ CONFIG_SPI_IMX=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_MC9S08DZ60=y
 CONFIG_GPIO_STMPE=y
+CONFIG_POWER_SUPPLY=y
+CONFIG_POWER_RESET=y
+CONFIG_POWER_RESET_IMX=y
+CONFIG_POWER_RESET_SYSCON=y
 CONFIG_SENSORS_GPIO_FAN=y
 CONFIG_THERMAL=y
 CONFIG_CPU_THERMAL=y
 CONFIG_IMX_THERMAL=y
-CONFIG_POWER_SUPPLY=y
-CONFIG_POWER_RESET=y
-CONFIG_POWER_RESET_IMX=y
 CONFIG_WATCHDOG=y
 CONFIG_IMX2_WDT=y
 CONFIG_MFD_DA9052_I2C=y
@@ -198,7 +199,6 @@ CONFIG_SOC_CAMERA_OV2640=y
 CONFIG_IMX_IPUV3_CORE=y
 CONFIG_DRM=y
 CONFIG_DRM_PANEL_SIMPLE=y
-CONFIG_BACKLIGHT_LCD_SUPPORT=y
 CONFIG_LCD_CLASS_DEVICE=y
 CONFIG_LCD_L4F00242T03=y
 CONFIG_LCD_PLATFORM=y
-- 
2.1.3

