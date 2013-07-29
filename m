Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3G2EJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 00:09:21 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53116 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab3G2EJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 00:09:17 -0400
Message-ID: <1375070952.5721.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: pfuze100: Use i2c_[set|get]_clientdata
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 29 Jul 2013 12:09:12 +0800
In-Reply-To: <1375070881.5721.0.camel@phoenix>
References: <1375070881.5721.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since this is a i2c driver, use i2c_[set|get]_clientdata instead of
dev_[set|get]_drvdata.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/pfuze100-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index e2f9dcf..cd136ff 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -360,7 +360,7 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
 	if (!pfuze_chip)
 		return -ENOMEM;
 
-	dev_set_drvdata(&client->dev, pfuze_chip);
+	i2c_set_clientdata(client, pfuze_chip);
 
 	memcpy(pfuze_chip->regulator_descs, pfuze100_regulators,
 		sizeof(pfuze_chip->regulator_descs));
@@ -429,7 +429,7 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
 static int pfuze100_regulator_remove(struct i2c_client *client)
 {
 	int i;
-	struct pfuze_chip *pfuze_chip = dev_get_drvdata(&client->dev);
+	struct pfuze_chip *pfuze_chip = i2c_get_clientdata(client);
 
 	for (i = 0; i < PFUZE100_MAX_REGULATOR; i++)
 		regulator_unregister(pfuze_chip->regulators[i]);
-- 
1.8.1.2



