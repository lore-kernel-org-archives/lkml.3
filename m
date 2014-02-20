Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaBTI7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:59:30 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46829 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbaBTI70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:26 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 12/23] regulator: tps51632: Remove redundant error message
Date: Thu, 20 Feb 2014 14:23:12 +0530
Message-Id: <1392886403-10640-12-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc prints its own OOM message upon failure.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps51632-regulator.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/tps51632-regulator.c b/drivers/regulator/tps51632-regulator.c
index b3764f594ee9..f31f22e3e1bd 100644
--- a/drivers/regulator/tps51632-regulator.c
+++ b/drivers/regulator/tps51632-regulator.c
@@ -227,10 +227,8 @@ static struct tps51632_regulator_platform_data *
 	struct device_node *np = dev->of_node;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		dev_err(dev, "Memory alloc failed for platform data\n");
+	if (!pdata)
 		return NULL;
-	}
 
 	pdata->reg_init_data = of_get_regulator_init_data(dev, dev->of_node);
 	if (!pdata->reg_init_data) {
@@ -299,10 +297,8 @@ static int tps51632_probe(struct i2c_client *client,
 	}
 
 	tps = devm_kzalloc(&client->dev, sizeof(*tps), GFP_KERNEL);
-	if (!tps) {
-		dev_err(&client->dev, "Memory allocation failed\n");
+	if (!tps)
 		return -ENOMEM;
-	}
 
 	tps->dev = &client->dev;
 	tps->desc.name = client->name;
-- 
1.7.9.5

