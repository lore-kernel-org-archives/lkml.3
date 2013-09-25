Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3IYIDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:03:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26277 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3IYIDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:03:39 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-51-524298d950d7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Milo Kim'" <milo.kim@ti.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 10/20] regulator: lp872x: use devm_regulator_register()
Date: Wed, 25 Sep 2013 17:03:37 +0900
Message-id: <001301ceb9c5$bd23d0e0$376b72a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAAfmrw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zA92bM5yCDFq361tMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVceO9ZkG3YMXKc/0sDYxnebsYOTkkBEwkfn7eygZhi0lcuLceyObiEBJYxihxc9VN
	NpiiZTt+MYLYQgKLGCVW/NeBKPoFZH++yQySYBNQk/jy5TB7FyMHh4iAqsT/V+4gNcwC3YwS
	V5d9ZodotpVY/vc2C4jNKWAnsezeZ7AFwgLuEq/v9oDVsAD19j+7ABbnBao/dnoeO4QtKPFj
	8j2wXmYBLYn1O48zQdjyEpvXvGUG2SshoC7x6K8uSFhEwEiidcVLZogSEYl9L94xgtwjIXCL
	XeLL8odQuwQkvk0+xALRKyux6QAzxL+SEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYW
	JBcUJ6UXmegVJ+YWl+al6yXn525ihMTphB2M9w5YH2JMBlo/kVlKNDkfGOd5JfGGxmZGFqYm
	psZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamAMZ2HIsb979Hf/y2ym
	Yn/ZhPm9zZZ3AgxqNNcHCObdfL8g9/ebx16xVdeT7dJS+/5dd/NSmp+9PFNHUvv7gd8XVreu
	/ZRT5bnq1C3xuxfd59k72f5jM305I2dTdpX4gb9ytR8v3Y57eHSh21XmpNtryh4+kz3Xaj8p
	cL6hnM+mtvDD5R6przWVWIozEg21mIuKEwGZ5s7x6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd2bM5yCDD6s1bKY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF8l/rWBxYPXbOusvusWlVJ5tH35ZVjB7Hb2xn8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePGe82CbsGKlef6WRoYz/J2MXJySAiYSCzb
	8YsRwhaTuHBvPRuILSSwiFFixX+dLkYuIPsXkP35JjNIgk1ATeLLl8PsXYwcHCICqhL/X7mD
	1DALdDNKXF32mR2i2VZi+d/bLCA2p4CdxLJ7n8GGCgu4S7y+2wNWwwLU2//sAlicF6j+2Ol5
	7BC2oMSPyffAepkFtCTW7zzOBGHLS2xe85YZZK+EgLrEo7+6IGERASOJ1hUvmSFKRCT2vXjH
	OIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQngWfSOxhX
	NVgcYhTgYFTi4RU46hgkxJpYVlyZe4hRgoNZSYS3aKpTkBBvSmJlVWpRfnxRaU5q8SHGZKBH
	JzJLiSbnAxNUXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUw
	TgpZunxWs82pT5IN8RZpDy+LhqfNv2tp3MF+X6tq4+oTghsyEwrWJ3dc4j1wIe111huH/KxJ
	vEt3vTsnudninpWRd5zn86v7oi6l5LzS9tr2crJbw42ghYIH4ybM//C0dq/3CSeJZEn55hCN
	hQWb/Cxv3TkRJPvgZuGUKSJX6+26zPnZt5neVWIpzkg01GIuKk4EAJyKm/hGAwAA
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


