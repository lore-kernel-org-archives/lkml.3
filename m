Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaLSSGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 13:06:16 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54288 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaLSSGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 13:06:14 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 2/2] i8k: Remove DMI config data for Latitude E6x40
Date: Fri, 19 Dec 2014 19:04:28 +0100
Message-Id: <1419012268-20805-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both Dell Latitude machines were tested with new autodetection code and it is
working fine. So we do not need to maintain config data for them anymore.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-By: Pali Rohár <pali.rohar@gmail.com>
Tested-By: Steven Honeyman <stevenhoneyman@gmail.com>
---
 drivers/char/i8k.c |   21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 094a6b8..9075bbf 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -727,7 +727,6 @@ struct i8k_config_data {
 
 enum i8k_configs {
 	DELL_LATITUDE_D520,
-	DELL_LATITUDE_E6540,
 	DELL_PRECISION_490,
 	DELL_STUDIO,
 	DELL_XPS_M140,
@@ -738,10 +737,6 @@ static const struct i8k_config_data i8k_config_data[] = {
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
@@ -787,22 +782,6 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
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

