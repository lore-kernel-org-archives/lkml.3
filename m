Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3IYIMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:12:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35396 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3IYIMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:12:07 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-ac-52429ad5411d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 17/20] regulator: tps6105x: use devm_regulator_register()
Date: Wed, 25 Sep 2013 17:12:04 +0900
Message-id: <001a01ceb9c6$ebaa9010$c2ffb030$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAAzsFA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zI92rs5yCDCatZrKY+vAJm8XlhZdY
	Lb5d6WCymPJnOZPF5V1z2BxYPXbOusvusWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANYrLJiU1J7Ms
	tUjfLoErY8f6lUwFm3kq/r2dxd7AuI6ri5GTQ0LAROJ5/xkmCFtM4sK99WxdjFwcQgLLGCXu
	3NjLDFPUu3IFK0RiEaPEu3PnwTqEBH4xSlx/7AJiswmoSXz5cpi9i5GDQ0RAVeL/K3eQemaB
	mYwSO/t3QNXbSiz/e5sFxOYUsJNYdu8zG4gtLOApceDIQlYQmwWot+n8CbB6XqD6ef3LoGxB
	iR+T74H1MgtoSazfeZwJwpaX2LzmLTPIXgkBdYlHf3VBwiICRhLbDm1lhygRkdj34h0jxC/3
	2CVOPM2AWCUg8W3yIRaIVlmJTQeg3pWUOLjiBssERolZSBbPQrJ4FpLFs5BsWMDIsopRNLUg
	uaA4Kb3IRK84Mbe4NC9dLzk/dxMjJE4n7GC8d8D6EGMy0PqJzFKiyfnAOM8riTc0NjOyMDUx
	NTYytzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+Ps2EtxCds3TS2+cfnB
	/gOpwTL/BQMvJNhyON9f+19SqJP5UlFh+QdLkTIp33fqHpl6wtd6OLZFcL21kTu78rtsrU0o
	5zxGVed1PAuatrpPlf8lZOyorv38YVzenjKpoHOmy65eTNgWbzztikJ7lZm/YLOYfCenRfD/
	4i//xDtTW+9GH9rOr8RSnJFoqMVcVJwIAKbr8RLpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd0rs5yCDFqOWVtMffiEzeLywkus
	Ft+udDBZTPmznMni8q45bA6sHjtn3WX32LSqk83jzrU9bB59W1YxenzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLFj/Uqmgs08Ff/ezmJvYFzH1cXIySEhYCLR
	u3IFK4QtJnHh3nq2LkYuDiGBRYwS786dZwJJCAn8YpS4/tgFxGYTUJP48uUwexcjB4eIgKrE
	/1fuIPXMAjMZJXb274Cqt5VY/vc2C4jNKWAnsezeZzYQW1jAU+LAkYVgy1iAepvOnwCr5wWq
	n9e/DMoWlPgx+R5YL7OAlsT6nceZIGx5ic1r3jKD7JUQUJd49FcXJCwiYCSx7dBWdogSEYl9
	L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFp4JnU
	DsaVDRaHGAU4GJV4eAWOOgYJsSaWFVfmHmKU4GBWEuF1nuEUJMSbklhZlVqUH19UmpNafIgx
	GejRicxSosn5wBSVVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTByc
	Ug2MJ5V57m3ymLRjyc6dllN0I88m7vq5I7Nn0qyX2hdmbHix/3fCt49rbh3gadnX5meux1tx
	j5Nxa7PvpL6bH8LftLZdjLiwrabikHDCij8zbS4dXfZm58rmg5ss3wv+3ezrwdWcn9co5Oh+
	VlI3RC/kweVtR0R3c76d3jRP92P1NdtmNWnbs9b7ipRYijMSDbWYi4oTAV/aX2xHAwAA
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


