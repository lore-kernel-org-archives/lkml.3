Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab3ICG2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:28:04 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50857 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3ICG2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:28:02 -0400
Message-ID: <1378189676.4621.15.camel@phoenix>
Subject: [PATCH 8/8] regulator: fan53555: Convert to devm_regulator_register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yunfan Zhang <yfzhang@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 03 Sep 2013 14:27:56 +0800
In-Reply-To: <1378189056.4621.1.camel@phoenix>
References: <1378189056.4621.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/fan53555.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index f0e1ae5..3ce9663 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -218,7 +218,7 @@ static int fan53555_regulator_register(struct fan53555_device_info *di,
 	rdesc->vsel_mask = VSEL_NSEL_MASK;
 	rdesc->owner = THIS_MODULE;
 
-	di->rdev = regulator_register(&di->desc, config);
+	di->rdev = devm_regulator_register(di->dev, &di->desc, config);
 	return PTR_RET(di->rdev);
 
 }
@@ -291,14 +291,6 @@ static int fan53555_regulator_probe(struct i2c_client *client,
 
 }
 
-static int fan53555_regulator_remove(struct i2c_client *client)
-{
-	struct fan53555_device_info *di = i2c_get_clientdata(client);
-
-	regulator_unregister(di->rdev);
-	return 0;
-}
-
 static const struct i2c_device_id fan53555_id[] = {
 	{"fan53555", -1},
 	{ },
@@ -309,7 +301,6 @@ static struct i2c_driver fan53555_regulator_driver = {
 		.name = "fan53555-regulator",
 	},
 	.probe = fan53555_regulator_probe,
-	.remove = fan53555_regulator_remove,
 	.id_table = fan53555_id,
 };
 
-- 
1.8.1.2



