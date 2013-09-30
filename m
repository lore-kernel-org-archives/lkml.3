Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3I3Ayj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:54:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59058 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab3I3Ayg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:54:36 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-92-5248cbca04fa
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Milo Kim'" <milo.kim@ti.com>
References: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
In-reply-to: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
Subject: [PATCH V4 05/14] regulator: lp872x: use devm_regulator_register()
Date: Mon, 30 Sep 2013 09:54:34 +0900
Message-id: <007801cebd77$a145ff00$e3d1fd00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac69dwY7qCw/SuPGSmKRawAumfnevwAAIYhA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zI91Tpz2CDC5N0rGY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF8l/rWBxYPXbOusvusWlVJ5tH35ZVjB7Hb2xn8vi8SS6ANYrLJiU1J7Ms
	tUjfLoEr48Z7zYJuwYqV5/pZGhjP8nYxcnJICJhITGvaxAphi0lcuLeerYuRi0NIYBmjxK87
	rxi7GDnAipb8rICIT2eUOPfrLBtIg5DAL0aJH63lIDabgJrEly+H2UHqRQRUJf6/cgepZxbo
	ZpS4uuwzO0S9rcSc82cZQWxOATuJOxtaweYLC3hJPHgrAxJmAWpduuYZ2HheoPI38x8xQ9iC
	Ej8m32MBsZkFtCTW7zzOBGHLS2xe85YZ4kx1iUd/dUHCIgJGEncOf2WFKBGR2PfiHSPIORIC
	t9gl/q89zwqxS0Di2+RDLBC9shKbDjBDgkFS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG
	0dSC5ILipPQiQ73ixNzi0rx0veT83E2MkBjt3cF4+4D1IcZkoPUTmaVEk/OBMZ5XEm9obGZk
	YWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkYRtZjAG1d7NnLk
	bgvJUDl3bhvzpJrdBxLl3/+rlbX3+XE+2H9vf+vRpYnH31+YI950OEetp0O9483j2G81ARXK
	Vi3cavkeU6Pk3v0+rbjErKJIQX7D51sZfFWCC++/fRh48uuX9tArDd/7pOeuuxO5RWVPkLrE
	9eobzepKWk8K/7v9P/hmf48SS3FGoqEWc1FxIgDEw8TG5wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jQd1Tpz2CDD5M1bCY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF8l/rWBxYPXbOusvusWlVJ5tH35ZVjB7Hb2xn8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePGe82CbsGKlef6WRoYz/J2MXJwSAiYSCz5
	WdHFyAlkiklcuLeerYuRi0NIYDqjxLlfZ9lAEkICvxglfrSWg9hsAmoSX74cZgfpFRFQlfj/
	yh2knlmgm1Hi6rLP7BD1thJzzp9lBLE5Bewk7mxoZQSpFxbwknjwVgYkzALUunTNM7DxvEDl
	b+Y/YoawBSV+TL7HAmIzC2hJrN95nAnClpfYvOYtM8TJ6hKP/uqChEUEjCTuHP7KClEiIrHv
	xTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgBPJPe
	wbiqweIQowAHoxIPr8VSjyAh1sSy4srcQ4wSHMxKIrzLk4BCvCmJlVWpRfnxRaU5qcWHGJOB
	Hp3ILCWanA9MTnkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnV
	wNgiMu9FpXGxqVT9Nhbbu2XLCvl+x+zr+3Pmpdsdkxm83lL/OXK6tzPfk7miGy21K7Rx8X1f
	r4m5FjeunJG69Iv93KSpRpb6CzJzP0074NpzZJ/c36qCmQ9uV6RpMz8udg5vLnmZ3exRqGkS
	MEF9u7ffrmZOqUauLbllqzfqvTNq4T17mGX9CyWW4oxEQy3mouJEAP6mzbBEAwAA
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
 drivers/regulator/lp872x.c |   33 +++------------------------------
 1 file changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/regulator/lp872x.c b/drivers/regulator/lp872x.c
index 2b84b72..2e4734f 100644
--- a/drivers/regulator/lp872x.c
+++ b/drivers/regulator/lp872x.c
@@ -785,7 +785,7 @@ static int lp872x_regulator_register(struct lp872x *lp)
 	struct regulator_desc *desc;
 	struct regulator_config cfg = { };
 	struct regulator_dev *rdev;
-	int i, ret;
+	int i;
 
 	for (i = 0; i < lp->num_regulators; i++) {
 		desc = (lp->chipid == LP8720) ? &lp8720_regulator_desc[i] :
@@ -796,34 +796,16 @@ static int lp872x_regulator_register(struct lp872x *lp)
 		cfg.driver_data = lp;
 		cfg.regmap = lp->regmap;
 
-		rdev = regulator_register(desc, &cfg);
+		rdev = devm_regulator_register(lp->dev, desc, &cfg);
 		if (IS_ERR(rdev)) {
 			dev_err(lp->dev, "regulator register err");
-			ret =  PTR_ERR(rdev);
-			goto err;
+			return PTR_ERR(rdev);
 		}
 
 		*(lp->regulators + i) = rdev;
 	}
 
 	return 0;
-err:
-	while (--i >= 0) {
-		rdev = *(lp->regulators + i);
-		regulator_unregister(rdev);
-	}
-	return ret;
-}
-
-static void lp872x_regulator_unregister(struct lp872x *lp)
-{
-	struct regulator_dev *rdev;
-	int i;
-
-	for (i = 0; i < lp->num_regulators; i++) {
-		rdev = *(lp->regulators + i);
-		regulator_unregister(rdev);
-	}
 }
 
 static const struct regmap_config lp872x_regmap_config = {
@@ -979,14 +961,6 @@ err_dev:
 	return ret;
 }
 
-static int lp872x_remove(struct i2c_client *cl)
-{
-	struct lp872x *lp = i2c_get_clientdata(cl);
-
-	lp872x_regulator_unregister(lp);
-	return 0;
-}
-
 static const struct of_device_id lp872x_dt_ids[] = {
 	{ .compatible = "ti,lp8720", },
 	{ .compatible = "ti,lp8725", },
@@ -1008,7 +982,6 @@ static struct i2c_driver lp872x_driver = {
 		.of_match_table = of_match_ptr(lp872x_dt_ids),
 	},
 	.probe = lp872x_probe,
-	.remove = lp872x_remove,
 	.id_table = lp872x_ids,
 };
 
-- 
1.7.10.4


