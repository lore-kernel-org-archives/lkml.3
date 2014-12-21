Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaLUT5B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 14:57:01 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:42007 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaLUTzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 14:55:32 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] i8k: Add support for Dell XPS 13
Date: Sun, 21 Dec 2014 20:54:39 +0100
Message-Id: <1419191683-31435-7-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419191683-31435-1-git-send-email-pali.rohar@gmail.com>
References: <1419191683-31435-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

XPS 13 does not support turbo speed, so its initialization data
matches that of XPS M140. Make XPS initialization data generic,
and add support for XPS 13.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
---
 drivers/char/i8k.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 0e332fc..8ec4c37 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -705,7 +705,7 @@ enum i8k_configs {
 	DELL_LATITUDE_E6540,
 	DELL_PRECISION_490,
 	DELL_STUDIO,
-	DELL_XPS_M140,
+	DELL_XPS,
 };
 
 static const struct i8k_config_data i8k_config_data[] = {
@@ -725,7 +725,7 @@ static const struct i8k_config_data i8k_config_data[] = {
 		.fan_mult = 1,
 		.fan_max = I8K_FAN_HIGH,
 	},
-	[DELL_XPS_M140] = {
+	[DELL_XPS] = {
 		.fan_mult = 1,
 		.fan_max = I8K_FAN_HIGH,
 	},
@@ -837,12 +837,20 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
 		.driver_data = (void *)&i8k_config_data[DELL_STUDIO],
 	},
 	{
+		.ident = "Dell XPS 13",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XPS13"),
+		},
+		.driver_data = (void *)&i8k_config_data[DELL_XPS],
+	},
+	{
 		.ident = "Dell XPS M140",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "MXC051"),
 		},
-		.driver_data = (void *)&i8k_config_data[DELL_XPS_M140],
+		.driver_data = (void *)&i8k_config_data[DELL_XPS],
 	},
 	{ }
 };
-- 
1.7.9.5

