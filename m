Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaBLJPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:15:53 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:41616 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaBLJPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:15:38 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/4] mfd: stw481x: Check the return value of devm_regmap_init_i2c
Date: Wed, 12 Feb 2014 14:40:13 +0530
Message-Id: <1392196213-20576-4-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392196213-20576-1-git-send-email-sachin.kamat@linaro.org>
References: <1392196213-20576-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_regmap_init_i2c can fail. Check for it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/stw481x.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mfd/stw481x.c b/drivers/mfd/stw481x.c
index cc42f88586f6..7ceb3df09e25 100644
--- a/drivers/mfd/stw481x.c
+++ b/drivers/mfd/stw481x.c
@@ -186,6 +186,12 @@ static int stw481x_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, stw481x);
 	stw481x->client = client;
 	stw481x->map = devm_regmap_init_i2c(client, &stw481x_regmap_config);
+	if (IS_ERR(stw481x->map)) {
+		ret = PTR_ERR(stw481x->map);
+		dev_err(&client->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
 
 	ret = stw481x_startup(stw481x);
 	if (ret) {
-- 
1.7.9.5

