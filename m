Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbaBRKrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:47:03 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55752 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbaBRKqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:46:53 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 04/15] regulator: max8973: Remove redundant error message
Date: Tue, 18 Feb 2014 16:11:00 +0530
Message-Id: <1392720071-13503-4-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8973-regulator.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index 892aa1e5b96c..79f57fef0038 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -379,10 +379,8 @@ static int max8973_probe(struct i2c_client *client,
 	}
 
 	max = devm_kzalloc(&client->dev, sizeof(*max), GFP_KERNEL);
-	if (!max) {
-		dev_err(&client->dev, "Memory allocation for max failed\n");
+	if (!max)
 		return -ENOMEM;
-	}
 
 	max->regmap = devm_regmap_init_i2c(client, &max8973_regmap_config);
 	if (IS_ERR(max->regmap)) {
-- 
1.7.9.5

