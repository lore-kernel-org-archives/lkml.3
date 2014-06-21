Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934339AbaFUPJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 11:09:26 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39632 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332AbaFUPJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 11:09:22 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5/5] i8k: Add support for Dell Precision 490 and Latitude D520
Date: Sat, 21 Jun 2014 08:08:12 -0700
Message-Id: <1403363304-22358-5-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403363304-22358-1-git-send-email-linux@roeck-us.net>
References: <1403363304-22358-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both systems need non-standard parameters for fan multiplier
and maximum fan speed.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/char/i8k.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 0b69da0..65525c7 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -650,11 +650,21 @@ struct i8k_config_data {
 };
 
 enum i8k_configs {
+	DELL_LATITUDE_D520,
+	DELL_PRECISION_490,
 	DELL_STUDIO,
 	DELL_XPS_M140,
 };
 
 static const struct i8k_config_data i8k_config_data[] = {
+	[DELL_LATITUDE_D520] = {
+		.fan_mult = 1,
+		.fan_max = I8K_FAN_TURBO,
+	},
+	[DELL_PRECISION_490] = {
+		.fan_mult = 1,
+		.fan_max = I8K_FAN_TURBO,
+	},
 	[DELL_STUDIO] = {
 		.fan_mult = 1,
 		.fan_max = I8K_FAN_HIGH,
@@ -688,6 +698,14 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
 		},
 	},
 	{
+		.ident = "Dell Latitude D520",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude D520"),
+		},
+		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_D520],
+	},
+	{
 		.ident = "Dell Latitude 2",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
@@ -709,6 +727,15 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
 		},
 	},
 	{
+		.ident = "Dell Precision 490",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME,
+				  "Precision WorkStation 490"),
+		},
+		.driver_data = (void *)&i8k_config_data[DELL_PRECISION_490],
+	},
+	{
 		.ident = "Dell Precision",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-- 
1.9.1

