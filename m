Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab3IZCLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:11:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22486 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab3IZCLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:11:51 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-01-524397e5c5fe
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 15/18] regulator: tps6105x: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:11:49 +0900
Message-id: <001501ceba5d$c24268a0$46c739e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAUxCA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zQ92n052DDPbf1LSY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpsDi8fOWXfZPTat6mTz6NuyitHj8ya5AJYoLpuU1JzMstQifbsErowd61cy
	FWzmqfj3dhZ7A+M6ri5GTg4JAROJX5vPskPYYhIX7q1n62Lk4hASWMYo8fL1K0aYoqUvfrNA
	JBYxSuxaNpEJwvnFKLHjyg42kCo2ATWJL18OA43i4BARUJX4/8odxGQWyJXo3pYOUiEkYCtx
	6vdFsGpOATuJ09c2soLYwgI+EpMvtzGD2CxAnWv+HwezeYHqd/1ZxwZhC0r8mHyPBcRmFtCS
	WL/zOBOELS+xec1bZpBVEgLqEo/+6oKERQSMJFat/MQMUSIise/FO0aQiyUEzrFLnPr3GGqX
	gMS3yYdYIHplJTYdYIZ4V1Li4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CIT
	veLE3OLSvHS95PzcTYyQmJywg/HeAetDjMlA6ycyS4km5wNjOq8k3tDYzMjC1MTU2Mjc0ow0
	YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjL3epXHiE+WnWspyfri8yXaW4m6B
	+BehP3+8funhv7St7iOPUINmjN2rRdMP/eAq67SaOe/k4p39K974vHZq0xZ7tr3NOTLiVGCX
	iea67SfWX4u/7ue2jvsmYymL1XTjx+qbcs0uPbrlamR1al2806TVXLfE6k+oOFZ9456/PSHk
	lzqbTthLSSWW4oxEQy3mouJEAEI6OHjfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd2n052DDM7OVbOY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpsDi8fOWXfZPTat6mTz6NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMHetXMhVs5qn493YWewPjOq4uRk4OCQETiaUvfrNA2GISF+6t
	Z+ti5OIQEljEKLFr2UQmCOcXo8SOKzvYQKrYBNQkvnw5zN7FyMEhIqAq8f+VO4jJLJAr0b0t
	HaRCSMBW4tTvi2DVnAJ2EqevbWQFsYUFfCQmX25jBrFZgDrX/D8OZvMC1e/6s44NwhaU+DH5
	Htg9zAJaEut3HmeCsOUlNq95ywyySkJAXeLRX12QsIiAkcSqlZ+YIUpEJPa9eMc4gVFoFpJJ
	s5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEf8M6kdjCsbLA4xCnAw
	KvHwXmB2DhJiTSwrrsw9xCjBwawkwvvNCCjEm5JYWZValB9fVJqTWnyIMRno0YnMUqLJ+cBk
	lFcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjLV9fxe9VtU7
	cXrbXCet3y5pMimdtztUfovG9+jcyX+jOtUseoK7z7q/m/R9w2rNejW0BDuOh2VXVqQI+BtP
	XPlfYuEnhZmuu7oO/q8yD36Qq8FxZkvOwq1TdDtEchlP1LwzWT91rk2w3Yovnw72Hnpy2Fgs
	bpHrNP9HvW9+vW9el2Ao7p/0S4mlOCPRUIu5qDgRABLdLCU8AwAA
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
 drivers/regulator/tps6105x-regulator.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/tps6105x-regulator.c b/drivers/regulator/tps6105x-regulator.c
index ec9453f..e0e818d 100644
--- a/drivers/regulator/tps6105x-regulator.c
+++ b/drivers/regulator/tps6105x-regulator.c
@@ -146,8 +146,9 @@ static int tps6105x_regulator_probe(struct platform_device *pdev)
 	config.driver_data = tps6105x;
 
 	/* Register regulator with framework */
-	tps6105x->regulator = regulator_register(&tps6105x_regulator_desc,
-						 &config);
+	tps6105x->regulator = devm_regulator_register(&pdev->dev,
+						      &tps6105x_regulator_desc,
+						      &config);
 	if (IS_ERR(tps6105x->regulator)) {
 		ret = PTR_ERR(tps6105x->regulator);
 		dev_err(&tps6105x->client->dev,
@@ -159,20 +160,12 @@ static int tps6105x_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int tps6105x_regulator_remove(struct platform_device *pdev)
-{
-	struct tps6105x *tps6105x = dev_get_platdata(&pdev->dev);
-	regulator_unregister(tps6105x->regulator);
-	return 0;
-}
-
 static struct platform_driver tps6105x_regulator_driver = {
 	.driver = {
 		.name  = "tps6105x-regulator",
 		.owner = THIS_MODULE,
 	},
 	.probe = tps6105x_regulator_probe,
-	.remove = tps6105x_regulator_remove,
 };
 
 static __init int tps6105x_regulator_init(void)
-- 
1.7.10.4


