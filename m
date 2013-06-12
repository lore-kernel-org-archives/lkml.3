Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3FLIkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:40:17 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38837 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3FLIkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:40:15 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org
Subject: [PATCH 1/1] mfd: 88pm860x: Use devm_regmap_init_i2c()
Date: Wed, 12 Jun 2013 13:55:43 +0530
Message-Id: <1371025543-4485-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_regmap_init_i2c() is device managed and makes cleanup simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/88pm860x-core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index ef6d82c..eeb481d 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -1156,7 +1156,7 @@ static int pm860x_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	chip->id = verify_addr(client);
-	chip->regmap = regmap_init_i2c(client, &pm860x_regmap_config);
+	chip->regmap = devm_regmap_init_i2c(client, &pm860x_regmap_config);
 	if (IS_ERR(chip->regmap)) {
 		ret = PTR_ERR(chip->regmap);
 		dev_err(&client->dev, "Failed to allocate register map: %d\n",
@@ -1203,7 +1203,6 @@ static int pm860x_remove(struct i2c_client *client)
 		regmap_exit(chip->regmap_companion);
 		i2c_unregister_device(chip->companion);
 	}
-	regmap_exit(chip->regmap);
 	return 0;
 }
 
-- 
1.7.9.5

