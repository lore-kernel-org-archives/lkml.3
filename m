Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab3IZCJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:09:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21905 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3IZCJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:09:15 -0400
X-AuditID: cbfee68e-b7f756d000004512-13-52439749813b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Milo Kim'" <milo.kim@ti.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 10/18] regulator: lp8788-ldo: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:09:12 +0900
Message-id: <001001ceba5d$65136da0$2f3a48e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAO0KA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zA13P6c5BBiceS1pMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsbTfrGCGYMX11kamBsblfF2MnBwSAiYSB36fZIGwxSQu3FvP1sXIxSEksIxR4uy/
	RcwwRa3nesBsIYHpjBKXWlwg7F+MEntOMoLYbAJqEl++HGbvYuTgEBFQlfj/yh1kDrNAN6PE
	1WWf2SHqbSVO/b7IBmJzCthJnL62kRXEFhbwk9i6+gXYHBag3kUbJ4DFeYHqn2y+zg5hC0r8
	mHwP7FBmAS2J9TuPM0HY8hKb17xlBtkrIaAu8eivLkhYRMBI4uX1PmaIEhGJfS/eMYLcIyFw
	i13ifMMPqF0CEt8mH2KB6JWV2HQA6l1JiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsYRVML
	kguKk9KLjPSKE3OLS/PS9ZLzczcxQqK0bwfjzQPWhxiTgdZPZJYSTc4HRnleSbyhsZmRhamJ
	qbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilgHHdsT9bp+bg39uO65Xf
	/ta/d3fhz8wPttPKkzuVK5M5H+z0XyF+X6DK1jKE9YazalNT+PMZ384fX91RaHmAd5qfXuOM
	yvhHuzkKbqxt+yOhe1/t1pG/vEcfi73wPi8qZfbu4L9mrjeT3xZ6Ss+9H/E78d/6DSvsTZMt
	ZT8yBxkt++8iYsDn/VeJpTgj0VCLuag4EQDI1lXW6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQV3P6c5BBlfPiFpMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLG036xghmDF9dZGpgbG5XxdjJwcEgImEq3n
	epghbDGJC/fWs4HYQgLTGSUutbhA2L8YJfacZASx2QTUJL58OczexcjBISKgKvH/lXsXIxcH
	s0A3o8TVZZ/ZIeptJU79vgg2h1PATuL0tY2sILawgJ/E1tUvwOawAPUu2jgBLM4LVP9k83V2
	CFtQ4sfkeywgNrOAlsT6nceZIGx5ic1r3jKD7JUQUJd49FcXJCwiYCTx8nofM0SJiMS+F+8Y
	JzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAU8Ex6B+Oq
	BotDjAIcjEo8vBeYnYOEWBPLiitzDzFKcDArifB+MwIK8aYkVlalFuXHF5XmpBYfYkwGenQi
	s5Rocj4wPeWVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2NI
	73X21fJO6kb7DvHMvvyq8ObtDomlB3m8jS0cnr//pJxnNimwkKtRSDzjOP+VszV/L6lbn546
	aV2xXmvf9JWmtxyuHPvnGcjLcSGdTf1ayz/NYDHVN+6LixgUb6ZGKE58/3SdLuePhCPbFqjV
	Vu1b/vzNF4u3/LklUUd388RZKRz55fvej0uJpTgj0VCLuag4EQCSEmzVRQMAAA==
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
 drivers/regulator/lp8788-ldo.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/lp8788-ldo.c b/drivers/regulator/lp8788-ldo.c
index 0527d87..b9a29a2 100644
--- a/drivers/regulator/lp8788-ldo.c
+++ b/drivers/regulator/lp8788-ldo.c
@@ -543,7 +543,7 @@ static int lp8788_dldo_probe(struct platform_device *pdev)
 	cfg.driver_data = ldo;
 	cfg.regmap = lp->regmap;
 
-	rdev = regulator_register(&lp8788_dldo_desc[id], &cfg);
+	rdev = devm_regulator_register(&pdev->dev, &lp8788_dldo_desc[id], &cfg);
 	if (IS_ERR(rdev)) {
 		ret = PTR_ERR(rdev);
 		dev_err(&pdev->dev, "DLDO%d regulator register err = %d\n",
@@ -557,18 +557,8 @@ static int lp8788_dldo_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int lp8788_dldo_remove(struct platform_device *pdev)
-{
-	struct lp8788_ldo *ldo = platform_get_drvdata(pdev);
-
-	regulator_unregister(ldo->regulator);
-
-	return 0;
-}
-
 static struct platform_driver lp8788_dldo_driver = {
 	.probe = lp8788_dldo_probe,
-	.remove = lp8788_dldo_remove,
 	.driver = {
 		.name = LP8788_DEV_DLDO,
 		.owner = THIS_MODULE,
@@ -603,7 +593,7 @@ static int lp8788_aldo_probe(struct platform_device *pdev)
 	cfg.driver_data = ldo;
 	cfg.regmap = lp->regmap;
 
-	rdev = regulator_register(&lp8788_aldo_desc[id], &cfg);
+	rdev = devm_regulator_register(&pdev->dev, &lp8788_aldo_desc[id], &cfg);
 	if (IS_ERR(rdev)) {
 		ret = PTR_ERR(rdev);
 		dev_err(&pdev->dev, "ALDO%d regulator register err = %d\n",
@@ -617,18 +607,8 @@ static int lp8788_aldo_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int lp8788_aldo_remove(struct platform_device *pdev)
-{
-	struct lp8788_ldo *ldo = platform_get_drvdata(pdev);
-
-	regulator_unregister(ldo->regulator);
-
-	return 0;
-}
-
 static struct platform_driver lp8788_aldo_driver = {
 	.probe = lp8788_aldo_probe,
-	.remove = lp8788_aldo_remove,
 	.driver = {
 		.name = LP8788_DEV_ALDO,
 		.owner = THIS_MODULE,
-- 
1.7.10.4


