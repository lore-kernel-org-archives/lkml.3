Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3IYH4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 03:56:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31299 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3IYH4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:56:32 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-68-5242972f3414
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Steve Twiss'" <stwiss.opensource@diasemi.com>,
        "'David Dajun Chen'" <david.chen@diasemi.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 05/20] regulator: da9210: use devm_regulator_register()
Date: Wed, 25 Sep 2013 16:56:31 +0900
Message-id: <000e01ceb9c4$bf4d5d10$3de81730$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAAPrMg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zY1396U5BBrufKlhMffiEzeL2j9Os
	FpcXXmK1+Halg8ni8q45bBZXf69ncWDzWPFJ32PnrLvsHptWdbJ59G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8bFT4dYChq4Kw68nszUwDiVs4uRk0NCwESiaf01VghbTOLCvfVsILaQwDJG
	iTWnGGFqHt7/CFTDBRRfxCix4ecKKOcXo8T1azvAqtgE1CS+fDnM3sXIwSEioCrx/5U7SJhZ
	4CyjxN0OPYihthLL/95mAbE5Bewklt37DLZMWMBd4svcJ0wgNgtQ64sJ78FG8gLVn7n3lg3C
	FpT4MfkeC8RMLYn1O48zQdjyEpvXvGUGWSshoC7x6K8uSFhEwEii4chpdogSEYl9L94xgpws
	IfCWXWL5qi3MELsEJL5NPsQC0SsrsekAM8S/khIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlW
	MYqmFiQXFCelFxnqFSfmFpfmpesl5+duYoTEa+8OxtsHrA8xJgOtn8gsJZqcD4z3vJJ4Q2Mz
	IwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwarVXBf6RnM3G
	JNDMxRDivHXRZilHzd9Ni/YuaDLbHhg8tUfORjbXus5I++D3/gzBAtZ5F+dO3Hrw6D5Vl2dX
	LrkeWxodHiku8z3sZTnreicpz6VfROtytkys8b281y60Sy+RQX1Oe9bUmT/6p31MmpEs/sh/
	Ym2hi8Du76ePzSn80Pv2kpGfEktxRqKhFnNRcSIAJ5wMDu0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jAV396U5BBht/yVhMffiEzeL2j9Os
	FpcXXmK1+Halg8ni8q45bBZXf69ncWDzWPFJ32PnrLvsHptWdbJ59G1ZxejxeZNcAGtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMi58OsRQ0cFcceD2ZqYFxKmcXIyeH
	hICJxMP7H1khbDGJC/fWs3UxcnEICSxilNjwcwUrhPOLUeL6tR2MIFVsAmoSX74cZu9i5OAQ
	EVCV+P/KHSTMLHCWUeJuhx6ILSRgK7H8720WEJtTwE5i2b3PbCC2sIC7xJe5T5hAbBag1hcT
	3oON5AWqP3PvLRuELSjxY/I9FoiZWhLrdx5ngrDlJTavecsMslZCQF3i0V9dkLCIgJFEw5HT
	7BAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3
	MYLTwTOpHYwrGywOMQpwMCrx8AocdQwSYk0sK67MPcQowcGsJMJbNNUpSIg3JbGyKrUoP76o
	NCe1+BBjMtCjE5mlRJPzgakqryTe0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWp
	RTBbmDg4pRoYHefyXnx4XI/3xqrN33kOTmBUuffk+NtFm969jPyesWaHZLd1+HHm7TMjtKdc
	v6R4pf/i5eLUDffn7d/J4XPHdceEhaW/NXLEWDsnqK6MfbrIoPH996v3tdSWCBZJ/P+3/0v4
	1MDl0k5H7odVfPh9fUq1zfve+C/2nXO2B3nYrfXZJ3Te5zbjTkUlluKMREMt5qLiRABX9Djb
	SwMAAA==
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


