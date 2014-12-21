Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaLUT4F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 14:56:05 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46694 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbaLUTzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 14:55:37 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 09/10] i8k: Remove DMI config data for Latitude E6440 and E6540
Date: Sun, 21 Dec 2014 20:54:42 +0100
Message-Id: <1419191683-31435-10-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419191683-31435-1-git-send-email-pali.rohar@gmail.com>
References: <1419191683-31435-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both Dell Latitude machines were tested with new fan autodetection code and they
are working fine. We already have DMI_MATCH data for generic Latitude machines
which match also E6440 and E6540 models. So we do not need to maintain DMI data
for those specific machines anymore.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Steven Honeyman <stevenhoneyman@gmail.com>
---
 drivers/char/i8k.c |   21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 4c66788..9288edb 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -716,7 +716,6 @@ struct i8k_config_data {
 
 enum i8k_configs {
 	DELL_LATITUDE_D520,
-	DELL_LATITUDE_E6540,
 	DELL_PRECISION_490,
 	DELL_STUDIO,
 	DELL_XPS,
@@ -727,10 +726,6 @@ static const struct i8k_config_data i8k_config_data[] = {
 		.fan_mult = 1,
 		.fan_max = I8K_FAN_TURBO,
 	},
-	[DELL_LATITUDE_E6540] = {
-		.fan_mult = 1,
-		.fan_max = I8K_FAN_HIGH,
-	},
 	[DELL_PRECISION_490] = {
 		.fan_mult = 1,
 		.fan_max = I8K_FAN_TURBO,
@@ -776,22 +771,6 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
 		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_D520],
 	},
 	{
-		.ident = "Dell Latitude E6440",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6440"),
-		},
-		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_E6540],
-	},
-	{
-		.ident = "Dell Latitude E6540",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6540"),
-		},
-		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_E6540],
-	},
-	{
 		.ident = "Dell Latitude 2",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-- 
1.7.9.5

