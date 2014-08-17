Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaHQKe6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 06:34:58 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34565 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaHQKe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 06:34:57 -0400
Message-ID: <1408271688.16342.1.camel@phoenix>
Subject: [PATCH] regulator: da9211: Check return value of devm_kzalloc()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: James Ban <james.ban.opensource@diasemi.com>,
        Support Opensource <support.opensource@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 17 Aug 2014 18:34:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/da9211-regulator.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index ccc2e36..a26f1d2 100644
--- a/drivers/regulator/da9211-regulator.c
+++ b/drivers/regulator/da9211-regulator.c
@@ -343,6 +343,8 @@ static int da9211_i2c_probe(struct i2c_client *i2c,
 	unsigned int data;
 
 	chip = devm_kzalloc(&i2c->dev, sizeof(struct da9211), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
 
 	chip->dev = &i2c->dev;
 	chip->regmap = devm_regmap_init_i2c(i2c, &da9211_regmap_config);
-- 
1.9.1



