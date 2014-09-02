Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaIBIu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:50:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36154 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751503AbaIBIuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:50:22 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 5/7] ARM: at91: at91sam9g45: update defconfig
Date: Tue,  2 Sep 2014 10:50:01 +0200
Message-Id: <1409647803-8054-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409647803-8054-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1409647803-8054-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update defconfig, adding:
 - PWM support using the generic framework
 - generic PWM leds
 - Power/reset
 - Watchdog

and removing deprecated config options.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/configs/at91sam9g45_defconfig | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm/configs/at91sam9g45_defconfig b/arch/arm/configs/at91sam9g45_defconfig
index c6661a60025d..f66d1a1b64bf 100644
--- a/arch/arm/configs/at91sam9g45_defconfig
+++ b/arch/arm/configs/at91sam9g45_defconfig
@@ -20,7 +20,6 @@ CONFIG_MACH_AT91SAM9M10G45EK=y
 CONFIG_MACH_AT91SAM9_DT=y
 CONFIG_AT91_SLOW_CLOCK=y
 CONFIG_AEABI=y
-# CONFIG_OABI_COMPAT is not set
 CONFIG_UACCESS_WITH_MEMCPY=y
 CONFIG_ZBOOT_ROM_TEXT=0x0
 CONFIG_ZBOOT_ROM_BSS=0x0
@@ -51,7 +50,6 @@ CONFIG_DEVTMPFS_MOUNT=y
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_MTD=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_DATAFLASH=y
 CONFIG_MTD_NAND=y
@@ -62,15 +60,12 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=4
 CONFIG_BLK_DEV_RAM_SIZE=8192
-CONFIG_ATMEL_PWM=y
 CONFIG_ATMEL_TCLIB=y
 CONFIG_ATMEL_SSC=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
-CONFIG_SCSI_MULTI_LUN=y
 # CONFIG_SCSI_LOWLEVEL is not set
 CONFIG_NETDEVICES=y
-CONFIG_MII=y
 CONFIG_MACB=y
 CONFIG_DAVICOM_PHY=y
 # CONFIG_INPUT_MOUSEDEV is not set
@@ -93,18 +88,22 @@ CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_GPIO=y
 CONFIG_SPI=y
 CONFIG_SPI_ATMEL=y
+CONFIG_POWER_SUPPLY=y
+CONFIG_POWER_RESET=y
 # CONFIG_HWMON is not set
+CONFIG_WATCHDOG=y
+CONFIG_WATCHDOG_NOWAYOUT=y
+CONFIG_AT91SAM9X_WATCHDOG=y
 CONFIG_FB=y
 CONFIG_FB_ATMEL=y
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
 CONFIG_LCD_CLASS_DEVICE=y
 CONFIG_BACKLIGHT_CLASS_DEVICE=y
 CONFIG_BACKLIGHT_ATMEL_LCDC=y
-CONFIG_BACKLIGHT_ATMEL_PWM=y
 # CONFIG_BACKLIGHT_GENERIC is not set
+CONFIG_BACKLIGHT_PWM=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
-CONFIG_FONTS=y
 CONFIG_LOGO=y
 CONFIG_SOUND=y
 CONFIG_SND=y
@@ -135,6 +134,7 @@ CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_PWM=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
@@ -147,6 +147,8 @@ CONFIG_DMATEST=m
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_IIO=y
 CONFIG_AT91_ADC=y
+CONFIG_PWM=y
+CONFIG_PWM_ATMEL=y
 CONFIG_EXT4_FS=y
 CONFIG_FANOTIFY=y
 CONFIG_VFAT_FS=y
@@ -159,8 +161,8 @@ CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_850=y
 CONFIG_NLS_ISO8859_1=y
 CONFIG_STRIP_ASM_SYMS=y
-# CONFIG_SCHED_DEBUG is not set
 CONFIG_DEBUG_MEMORY_INIT=y
+# CONFIG_SCHED_DEBUG is not set
 # CONFIG_FTRACE is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
@@ -170,3 +172,4 @@ CONFIG_CRYPTO_ECB=y
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 # CONFIG_CRYPTO_HW is not set
+CONFIG_FONTS=y
-- 
1.9.1

