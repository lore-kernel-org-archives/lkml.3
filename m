Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab3BAWf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:35:29 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:45807 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948Ab3BAWfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:35:09 -0500
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org, olofj@chromium.org, olof@lixom.net
Subject: [PATCH 3/4] Platform: x86: chromeos_laptop - Add Taos tsl2563 device
Date: Fri,  1 Feb 2013 14:34:45 -0800
Message-Id: <1359758086-2320-4-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359758086-2320-1-git-send-email-bleung@chromium.org>
References: <1359758086-2320-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two legacy Chromebooks, the Cr-48, and the Acer AC700,
are equipped with a Taos tsl2563 light sensor.
This will instantiate the sensor on those laptops.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/x86/chromeos_laptop.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index 9293c66..188b7da 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -27,6 +27,7 @@
 
 #define CYAPA_TP_I2C_ADDR	0x67
 #define ISL_ALS_I2C_ADDR	0x44
+#define TAOS_ALS_I2C_ADDR	0x29
 
 static struct i2c_client *als;
 static struct i2c_client *tp;
@@ -49,6 +50,10 @@ static struct i2c_board_info __initdata isl_als_device = {
 	I2C_BOARD_INFO("isl29018", ISL_ALS_I2C_ADDR),
 };
 
+static struct i2c_board_info __initdata tsl2563_als_device = {
+	I2C_BOARD_INFO("tsl2563", TAOS_ALS_I2C_ADDR),
+};
+
 static struct i2c_client __init *__add_probed_i2c_device(
 		const char *name,
 		int bus,
@@ -159,6 +164,13 @@ static int __init setup_isl29018_als(const struct dmi_system_id *id)
 	return 0;
 }
 
+static int __init setup_tsl2563_als(const struct dmi_system_id *id)
+{
+	/* add tsl2563 light sensor on smbus */
+	als = add_smbus_device(NULL, &tsl2563_als_device);
+	return 0;
+}
+
 static struct dmi_system_id __initdata chromeos_laptop_dmi_table[] = {
 	{
 		.ident = "Samsung Series 5 550 - Touchpad",
@@ -183,6 +195,20 @@ static struct dmi_system_id __initdata chromeos_laptop_dmi_table[] = {
 		},
 		.callback = setup_cyapa_smbus_tp,
 	},
+	{
+		.ident = "Cr-48 - Light Sensor",
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "Mario"),
+		},
+		.callback = setup_tsl2563_als,
+	},
+	{
+		.ident = "Acer AC700 - Light Sensor",
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZGB"),
+		},
+		.callback = setup_tsl2563_als,
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(dmi, chromeos_laptop_dmi_table);
-- 
1.8.1

