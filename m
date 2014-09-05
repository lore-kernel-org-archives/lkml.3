Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbaIEBNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 21:13:05 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53720 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaIEBNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 21:13:04 -0400
Message-ID: <1409879575.5208.1.camel@phoenix>
Subject: [PATCH] regulator: da9211: Set of_match_table and export device
 table
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: James Ban <james.ban.opensource@diasemi.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 05 Sep 2014 09:12:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also move da9211_i2c_id and da9211_dt_ids close to the user for better
readability.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da9211-regulator.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index 044c36c..f47adf3 100644
--- a/drivers/regulator/da9211-regulator.c
+++ b/drivers/regulator/da9211-regulator.c
@@ -388,20 +388,6 @@ static int da9211_regulator_init(struct da9211 *chip)
 	return 0;
 }
 
-static const struct i2c_device_id da9211_i2c_id[] = {
-	{"da9211", DA9211},
-	{"da9213", DA9213},
-	{},
-};
-
-#ifdef CONFIG_OF
-static const struct of_device_id da9211_dt_ids[] = {
-	{ .compatible = "dlg,da9211", .data = &da9211_i2c_id[0] },
-	{ .compatible = "dlg,da9213", .data = &da9211_i2c_id[1] },
-	{},
-};
-#endif
-
 /*
  * I2C driver interface functions
  */
@@ -479,12 +465,27 @@ static int da9211_i2c_probe(struct i2c_client *i2c,
 	return ret;
 }
 
+static const struct i2c_device_id da9211_i2c_id[] = {
+	{"da9211", DA9211},
+	{"da9213", DA9213},
+	{},
+};
 MODULE_DEVICE_TABLE(i2c, da9211_i2c_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id da9211_dt_ids[] = {
+	{ .compatible = "dlg,da9211", .data = &da9211_i2c_id[0] },
+	{ .compatible = "dlg,da9213", .data = &da9211_i2c_id[1] },
+	{},
+};
+MODULE_DEVICE_TABLE(of, da9211_dt_ids);
+#endif
+
 static struct i2c_driver da9211_regulator_driver = {
 	.driver = {
 		.name = "da9211",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(da9211_dt_ids),
 	},
 	.probe = da9211_i2c_probe,
 	.id_table = da9211_i2c_id,
-- 
1.9.1



