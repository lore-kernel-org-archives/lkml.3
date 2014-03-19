Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965101AbaCSNFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:05:44 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42177 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933950AbaCSNEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:04:10 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-leds@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 13/16] avr32: update defconfig to use the generic PWM framework
Date: Wed, 19 Mar 2014 14:03:26 +0100
Message-Id: <1395234209-15546-14-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all boards have switch to the generic PWM framework, update the
defconfigs to use it.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/avr32/configs/atngw100_mrmt_defconfig | 5 +++--
 arch/avr32/configs/atstk1002_defconfig     | 5 +++--
 arch/avr32/configs/atstk1003_defconfig     | 5 +++--
 arch/avr32/configs/atstk1004_defconfig     | 5 +++--
 arch/avr32/configs/atstk1006_defconfig     | 5 +++--
 arch/avr32/configs/merisc_defconfig        | 5 +++--
 6 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/avr32/configs/atngw100_mrmt_defconfig b/arch/avr32/configs/atngw100_mrmt_defconfig
index 9a57da44eb6f..6838781e966f 100644
--- a/arch/avr32/configs/atngw100_mrmt_defconfig
+++ b/arch/avr32/configs/atngw100_mrmt_defconfig
@@ -56,7 +56,6 @@ CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_DATAFLASH=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_ATMEL_PWM=y
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_MACB=y
@@ -104,8 +103,8 @@ CONFIG_MMC=y
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
-CONFIG_LEDS_ATMEL_PWM=y
 CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_PWM=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
@@ -114,6 +113,8 @@ CONFIG_RTC_DRV_S35390A=m
 CONFIG_RTC_DRV_AT32AP700X=m
 CONFIG_DMADEVICES=y
 CONFIG_UIO=y
+CONFIG_PWM=y
+CONFIG_PWM_ATMEL=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
 CONFIG_EXT3_FS=y
diff --git a/arch/avr32/configs/atstk1002_defconfig b/arch/avr32/configs/atstk1002_defconfig
index 2813dd2b9138..b056820eef33 100644
--- a/arch/avr32/configs/atstk1002_defconfig
+++ b/arch/avr32/configs/atstk1002_defconfig
@@ -64,7 +64,6 @@ CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
 CONFIG_MISC_DEVICES=y
-CONFIG_ATMEL_PWM=m
 CONFIG_ATMEL_TCLIB=y
 CONFIG_ATMEL_SSC=m
 # CONFIG_SCSI_PROC_FS is not set
@@ -133,14 +132,16 @@ CONFIG_MMC_TEST=m
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
-CONFIG_LEDS_ATMEL_PWM=m
 CONFIG_LEDS_GPIO=m
+CONFIG_LEDS_PWM=m
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=m
 CONFIG_LEDS_TRIGGER_HEARTBEAT=m
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_AT32AP700X=y
 CONFIG_DMADEVICES=y
+CONFIG_PWM=y
+CONFIG_PWM_ATMEL=m
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
diff --git a/arch/avr32/configs/atstk1003_defconfig b/arch/avr32/configs/atstk1003_defconfig
index f8ff3a3baad4..0cd23a303da1 100644
--- a/arch/avr32/configs/atstk1003_defconfig
+++ b/arch/avr32/configs/atstk1003_defconfig
@@ -53,7 +53,6 @@ CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
 CONFIG_MISC_DEVICES=y
-CONFIG_ATMEL_PWM=m
 CONFIG_ATMEL_TCLIB=y
 CONFIG_ATMEL_SSC=m
 # CONFIG_SCSI_PROC_FS is not set
@@ -112,14 +111,16 @@ CONFIG_MMC_TEST=m
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
-CONFIG_LEDS_ATMEL_PWM=m
 CONFIG_LEDS_GPIO=m
+CONFIG_LEDS_PWM=m
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=m
 CONFIG_LEDS_TRIGGER_HEARTBEAT=m
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_AT32AP700X=y
 CONFIG_DMADEVICES=y
+CONFIG_PWM=y
+CONFIG_PWM_ATMEL=m
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
diff --git a/arch/avr32/configs/atstk1004_defconfig b/arch/avr32/configs/atstk1004_defconfig
index 992228e54e38..ac1041f5f85a 100644
--- a/arch/avr32/configs/atstk1004_defconfig
+++ b/arch/avr32/configs/atstk1004_defconfig
@@ -53,7 +53,6 @@ CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
 CONFIG_MISC_DEVICES=y
-CONFIG_ATMEL_PWM=m
 CONFIG_ATMEL_TCLIB=y
 CONFIG_ATMEL_SSC=m
 # CONFIG_SCSI_PROC_FS is not set
@@ -111,14 +110,16 @@ CONFIG_MMC_TEST=m
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
-CONFIG_LEDS_ATMEL_PWM=m
 CONFIG_LEDS_GPIO=m
+CONFIG_LEDS_PWM=m
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=m
 CONFIG_LEDS_TRIGGER_HEARTBEAT=m
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_AT32AP700X=y
 CONFIG_DMADEVICES=y
+CONFIG_PWM=y
+CONFIG_PWM_ATMEL=m
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
diff --git a/arch/avr32/configs/atstk1006_defconfig b/arch/avr32/configs/atstk1006_defconfig
index b8e698b0d1fa..ea4f670cb995 100644
--- a/arch/avr32/configs/atstk1006_defconfig
+++ b/arch/avr32/configs/atstk1006_defconfig
@@ -67,7 +67,6 @@ CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=m
 CONFIG_MISC_DEVICES=y
-CONFIG_ATMEL_PWM=m
 CONFIG_ATMEL_TCLIB=y
 CONFIG_ATMEL_SSC=m
 # CONFIG_SCSI_PROC_FS is not set
@@ -136,14 +135,16 @@ CONFIG_MMC_TEST=m
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
-CONFIG_LEDS_ATMEL_PWM=m
 CONFIG_LEDS_GPIO=m
+CONFIG_LEDS_PWM=m
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_TIMER=m
 CONFIG_LEDS_TRIGGER_HEARTBEAT=m
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_AT32AP700X=y
 CONFIG_DMADEVICES=y
+CONFIG_PWM=y
+CONFIG_PWM_ATMEL=m
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
diff --git a/arch/avr32/configs/merisc_defconfig b/arch/avr32/configs/merisc_defconfig
index 91df6b2986be..b9ef4cc85d08 100644
--- a/arch/avr32/configs/merisc_defconfig
+++ b/arch/avr32/configs/merisc_defconfig
@@ -55,7 +55,6 @@ CONFIG_MTD_ABSENT=y
 CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_BLOCK2MTD=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_ATMEL_PWM=y
 CONFIG_ATMEL_SSC=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
@@ -103,12 +102,14 @@ CONFIG_MMC=y
 CONFIG_MMC_ATMELMCI=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
-CONFIG_LEDS_ATMEL_PWM=y
+CONFIG_LEDS_PWM=y
 CONFIG_RTC_CLASS=y
 # CONFIG_RTC_HCTOSYS is not set
 CONFIG_RTC_DRV_PCF8563=y
 CONFIG_DMADEVICES=y
 CONFIG_UIO=y
+CONFIG_PWM=y
+CONFIG_PWM_ATMEL=m
 CONFIG_EXT2_FS=y
 # CONFIG_DNOTIFY is not set
 CONFIG_FUSE_FS=y
-- 
1.8.3.2

