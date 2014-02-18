Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbaBRKtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:49:22 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47032 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbaBRKrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:47:06 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 08/15] regulator: fan53555: Do not hardcode return values
Date: Tue, 18 Feb 2014 16:11:04 +0530
Message-Id: <1392720071-13503-8-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Propagate the error values returned by the function instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/fan53555.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index 7ca3d9e3b0fe..a10df7d150cc 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -90,11 +90,11 @@ static int fan53555_set_suspend_voltage(struct regulator_dev *rdev, int uV)
 		return 0;
 	ret = regulator_map_voltage_linear(rdev, uV, uV);
 	if (ret < 0)
-		return -EINVAL;
+		return ret;
 	ret = regmap_update_bits(di->regmap, di->sleep_reg,
 					VSEL_NSEL_MASK, ret);
 	if (ret < 0)
-		return -EINVAL;
+		return ret;
 	/* Cache the sleep voltage setting.
 	 * Might not be the real voltage which is rounded */
 	di->sleep_vol_cache = uV;
@@ -260,14 +260,14 @@ static int fan53555_regulator_probe(struct i2c_client *client,
 	ret = regmap_read(di->regmap, FAN53555_ID1, &val);
 	if (ret < 0) {
 		dev_err(&client->dev, "Failed to get chip ID!\n");
-		return -ENODEV;
+		return ret;
 	}
 	di->chip_id = val & DIE_ID;
 	/* Get chip revision */
 	ret = regmap_read(di->regmap, FAN53555_ID2, &val);
 	if (ret < 0) {
 		dev_err(&client->dev, "Failed to get chip Rev!\n");
-		return -ENODEV;
+		return ret;
 	}
 	di->chip_rev = val & DIE_REV;
 	dev_info(&client->dev, "FAN53555 Option[%d] Rev[%d] Detected!\n",
-- 
1.7.9.5

