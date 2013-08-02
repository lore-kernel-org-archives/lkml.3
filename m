Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab3HBITd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:19:33 -0400
Received: from svenfoo.org ([82.94.215.22]:44934 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab3HBIT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:19:29 -0400
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: lgirdwood@gmail.com, broonie@kernel.org, Daniel Mack <zonque@gmail.com>
Subject: [PATCH 2/3] regulators: max8660: add a shorthand to &client->dev
Date: Fri,  2 Aug 2013 10:19:16 +0200
Message-Id: <1375431557-3096-2-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375431557-3096-1-git-send-email-zonque@gmail.com>
References: <1375431557-3096-1-git-send-email-zonque@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change, just makes the code shorter.

Signed-off-by: Daniel Mack <zonque@gmail.com>
---
 drivers/regulator/max8660.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index ba3b8af..a5caaa0 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -314,6 +314,7 @@ static int max8660_probe(struct i2c_client *client,
 				   const struct i2c_device_id *i2c_id)
 {
 	struct regulator_dev **rdev;
+	struct device *dev = &client->dev;
 	struct max8660_platform_data *pdata = client->dev.platform_data;
 	struct regulator_config config = { };
 	struct max8660 *max8660;
@@ -321,11 +322,11 @@ static int max8660_probe(struct i2c_client *client,
 	unsigned int type;
 
 	if (pdata->num_subdevs > MAX8660_V_END) {
-		dev_err(&client->dev, "Too many regulators found!\n");
+		dev_err(dev, "Too many regulators found!\n");
 		return -EINVAL;
 	}
 
-	max8660 = devm_kzalloc(&client->dev, sizeof(struct max8660) +
+	max8660 = devm_kzalloc(dev, sizeof(struct max8660) +
 			sizeof(struct regulator_dev *) * MAX8660_V_END,
 			GFP_KERNEL);
 	if (!max8660)
@@ -384,7 +385,7 @@ static int max8660_probe(struct i2c_client *client,
 
 		case MAX8660_V7:
 			if (type == MAX8661) {
-				dev_err(&client->dev, "Regulator not on this chip!\n");
+				dev_err(dev, "Regulator not on this chip!\n");
 				goto err_out;
 			}
 
@@ -393,7 +394,7 @@ static int max8660_probe(struct i2c_client *client,
 			break;
 
 		default:
-			dev_err(&client->dev, "invalid regulator %s\n",
+			dev_err(dev, "invalid regulator %s\n",
 				 pdata->subdevs[i].name);
 			goto err_out;
 		}
@@ -404,14 +405,14 @@ static int max8660_probe(struct i2c_client *client,
 
 		id = pdata->subdevs[i].id;
 
-		config.dev = &client->dev;
+		config.dev = dev;
 		config.init_data = pdata->subdevs[i].platform_data;
 		config.driver_data = max8660;
 
 		rdev[i] = regulator_register(&max8660_reg[id], &config);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
-			dev_err(&client->dev, "failed to register %s\n",
+			dev_err(dev, "failed to register %s\n",
 				max8660_reg[id].name);
 			goto err_unregister;
 		}
-- 
1.8.3.1

