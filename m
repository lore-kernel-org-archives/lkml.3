Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3I3AyB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:54:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17578 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3I3Ax6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:53:58 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-19-5248cba5faf7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Steve Twiss'" <stwiss.opensource@diasemi.com>,
        "'David Dajun Chen'" <david.chen@diasemi.com>
References: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
In-reply-to: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
Subject: [PATCH V4 04/14] regulator: da9210: use devm_regulator_register()
Date: Mon, 30 Sep 2013 09:53:57 +0900
Message-id: <007701cebd77$8b139f80$a13ade80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac69dwY7qCw/SuPGSmKRawAumfnevwAAGkQQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zQ92lpz2CDHpnGlhMffiEzeL2j9Os
	FpcXXmK1+Halg8ni8q45bBZXf69ncWDzWPFJ32PnrLvsHptWdbJ59G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8a/x/0sBS3cFS86l7A3MM7k7GLk4JAQMJH4s8q8i5ETyBSTuHBvPRuILSSw
	jFHi1MckiLiJRG/LacYuRi6g+CJGiZmPX7FAOL8YJZ7cnssIUsUmoCbx5cthdpChIgKqEv9f
	uYOEmQXOMkrc7dCDGGorMef8WbByTgE7iTsbWsFsYQEviTefn7OA2CxArae/nGMGsXmB6k+1
	dzFB2IISPybfY4GYqSWxfudxJghbXmLzmrfMEL+oSzz6qwsSFhEwkvi67jMrRImIxL4X7xgh
	fnnELnH1ahnEKgGJb5MPsUC0ykpsOsAMUSIpcXDFDZYJjBKzkCyehWTxLCSLZyHZsICRZRWj
	aGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSKxO2MF474D1IcZkoPUTmaVEk/OBsZ5XEm9obGZk
	YWpiamxkbmlGmrCSOK96i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkaTH9MPujWv/paq
	HaFzVtfY9arsxEY+5ZQTx6flHzzyOztp4z7pB+FT2NlO/BE3cH3y7tUv9yde9TMmGf+5zt0h
	rD9n2RWnJVMT5pndmtPRePjRBYUTjLdm7YkKS+oLv9L6mmP6/ISMvRonkrv9pIxTGnz62n+v
	lditvV5iWsfXea/nSfH4Ce1VYinOSDTUYi4qTgQAda0js+sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jAd2lpz2CDE5s0bGY+vAJm8XtH6dZ
	LS4vvMRq8e1KB5PF5V1z2Cyu/l7P4sDmseKTvsfOWXfZPTat6mTz6NuyitHj8ya5ANaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZ/x73sxS0cFe86FzC3sA4k7OLkZND
	QsBEorflNCOELSZx4d56ti5GLg4hgUWMEjMfv2KBcH4xSjy5PResik1ATeLLl8PsXYwcHCIC
	qhL/X7mDhJkFzjJK3O3QA7GFBGwl5pw/C1bOKWAncWdDK5gtLOAl8ebzcxYQmwWo9fSXc8wg
	Ni9Q/an2LiYIW1Dix+R7LBAztSTW7zzOBGHLS2xe85YZZK2EgLrEo7+6IGERASOJr+s+s0KU
	iEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhO
	B8+kdjCubLA4xCjAwajEwzthuUeQEGtiWXFl7iFGCQ5mJRHe5UlAId6UxMqq1KL8+KLSnNTi
	Q4zJQI9OZJYSTc4Hpqq8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh
	4uCUamB0t/tdPe9AQgaDlP3f/dkJE9sPvm7csvtvxJbAAt29Fd6T3aemrLN88L11hu5ym7mM
	jKHXLYtXqgZ4sGVwv2R8w/atKdvQgse34pmHzYc+HqUPglqPZhfe9XzxYGvD2cVa+oX1z/+c
	eqLzkNHt2Za7hUtP8PD5f9upMMtjmd2/5+/NNimpP9mixFKckWioxVxUnAgARVbuf0sDAAA=
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
index f7ccff1..6f5ecbe 100644
--- a/drivers/regulator/da9210-regulator.c
+++ b/drivers/regulator/da9210-regulator.c
@@ -155,7 +155,7 @@ static int da9210_i2c_probe(struct i2c_client *i2c,
 	config.regmap = chip->regmap;
 	config.of_node = dev->of_node;
 
-	rdev = regulator_register(&da9210_reg, &config);
+	rdev = devm_regulator_register(&i2c->dev, &da9210_reg, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&i2c->dev, "Failed to register DA9210 regulator\n");
 		return PTR_ERR(rdev);
@@ -168,13 +168,6 @@ static int da9210_i2c_probe(struct i2c_client *i2c,
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
@@ -188,7 +181,6 @@ static struct i2c_driver da9210_regulator_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = da9210_i2c_probe,
-	.remove = da9210_i2c_remove,
 	.id_table = da9210_i2c_id,
 };
 
-- 
1.7.10.4


