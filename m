Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaIERDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:03:46 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:54209 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIERDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:03:45 -0400
From: Steven Honeyman <stevenhoneyman@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] i8k: Add support for Dell Latitude E6540
Date: Fri,  5 Sep 2014 18:03:42 +0100
Message-Id: <1409936622-5241-1-git-send-email-stevenhoneyman@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Dell Latitude E6540 which needs a different fan speed multiplier.

Signed-off-by: Steven Honeyman <stevenhoneyman@gmail.com>
---
 drivers/char/i8k.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 65525c7..34174d0 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -651,6 +651,7 @@ struct i8k_config_data {
 
 enum i8k_configs {
 	DELL_LATITUDE_D520,
+	DELL_LATITUDE_E6540,
 	DELL_PRECISION_490,
 	DELL_STUDIO,
 	DELL_XPS_M140,
@@ -661,6 +662,10 @@ static const struct i8k_config_data i8k_config_data[] = {
 		.fan_mult = 1,
 		.fan_max = I8K_FAN_TURBO,
 	},
+	[DELL_LATITUDE_E6540] = {
+		.fan_mult = 1,
+		.fan_max = I8K_FAN_HIGH,
+	},
 	[DELL_PRECISION_490] = {
 		.fan_mult = 1,
 		.fan_max = I8K_FAN_TURBO,
@@ -706,6 +711,14 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
 		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_D520],
 	},
 	{
+		.ident = "Dell Latitude E6540",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6540"),
+		},
+		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_E6540],
+	},
+	{
 		.ident = "Dell Latitude 2",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-- 
2.1.0

