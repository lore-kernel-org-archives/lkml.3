Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab3IZHty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:49:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29695 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3IZHtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:49:52 -0400
X-AuditID: cbfee68e-b7f756d000004512-b7-5243e717b7b9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Milo Kim'" <milo.kim@ti.com>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
In-reply-to: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
Subject: [PATCH V3 05/14] regulator: lp872x: use devm_regulator_register()
Date: Thu, 26 Sep 2013 16:49:43 +0900
Message-id: <003501ceba8c$f6588ff0$e309afd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jIjCzH3ID+v5Qym5l1DxbvczrwAAFPww
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zY13x585BBj/XSFhMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVceO9ZkG3YMXKc/0sDYxnebsYOTkkBEwkzp1vZ4awxSQu3FvP1sXIxSEksIxR4ntz
	IztMUd/iDywQiUWMEnsvbGeHcH4xShy58JQFpIpNQE3iy5fDQAkODhEBVYn/r9xBapgFuhkl
	ri77DDZJSMBWovHbX7B6TgE7iVn7T4KtFhbwknjYuokJxGYB6p3R/QmshheovuHUREYIW1Di
	x+R7YHFmAS2J9TuPM0HY8hKb17xlBtkrIaAu8eivLkhYRMBI4syM5YwQJSIS+168Y4R45h67
	xJsDxRCrBCS+TT7EAtEqK7HpADQgJCUOrrjBMoFRYhaSxbOQLJ6FZPEsJBsWMLKsYhRNLUgu
	KE5KLzLSK07MLS7NS9dLzs/dxAiJ074djDcPWB9iTAZaP5FZSjQ5HxjneSXxhsZmRhamJqbG
	RuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpglNTao+awmvGAz9Q4t5hL
	e3SW8mTyvi7g8L9n4r2hpvKrcqphvZJx7iG3ryftp89Z2nfniN7t7f/PlmR1Hi9apLzgEceL
	7H+Z3edalgupz+p8UC68/bDak/DlKhczWNg3bTg6k/XM5vKMzQL7N62bwjsj1uucdCd/5lXj
	bg/HU+2bfXf8MDUOUWIpzkg01GIuKk4EANCE1CrpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAV3x585BBq8Wi1hMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHHjvWZBt2DFynP9LA2MZ3m7GDk5JARMJPoW
	f2CBsMUkLtxbz9bFyMUhJLCIUWLvhe3sEM4vRokjF56CVbEJqEl8+XIYKMHBISKgKvH/lTtI
	DbNAN6PE1WWf2UFqhARsJRq//QWr5xSwk5i1/yQziC0s4CXxsHUTE4jNAtQ7o/sTWA0vUH3D
	qYmMELagxI/J98DizAJaEut3HmeCsOUlNq95ywyyV0JAXeLRX12QsIiAkcSZGcsZIUpEJPa9
	eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBKeBZ1I7
	GFc2WBxiFOBgVOLhvcDsHCTEmlhWXJl7iFGCg1lJhPebEVCINyWxsiq1KD++qDQntfgQYzLQ
	oxOZpUST84EpKq8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUa
	GCt2rNiws//l1aRDM16r/SmPXjUv1Lytw+hSQF7ngxXqR500Fz/JKV+7aisvo8fdd7YMM34f
	rm8pkT8S8Dro6MpTN2/+jjw+/2JGj/P8t+mXC/bkvOfPsk0ttN49PXZV6tpNlZmCl2MdLikm
	1eTW1WzpE2aW2+D44aLSqrvb1tfeYJbNrvaJEVBiKc5INNRiLipOBADdGfdJRwMAAA==
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


