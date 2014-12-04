Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbaLDQqC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:46:02 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45623 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbaLDQp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:45:58 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v3 1/3] hwmon: tmp401: add support for TI TMP435
Date: Thu,  4 Dec 2014 17:45:51 +0100
Message-Id: <1417711553-21311-2-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417711553-21311-1-git-send-email-bgolaszewski@baylibre.com>
References: <1417711553-21311-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Titiano <ptitiano@baylibre.com>

Signed-off-by: Patrick Titiano <ptitiano@baylibre.com>
[Bartosz Golaszewski: prepared for submission, code review fixes]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/hwmon/tmp401.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
index 7fa6e7d..ccd9938 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -46,7 +46,7 @@
 /* Addresses to scan */
 static const unsigned short normal_i2c[] = { 0x4c, 0x4d, 0x4e, I2C_CLIENT_END };
 
-enum chips { tmp401, tmp411, tmp431, tmp432 };
+enum chips { tmp401, tmp411, tmp431, tmp432, tmp435 };
 
 /*
  * The TMP401 registers, note some registers have different addresses for
@@ -136,6 +136,7 @@ static const u8 TMP432_STATUS_REG[] = {
 #define TMP411C_DEVICE_ID			0x10
 #define TMP431_DEVICE_ID			0x31
 #define TMP432_DEVICE_ID			0x32
+#define TMP435_DEVICE_ID			0x35
 
 /*
  * Driver data (common to all clients)
@@ -146,6 +147,7 @@ static const struct i2c_device_id tmp401_id[] = {
 	{ "tmp411", tmp411 },
 	{ "tmp431", tmp431 },
 	{ "tmp432", tmp432 },
+	{ "tmp435", tmp435 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, tmp401_id);
@@ -684,6 +686,11 @@ static int tmp401_detect(struct i2c_client *client,
 			return -ENODEV;
 		kind = tmp432;
 		break;
+	case TMP435_DEVICE_ID:
+		if (client->addr != 0x4c)
+			return -ENODEV;
+		kind = tmp435;
+		break;
 	default:
 		return -ENODEV;
 	}
@@ -705,7 +712,9 @@ static int tmp401_detect(struct i2c_client *client,
 static int tmp401_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	const char *names[] = { "TMP401", "TMP411", "TMP431", "TMP432" };
+	static const char * const names[] = {
+		"TMP401", "TMP411", "TMP431", "TMP432", "TMP435"
+	};
 	struct device *dev = &client->dev;
 	struct device *hwmon_dev;
 	struct tmp401_data *data;
-- 
2.1.3

