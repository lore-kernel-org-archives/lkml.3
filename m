Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaCJIdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:33:03 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:14371 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaCJIdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:33:00 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-b3-531d78bb2f3c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 4/8] regulator: max8649: Remove regulator_dev pointer from
 state container
Date: Mon, 10 Mar 2014 09:32:47 +0100
Message-id: <1394440371-29588-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
References: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsVy+t/xK7q7K2SDDa6v4bOY+vAJm8XrF4YW
	3650MFlc3jWHzYHFY+esu+wem1Z1snn0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxq6vd9kK
	NvBUNE5aztrAuIyri5GTQ0LARGLN/zmMELaYxIV769m6GLk4hASWMkq8n3uEFcLpY5JY/aob
	rIpNwFhi8/IlbCC2iECGxOZ5U1lBbGYBQ4mf7/6wg9jCAjESPStOgNWwCKhKnFh/AqyXV8Bd
	YsvXHUD1HEDbFCTmTLIBCXMKeEgs2nMLrFUIqGR35w6WCYy8CxgZVjGKppYmFxQnpeca6RUn
	5haX5qXrJefnbmKEhMrXHYxLj1kdYhTgYFTi4T3wViZYiDWxrLgy9xCjBAezkghvRpxssBBv
	SmJlVWpRfnxRaU5q8SFGJg5OqQbGqZIfblg9vFvFwzDHsoZLeq7/bKPL8w796lmhyHC12urt
	oa22Ekv/Xa7at3nzDcvG9yrddSoL39xx+XsjvKj8St5Flpk9EkJZVnsDOCaYvH3h5nBIIF4g
	pvS4mBfjwVOTP25b1Cp0hHfTz4p3s9NLVkt/EGdaU5zy9cmVS4wHVDgnSHRb5fx9r8RSnJFo
	qMVcVJwIAKAm+vbzAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't store pointer to regulator_dev returned by
evm_regulator_register() an state container. It isn't used anywhere
outside of max8649_regulator_probe() function.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max8649.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 7f049c92ee52..3172da847d24 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -49,7 +49,6 @@
 #define MAX8649_RAMP_DOWN	(1 << 1)
 
 struct max8649_regulator_info {
-	struct regulator_dev	*regulator;
 	struct device		*dev;
 	struct regmap		*regmap;
 
@@ -154,6 +153,7 @@ static int max8649_regulator_probe(struct i2c_client *client,
 {
 	struct max8649_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct max8649_regulator_info *info = NULL;
+	struct regulator_dev *regulator;
 	struct regulator_config config = { };
 	unsigned int val;
 	unsigned char data;
@@ -234,12 +234,12 @@ static int max8649_regulator_probe(struct i2c_client *client,
 	config.driver_data = info;
 	config.regmap = info->regmap;
 
-	info->regulator = devm_regulator_register(&client->dev, &dcdc_desc,
+	regulator = devm_regulator_register(&client->dev, &dcdc_desc,
 						  &config);
-	if (IS_ERR(info->regulator)) {
+	if (IS_ERR(regulator)) {
 		dev_err(info->dev, "failed to register regulator %s\n",
 			dcdc_desc.name);
-		return PTR_ERR(info->regulator);
+		return PTR_ERR(regulator);
 	}
 
 	return 0;
-- 
1.7.9.5

