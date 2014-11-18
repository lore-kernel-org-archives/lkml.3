Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbaKRQIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:08:38 -0500
Received: from gw.hale.at ([83.64.51.210]:55514 "EHLO gw.hale.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072AbaKRQIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:08:36 -0500
X-HALE-Mailborder-Watermark: 1416931701.45247@OX5avk+ov6URGrkZ4Gz5nA
X-HALE-Mailborder-From: michael.thalmeier@hale.at
X-HALE-Mailborder-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.899, required 3, autolearn=not spam, ALL_TRUSTED -1.00,
	BAYES_00 -1.90, URIBL_BLOCKED 0.00)
X-HALE-Mailborder-IP-Protocol: IPv4
X-HALE-Mailborder: Found to be clean
X-HALE-Mailborder-ID: 782C12C0760.AF99B
X-HALE-Mailborder-Information: Please contact your admin for more information
From: Michael Thalmeier <michael.thalmeier@hale.at>
To: linux@roeck-us.net, jdelvare@suse.de
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] hwmon: (lm75) Add support for the NXP LM75B
Date: Tue, 18 Nov 2014 17:08:04 +0100
Message-Id: <1416326884-22623-1-git-send-email-michael.thalmeier@hale.at>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is basically a faster lm75 with improved (11 bit) resolution.

Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
---
v2: keep alphabetic order

 Documentation/hwmon/lm75 | 5 +++++
 drivers/hwmon/lm75.c     | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/hwmon/lm75 b/Documentation/hwmon/lm75
index c6a5ff1..67691a0a 100644
--- a/Documentation/hwmon/lm75
+++ b/Documentation/hwmon/lm75
@@ -53,6 +53,11 @@ Supported chips:
                http://www.ti.com/product/tmp75
                http://www.ti.com/product/tmp175
                http://www.ti.com/product/tmp275
+  * NXP LM75B
+    Prefix: 'lm75b'
+    Addresses scanned: none
+    Datasheet: Publicly available at the NXP website
+               http://www.nxp.com/documents/data_sheet/LM75B.pdf
 
 Author: Frodo Looijaard <frodol@dds.nl>
 
diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index d16dbb33a..f58439b 100644
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
@@ -233,6 +234,10 @@ lm75_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		data->resolution = 9;
 		data->sample_time = HZ / 2;
 		break;
+	case lm75b:
+		data->resolution = 11;
+		data->sample_time = HZ / 4;
+		break;
 	case max6625:
 		data->resolution = 9;
 		data->sample_time = HZ / 4;
@@ -322,6 +327,7 @@ static const struct i2c_device_id lm75_ids[] = {
 	{ "g751", g751, },
 	{ "lm75", lm75, },
 	{ "lm75a", lm75a, },
+	{ "lm75b", lm75b, },
 	{ "max6625", max6625, },
 	{ "max6626", max6626, },
 	{ "mcp980x", mcp980x, },
-- 
1.9.3

