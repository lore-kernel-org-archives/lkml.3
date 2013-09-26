Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab3IZCFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:05:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42978 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab3IZCFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:05:01 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-88-5243964b781a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Krystian Garbaciak'" <krystian.garbaciak@diasemi.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 04/18] regulator: da9210: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:04:59 +0900
Message-id: <000a01ceba5c$cddec790$699c56b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAE6Kg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zfV3vac5BBo+fm1hMffiEzeLZrb1M
	FpcXXmK1OPL4M5vFtysdQO6uOWwObB4rPul77Jx1l91j06pONo9DhzsYPfq2rGL0+LxJLoAt
	issmJTUnsyy1SN8ugSvj4qdDLAUN3BUHXk9mamCcytnFyMEhIWAisWlPfRcjJ5ApJnHh3nq2
	LkYuDiGBZYwSJ9csZ4JImEg8mTybFSKxiFFiz94eRgjnF6PEqZXXWUCq2ATUJL58OcwOMlVE
	QFXi/yt3kBpmgauMEieebWMGqRESsJU49fsiG4jNKWAncfraRlYQW1jAS2Lz1QOMIDYLUO/8
	hbuYQebwAtU3vPECCfMKCEr8mHwPbBWzgJbE+p3HmSBseYnNa94yQzyjLvHory7EBUYSX79G
	QlSISOx78Q7sYgmBt+wSc1bshNokIPFt8iEWiFZZiU0HmCHelZQ4uOIGywRGiVlIFs9CsngW
	ksWzkKxYwMiyilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMkbvt3MN49YH2IMRlo/URmKdHk
	fGDc55XEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	Mfn7FDe+5KfJzcbpv58sPi5pst3f+kDnDL7l70RffpH6JN+gzX045hbj5JXnP3z/WBz5vVhk
	p3ubrsSvj5te1LVIOYW/0OgNWDyN7dwBIZ/+jww/P8r9dV/4tP0bw/9XUq+OzVJiz9Kp2Rt0
	1PnxnNen9irZMk1f8mPV7iu+wse1tn1Q5v3Kt1OJpTgj0VCLuag4EQBsFXIg8QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jAV3vac5BBo1nDCymPnzCZvHs1l4m
	i8sLL7FaHHn8mc3i25UOIHfXHDYHNo8Vn/Q9ds66y+6xaVUnm8ehwx2MHn1bVjF6fN4kF8AW
	1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0hpJC
	WWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4+KnQywFDdwVB15PZmpgnMrZ
	xcjJISFgIvFk8mxWCFtM4sK99WxdjFwcQgKLGCX27O1hhHB+MUqcWnmdBaSKTUBN4suXw+xd
	jBwcIgKqEv9fuYPUMAtcZZQ48WwbM0iNkICtxKnfF9lAbE4BO4nT1zaCbRAW8JLYfPUAI4jN
	AtQ7f+EuZpA5vED1DW+8QMK8AoISPybfA1vFLKAlsX7ncSYIW15i85q3YOUSAuoSj/7qQlxg
	JPH1ayREhYjEvhfvGCcwCs1CMmgWkkGzkAyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS9
	5PzcTYzgtPBMagfjygaLQ4wCHIxKPLwXmJ2DhFgTy4orcw8xSnAwK4nwfjMCCvGmJFZWpRbl
	xxeV5qQWH2JMBnpzIrOUaHI+MGXllcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1
	tSC1CGYLEwenVAOjgpoUb1rpkqezb3QpP3/cN+e/IGvHgR3KlXzm3ff1hT/Z5GrHxO/gcj3p
	0PD3Q+Gcd9tOyX641CIj+HfPepmtnjomXYau61eG2qnqpnsF6F52uqXf25nNv0OuZOKG+rmn
	E1MYjwTYLbNZG7bnevzvJyb5/An2V8VNep2DNpTEs68zj7P9E6rEUpyRaKjFXFScCAC2FC5M
	TwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/da9210-regulator.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/regulator/da9210-regulator.c b/drivers/regulator/da9210-regulator.c
index f0fe54b..82368a3 100644
--- a/drivers/regulator/da9210-regulator.c
+++ b/drivers/regulator/da9210-regulator.c
@@ -152,7 +152,7 @@ static int da9210_i2c_probe(struct i2c_client *i2c,
 	config.driver_data = chip;
 	config.regmap = chip->regmap;
 
-	rdev = regulator_register(&da9210_reg, &config);
+	rdev = devm_regulator_register(&i2c->dev, &da9210_reg, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&i2c->dev, "Failed to register DA9210 regulator\n");
 		return PTR_ERR(rdev);
@@ -165,13 +165,6 @@ static int da9210_i2c_probe(struct i2c_client *i2c,
 	return 0;
 }
 
-static int da9210_i2c_remove(struct i2c_client *i2c)
-{
-	struct da9210 *chip = i2c_get_clientdata(i2c);
-	regulator_unregister(chip->rdev);
-	return 0;
-}
-
 static const struct i2c_device_id da9210_i2c_id[] = {
 	{"da9210", 0},
 	{},
@@ -185,7 +178,6 @@ static struct i2c_driver da9210_regulator_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = da9210_i2c_probe,
-	.remove = da9210_i2c_remove,
 	.id_table = da9210_i2c_id,
 };
 
-- 
1.7.10.4


