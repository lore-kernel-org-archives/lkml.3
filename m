Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbaIRNto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:49:44 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48661 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbaIRNtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:49:43 -0400
Message-ID: <1411048178.18649.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: fan53555: Fix null pointer dereference
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 18 Sep 2014 21:49:38 +0800
In-Reply-To: <1411048128.18649.1.camel@phoenix>
References: <1411048128.18649.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set di->regulator before dereference it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/fan53555.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index 70b31bf..c82fb9e 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -361,6 +361,7 @@ static int fan53555_regulator_probe(struct i2c_client *client,
 	if (!di)
 		return -ENOMEM;
 
+	di->regulator = pdata->regulator;
 	if (client->dev.of_node) {
 		const struct of_device_id *match;
 
@@ -389,7 +390,6 @@ static int fan53555_regulator_probe(struct i2c_client *client,
 		return PTR_ERR(di->regmap);
 	}
 	di->dev = &client->dev;
-	di->regulator = pdata->regulator;
 	i2c_set_clientdata(client, di);
 	/* Get chip ID */
 	ret = regmap_read(di->regmap, FAN53555_ID1, &val);
-- 
1.9.1



