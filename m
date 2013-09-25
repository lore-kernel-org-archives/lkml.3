Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3IYIFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:05:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26756 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3IYIFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:05:37 -0400
X-AuditID: cbfee68e-b7f756d000004512-c0-5242994b1093
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Milo Kim'" <milo.kim@ti.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 12/20] regulator: lp8788-ldo: use devm_regulator_register()
Date: Wed, 25 Sep 2013 17:05:30 +0900
Message-id: <001501ceb9c6$00e0f8d0$02a2ea70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAAlGcg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zY13vmU5BBlfeM1tMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsbTfrGCGYMX11kamBsblfF2MnBwSAiYST5reMUHYYhIX7q1n62Lk4hASWMYo8Wzd
	BmaYokOte1ghEosYJU7NmMwC4fxilLi84DQLSBWbgJrEly+H2bsYOThEBFQl/r9yB6lhFuhm
	lLi67DM7SI2QgK3E8r+3weo5Bewklt37zAZiCwt4S0zqnQ52BgtQ7/nlq8DivED1SzZ/YoWw
	BSV+TL4H1sssoCWxfudxJghbXmLzmrfMIHslBNQlHv3VBQmLCBhJ3PrYwwxRIiKx78U7Rohn
	HrFLrFgnDLFKQOLb5EMsEK2yEpsOQP0rKXFwxQ2WCYwSs5AsnoVk8Swki2ch2bCAkWUVo2hq
	QXJBcVJ6kZFecWJucWleul5yfu4mRkic9u1gvHnA+hBjMtD6icxSosn5wDjPK4k3NDYzsjA1
	MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANj2ILFcv6blj181rL/
	gWpgvzHr88UV51Wnm/abfak03fX41sTK1oW7rldaTrWI/Sh6Xn61/EX9VM+ZLOl3HziJpH71
	5b582G7Hg/r9irOeRK16zRhzk+F7f4xEr5LlxfbOSLFGzUf8h1SVxCMnGXyVD3wxIXrz8b1c
	iwOv7fTrrBH471WbddZSiaU4I9FQi7moOBEAi5Y+5OkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAV2vmU5BBnt6bSymPnzCZnF54SVW
	i29XOpgsLu+aw2ax/Nc6FgdWj52z7rJ7bFrVyebRt2UVo8fxG9uZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzFjab1YwQ7DiemsjUwPjcr4uRk4OCQETiUOt
	e1ghbDGJC/fWs3UxcnEICSxilDg1YzILhPOLUeLygtMsIFVsAmoSX74cZu9i5OAQEVCV+P/K
	HaSGWaCbUeLqss/sIDVCArYSy//eBqvnFLCTWHbvMxuILSzgLTGpdzoTiM0C1Ht++SqwOC9Q
	/ZLNn1ghbEGJH5PvgfUyC2hJrN95nAnClpfYvOYtM8heCQF1iUd/dUHCIgJGErc+9jBDlIhI
	7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQITgPP
	pHcwrmqwOMQowMGoxMMrcNQxSIg1say4MvcQowQHs5IIb9FUpyAh3pTEyqrUovz4otKc1OJD
	jMlAj05klhJNzgemqLySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi
	4JRqYHRfbJwV7HW232XJfyWNWRYXmW4XLQ1mWc/9TvR7CavVzZ2mXcmls/Z/eZscmn7js7RP
	3ePO7Q7yt/TiJ+zt0E/eUsU+hX/b1vci/StYdU8Edi3+uHv53eNpe48abj7U7VUxwduwc4vB
	udAAe8mqqYzdIrMPrrDhTMlb+/p5yP5Jyw77/9+S0KjEUpyRaKjFXFScCAB0uTz8RwMAAA==
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


