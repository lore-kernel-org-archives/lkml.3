Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3I3A7K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:59:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18548 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3I3A7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:59:05 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-58-5248ccd87bef
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Balaji T K'" <balajitk@ti.com>,
        "'Nishanth Menon'" <nm@ti.com>
References: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
In-reply-to: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
Subject: [PATCH V4 13/14] regulator: twl: use devm_regulator_register()
Date: Mon, 30 Sep 2013 09:59:04 +0900
Message-id: <008001cebd78$4259a720$c70cf560$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac69dwY7qCw/SuPGSmKRawAumfnevwAASbuA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zQ90bZzyCDA6/tbSYOnk7m8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2Cze/DjL5MDmsXPWXXaPTas62Tz6tqxi9Dh+YzuTx+dNcgGsUVw2
	Kak5mWWpRfp2CVwZXfulCy5yVHzvvsfcwLiMvYuRk0NCwERi8/sHULaYxIV769m6GLk4hASW
	MUr075vCCFPUcOAbC0RiEaPE19NtrBDOL0aJs++WsYBUsQmoSXz5chhoFAeHiICqxP9X7iBh
	ZoG1jBJzur1BbCEBW4k558+CDeUUsJO4s6GVEaRcWMBd4uNDf5AwC1Dn02Xb2EBsXqDySVu3
	MkPYghI/Jt9jgRipJbF+53EmCFteYvOat8wgYyQE1CUe/dUFCYsIGEksf/+eHaJERGLfi3eM
	IBdLCDxil5i+fTYTxC4BiW+TD7FA9MpKbDrADPGupMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUC
	RpZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCHxOnEH4/0D1ocYk4HWT2SWEk3OB8Z7Xkm8
	obGZkYWpiamxkbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYV22bwLeg
	NrhioczVwBtuic2OWmYHfbf/3h27WMzKdUtvykyfJENrVhFVW28l27lqV2fv5XmusMJs4Snv
	fZMvvzfiEwrX28x7MOZQUaDL8sDQpNRJZzlZlms/yQ//1nct4/ONjuBVqlGHr7Nop8xnCDvo
	W2PdOav2muVMzTORP/VLTq1Y9aBYiaU4I9FQi7moOBEArg0Mc+0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAd0bZzyCDJpnmllMnbydzWLqwyds
	FpcXXmK1+Halg8ni8q45bBZvfpxlcmDz2DnrLrvHplWdbB59W1Yxehy/sZ3J4/MmuQDWqAZG
	m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygE5QUyhJz
	SoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGV37pQsuclR8777H3MC4jL2LkZND
	QsBEouHANxYIW0ziwr31bF2MXBxCAosYJb6ebmOFcH4xSpx9twysik1ATeLLl8NA3RwcIgKq
	Ev9fuYOEmQXWMkrM6fYGsYUEbCXmnD/LCGJzCthJ3NnQyghSLizgLvHxoT9ImAWo8+mybWwg
	Ni9Q+aStW5khbEGJH5PvsUCM1JJYv/M4E4QtL7F5zVtmkDESAuoSj/7qgoRFBIwklr9/zw5R
	IiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4
	GTyT3sG4qsHiEKMAB6MSD6/FUo8gIdbEsuLK3EOMEhzMSiK8y5OAQrwpiZVVqUX58UWlOanF
	hxiTgR6dyCwlmpwPTFR5JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnC
	xMEp1cBoGFNq3hbyKTTlmvvZy/FzXwfdMd81/b9MSMtFKSZGgZeBBhK78ueYyuWJPiiScNQ+
	dqAouu/ggVxuHpuCu4Xfv55/2TXl3VIFz3p5meeXs63XZrwUvZjG6vgswuqGtPiM7dObzyQf
	LXWZuKAqoU7uy5NjAfwl10tZpq+TTU44v29+SsKrjtVKLMUZiYZazEXFiQDFtiyuSgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Nishanth Menon <nm@ti.com>
---
 drivers/regulator/twl-regulator.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 78aae4c..8ebd785 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1188,7 +1188,7 @@ static int twlreg_probe(struct platform_device *pdev)
 	config.driver_data = info;
 	config.of_node = pdev->dev.of_node;
 
-	rdev = regulator_register(&info->desc, &config);
+	rdev = devm_regulator_register(&pdev->dev, &info->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "can't register %s, %ld\n",
 				info->desc.name, PTR_ERR(rdev));
@@ -1217,7 +1217,6 @@ static int twlreg_remove(struct platform_device *pdev)
 	struct regulator_dev *rdev = platform_get_drvdata(pdev);
 	struct twlreg_info *info = rdev->reg_data;
 
-	regulator_unregister(rdev);
 	kfree(info);
 	return 0;
 }
-- 
1.7.10.4


