Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbaBTJJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:09:11 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:39041 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbaBTI7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:04 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org,
        Yunfan Zhang <yfzhang@marvell.com>
Subject: [PATCH 04/23] regulator: fan53555: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:04 +0530
Message-Id: <1392886403-10640-4-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Yunfan Zhang <yfzhang@marvell.com>
---
 drivers/regulator/fan53555.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index a10df7d150cc..714fd9a89aa1 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -244,10 +244,9 @@ static int fan53555_regulator_probe(struct i2c_client *client,
 
 	di = devm_kzalloc(&client->dev, sizeof(struct fan53555_device_info),
 					GFP_KERNEL);
-	if (!di) {
-		dev_err(&client->dev, "Failed to allocate device info data!\n");
+	if (!di)
 		return -ENOMEM;
-	}
+
 	di->regmap = devm_regmap_init_i2c(client, &fan53555_regmap_config);
 	if (IS_ERR(di->regmap)) {
 		dev_err(&client->dev, "Failed to allocate regmap!\n");
-- 
1.7.9.5

