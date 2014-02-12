Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaBLJPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:15:31 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45644 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaBLJP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:15:27 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 1/4] mfd: wm8400-core: Remove unnecessary goto
Date: Wed, 12 Feb 2014 14:40:10 +0530
Message-Id: <1392196213-20576-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return directly to avoid redundant lines of code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/wm8400-core.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index d66d256551fb..8788fd1f0a83 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -161,31 +161,19 @@ static int wm8400_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct wm8400 *wm8400;
-	int ret;
 
 	wm8400 = devm_kzalloc(&i2c->dev, sizeof(struct wm8400), GFP_KERNEL);
-	if (wm8400 == NULL) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	if (wm8400 == NULL)
+		return -ENOMEM;
 
 	wm8400->regmap = devm_regmap_init_i2c(i2c, &wm8400_regmap_config);
-	if (IS_ERR(wm8400->regmap)) {
-		ret = PTR_ERR(wm8400->regmap);
-		goto err;
-	}
+	if (IS_ERR(wm8400->regmap))
+		return PTR_ERR(wm8400->regmap);
 
 	wm8400->dev = &i2c->dev;
 	i2c_set_clientdata(i2c, wm8400);
 
-	ret = wm8400_init(wm8400, dev_get_platdata(&i2c->dev));
-	if (ret != 0)
-		goto err;
-
-	return 0;
-
-err:
-	return ret;
+	return wm8400_init(wm8400, dev_get_platdata(&i2c->dev));
 }
 
 static int wm8400_i2c_remove(struct i2c_client *i2c)
-- 
1.7.9.5

