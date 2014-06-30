Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaF3HcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 03:32:15 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54597 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaF3HcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 03:32:14 -0400
Message-ID: <1404113529.21614.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: act8865: Remove error variable in
 act8865_pmic_probe
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Beniamino Galvani <b.galvani@gmail.com>,
        "Wenyou.Yang" <wenyou.yang@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 30 Jun 2014 15:32:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply use ret variable instead.
Also remove unneeded initialize for ret variable.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/act8865-regulator.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index fe2c038..f07be36 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -278,8 +278,7 @@ static int act8865_pmic_probe(struct i2c_client *client,
 	struct act8865 *act8865;
 	struct device_node *of_node[ACT8865_REG_NUM];
 	int i;
-	int ret = -EINVAL;
-	int error;
+	int ret;
 
 	if (dev->of_node && !pdata) {
 		const struct of_device_id *id;
@@ -307,10 +306,10 @@ static int act8865_pmic_probe(struct i2c_client *client,
 
 	act8865->regmap = devm_regmap_init_i2c(client, &act8865_regmap_config);
 	if (IS_ERR(act8865->regmap)) {
-		error = PTR_ERR(act8865->regmap);
+		ret = PTR_ERR(act8865->regmap);
 		dev_err(&client->dev, "Failed to allocate register map: %d\n",
-			error);
-		return error;
+			ret);
+		return ret;
 	}
 
 	/* Finally register devices */
-- 
1.9.1



