Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3CFHmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:42:13 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:59551 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab3CFHmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:42:08 -0500
From: Benson Leung <bleung@chromium.org>
To: olofj@chromium.org, miletus@chromium.org, dmitry.torokhov@gmail.com,
        matthew.garrett@nebula.com, rydberg@euromail.se, djkurtz@chromium.org,
        jy0922.shim@samsung.com, wfp5p@virginia.edu,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Cc: bleung@chromium.org
Subject: [PATCH v2 2/2] Platform: x86: chromeos_laptop : Add basic platform data for atmel devices
Date: Tue,  5 Mar 2013 23:41:47 -0800
Message-Id: <1362555707-24654-3-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362555707-24654-1-git-send-email-bleung@chromium.org>
References: <1362187254-9227-1-git-send-email-bleung@chromium.org>
 <1362555707-24654-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic platform data to get the current upstream driver working
with the 224s touchpad and 1664s touchscreen.
We will be using NULL config so we will use the settings from the
devices' NVRAMs.

Signed-off-by: Benson Leung <bleung@chromium.org>
Tested-by: Olof Johansson <olof@lixom.net>
---
v2: Patches cleanly with v3.9-rc1
v1: Initial
---
 drivers/platform/x86/chromeos_laptop.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index 93d6680..c10ff84 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -23,6 +23,8 @@
 
 #include <linux/dmi.h>
 #include <linux/i2c.h>
+#include <linux/i2c/atmel_mxt_ts.h>
+#include <linux/interrupt.h>
 #include <linux/module.h>
 
 #define ATMEL_TP_I2C_ADDR	0x4b
@@ -67,15 +69,43 @@ static struct i2c_board_info __initdata tsl2563_als_device = {
 	I2C_BOARD_INFO("tsl2563", TAOS_ALS_I2C_ADDR),
 };
 
+static struct mxt_platform_data atmel_224s_tp_platform_data = {
+	.x_line			= 18,
+	.y_line			= 12,
+	.x_size			= 102*20,
+	.y_size			= 68*20,
+	.blen			= 0x80,	/* Gain setting is in upper 4 bits */
+	.threshold		= 0x32,
+	.voltage		= 0,	/* 3.3V */
+	.orient			= MXT_VERTICAL_FLIP,
+	.irqflags		= IRQF_TRIGGER_FALLING,
+	.config			= NULL,
+	.config_length		= 0,
+};
+
 static struct i2c_board_info __initdata atmel_224s_tp_device = {
 	I2C_BOARD_INFO("atmel_mxt_tp", ATMEL_TP_I2C_ADDR),
-	.platform_data = NULL,
+	.platform_data = &atmel_224s_tp_platform_data,
 	.flags		= I2C_CLIENT_WAKE,
 };
 
+static struct mxt_platform_data atmel_1664s_platform_data = {
+	.x_line			= 32,
+	.y_line			= 50,
+	.x_size			= 1700,
+	.y_size			= 2560,
+	.blen			= 0x89,	/* Gain setting is in upper 4 bits */
+	.threshold		= 0x28,
+	.voltage		= 0,	/* 3.3V */
+	.orient			= MXT_ROTATED_90_COUNTER,
+	.irqflags		= IRQF_TRIGGER_FALLING,
+	.config			= NULL,
+	.config_length		= 0,
+};
+
 static struct i2c_board_info __initdata atmel_1664s_device = {
 	I2C_BOARD_INFO("atmel_mxt_ts", ATMEL_TS_I2C_ADDR),
-	.platform_data = NULL,
+	.platform_data = &atmel_1664s_platform_data,
 	.flags		= I2C_CLIENT_WAKE,
 };
 
-- 
1.8.1.3

