Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab3IZHtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:49:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29556 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab3IZHs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:48:58 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-96-5243e6e9ba95
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Steve Twiss'" <stwiss.opensource@diasemi.com>,
        "'David Dajun Chen'" <david.chen@diasemi.com>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
In-reply-to: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
Subject: [PATCH V3 04/14] regulator: da9210: use devm_regulator_register()
Date: Thu, 26 Sep 2013 16:48:56 +0900
Message-id: <003401ceba8c$dada2400$908e6c00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jIjCzH3ID+v5Qym5l1DxbvczrwAAD+bA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zQ92Xz5yDDO41CVhMffiEzeL2j9Os
	FpcXXmK1+Halg8ni8q45bBZXf69ncWDzWPFJ32PnrLvsHptWdbJ59G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8bFT4dYChq4Kw68nszUwDiVs4uRk0NCwETi04mjLBC2mMSFe+vZuhi5OIQE
	ljFKbP22krWLkQOsqPd7JUiNkMB0RompvzIgan4xSsw594cZJMEmoCbx5cthdpB6EQFVif+v
	3EHCzAJnGSXuduhB9NpKNH77C7aLU8BOYtb+k8wg5cICXhLnb0iAhFmAOr/tPcMIYvMClX/8
	d5gNwhaU+DH5HgvESC2J9TuPM0HY8hKb17xlhrhSXeLRX12QsIiAkcSmS1uZIUpEJPa9eMcI
	crGEwD12icm9rSwQuwQkvk0+xALRKyux6QAzJBQkJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYw
	sqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECInV3h2Mtw9YH2JMBlo/kVlKNDkfGOt5JfGG
	xmZGFqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBsSloZfOZT
	6WWrpy+4LwdkcXY3XFCotl04/43ifqYrE7oSjLf01ET0Mh5lkFy83zPufHv+q41Bd/a/PFqU
	lJElsM2iyEjn+dl6ia1hUmkPOUNFU7pdDJ8dPn4w8xvT6vMvAo7fPRo7MdZhSnvultnb3nQk
	H1HIFJ5erH+vaFVF1k4/z0+J19crsRRnJBpqMRcVJwIACIWFZusCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd2Xz5yDDC795baY+vAJm8XtH6dZ
	LS4vvMRq8e1KB5PF5V1z2Cyu/l7P4sDmseKTvsfOWXfZPTat6mTz6NuyitHj8ya5ANaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZFz8dYilo4K448HoyUwPjVM4uRg4O
	CQETid7vlV2MnECmmMSFe+vZQGwhgemMElN/ZXQxcgHZvxgl5pz7wwySYBNQk/jy5TA7SK+I
	gKrE/1fuIGFmgbOMEnc79CB6bSUav/1lAbE5BewkZu0/yQxSLizgJXH+hgRImAWo89veM4wg
	Ni9Q+cd/h9kgbEGJH5PvsUCM1JJYv/M4E4QtL7F5zVtmiIvVJR791QUJiwgYSWy6tJUZokRE
	Yt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcCJ4
	Jr2DcVWDxSFGAQ5GJR7eC8zOQUKsiWXFlbmHGCU4mJVEeL8ZAYV4UxIrq1KL8uOLSnNSiw8x
	JgM9OpFZSjQ5H5ik8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmD
	U6qB0fefFLPQAull/29xz0v4Zpd5tT72d/Tzbf9kbgTudTvUcjCqrz5iU3D7sll7H/TarHju
	MV90kgiHourXb1uP1z+adW/z79f7zojNSfqYHsz+/8LOSUIe59S7pf+HcvrHVbZybw6JVZGK
	OxkSltXFuviKjiK/We2v3xUGmrevFc/P7ilpuqG8XomlOCPRUIu5qDgRAK9gXyBIAwAA
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


