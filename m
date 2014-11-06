Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaKFOKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:10:08 -0500
Received: from gw.hale.at ([83.64.51.210]:35662 "EHLO gw.hale.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbaKFOKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:10:03 -0500
X-HALE-Mailborder-Watermark: 1415887197.08979@ovsX5GSCmBK4fKMHMfqQXg
X-HALE-Mailborder-From: michael.thalmeier@hale.at
X-HALE-Mailborder-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.899, required 3, autolearn=not spam, ALL_TRUSTED -1.00,
	BAYES_00 -1.90, URIBL_BLOCKED 0.00)
X-HALE-Mailborder-IP-Protocol: IPv4
X-HALE-Mailborder: Found to be clean
X-HALE-Mailborder-ID: B83682C072B.AE274
X-HALE-Mailborder-Information: Please contact your admin for more information
From: Michael Thalmeier <michael.thalmeier@hale.at>
To: linux@roeck-us.net, jdelvare@suse.de
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: (lm75) Add support for the NXP LM75B
Date: Thu,  6 Nov 2014 14:59:36 +0100
Message-Id: <1415282376-3055-1-git-send-email-michael.thalmeier@hale.at>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is basically a faster lm75 with improved (11 bit) resolution.

Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
---
 Documentation/hwmon/lm75 | 6 ++++++
 drivers/hwmon/lm75.c     | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/hwmon/lm75 b/Documentation/hwmon/lm75
index c6a5ff1..62e216a 100644
--- a/Documentation/hwmon/lm75
+++ b/Documentation/hwmon/lm75
@@ -53,6 +53,12 @@ Supported chips:
                http://www.ti.com/product/tmp75
                http://www.ti.com/product/tmp175
                http://www.ti.com/product/tmp275
+  * NXP LM75B
+    Prefix: 'lm75b'
+    Addresses scanned: none
+    Datasheet: Publicly available at the NXP website
+               http://www.nxp.com/documents/data_sheet/LM75B.pdf
+
 
 Author: Frodo Looijaard <frodol@dds.nl>
 
diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index d16dbb33a..7ec5ccd 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -44,6 +44,7 @@ enum lm75_type {		/* keep sorted in alphabetical order */
 	g751,
 	lm75,
 	lm75a,
+	lm75b,
 	max6625,
 	max6626,
 	mcp980x,
@@ -271,6 +272,10 @@ lm75_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		data->resolution = 12;
 		data->sample_time = HZ / 2;
 		break;
+	case lm75b:
+		data->resolution = 11;
+		data->sample_time = HZ / 4;
+		break;
 	}
 
 	/* configure as specified */
@@ -334,6 +339,7 @@ static const struct i2c_device_id lm75_ids[] = {
 	{ "tmp175", tmp175, },
 	{ "tmp275", tmp275, },
 	{ "tmp75", tmp75, },
+	{ "lm75b", lm75b, },
 	{ /* LIST END */ }
 };
 MODULE_DEVICE_TABLE(i2c, lm75_ids);
-- 
1.9.3

