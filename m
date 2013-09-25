Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3IYILZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:11:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10005 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3IYILW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:11:22 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-4d-52429aa93908
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 16/20] regulator: pcf50633: use devm_regulator_register()
Date: Wed, 25 Sep 2013 17:11:20 +0900
Message-id: <001901ceb9c6$d188f500$749adf00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAAwI+g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zI92Vs5yCDLa9ZbOY+vAJm8XlhZdY
	LZZMns9q8e1KB5PF5V1z2BxYPXbOusvusWlVJ5vHkjeHWD36tqxi9Pi8SS6ANYrLJiU1J7Ms
	tUjfLoErY8VS9YK/XBVNHz+wNzDO5Oxi5OSQEDCROPN+MguELSZx4d56ti5GLg4hgWWMEuff
	bWCEKdr8bRdUYjqjxKHNK1ghnF+MEsu7b4K1swmoSXz5cpi9i5GDQ0RAVeL/K3eQMLPAVEaJ
	7rXlILaQgK3E8r+3wco5Bewklt37zAZiCwt4ShyadwFsGQtQ6+4FP8BsXqD62W/2MUHYghI/
	Jt9jgZipJbF+53EmCFteYvOat8wgayUE1CUe/dUFCYsIGElcb/zJCFEiIrHvxTtGkJMlBG6x
	SzyfuxFql4DEt8mHWCB6ZSU2HWCG+FdS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC
	5ILipPQiY73ixNzi0rx0veT83E2MkDjt38F494D1IcZkoPUTmaVEk/OBcZ5XEm9obGZkYWpi
	amxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsaC7vRfvm+zvYI3Lpgs
	dmzV21/myt3tMV/Wc83MWLB/qtv2cp/JaeUlf0Sdtq31aDYT9Jrbn/vwoJThPrOO3RteKTfd
	z9QqMO2OtNbb+qzBVnOt03/PoJYz7Xf7L1RfrQ3xm7nz5KwE2cQiS7098z7YZbJfC6m48rq7
	ofNu6rf9PoeC15+3k1NiKc5INNRiLipOBADXgoBJ6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd2Vs5yCDL5PZraY+vAJm8XlhZdY
	LZZMns9q8e1KB5PF5V1z2BxYPXbOusvusWlVJ5vHkjeHWD36tqxi9Pi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPFUvWCv1wVTR8/sDcwzuTsYuTkkBAwkdj8
	bRcbhC0mceHeeiCbi0NIYDqjxKHNK1ghnF+MEsu7b7KAVLEJqEl8+XKYvYuRg0NEQFXi/yt3
	kDCzwFRGie615SC2kICtxPK/t8HKOQXsJJbd+wy2QFjAU+LQvAuMIDYLUOvuBT/AbF6g+tlv
	9jFB2IISPybfY4GYqSWxfudxJghbXmLzmrfMIGslBNQlHv3VBQmLCBhJXG/8yQhRIiKx78U7
	xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4CTyT2sG4
	ssHiEKMAB6MSD6/AUccgIdbEsuLK3EOMEhzMSiK8zjOcgoR4UxIrq1KL8uOLSnNSiw8xJgM9
	OpFZSjQ5H5ig8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB
	USW1tGNGcoD0JFGju+Ul6z59fPk0yD787tRw9nxVlZXae/5nPq8XyGZerJx3iJVLKynoz6dV
	76IczmzvnNlecXY6Sw+7AdOeB5P+7Gk+wdI9bU6QOc/S7tg5RzdEnPO0jE1deP2St1Jk0uuc
	xFfOC1h7W1rfeCmd820wrP+xacbtlevM3j73VmIpzkg01GIuKk4EABLJIIxGAwAA
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
 drivers/regulator/pcf50633-regulator.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 0f3576d..d7da1c1 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -90,7 +90,8 @@ static int pcf50633_regulator_probe(struct platform_device *pdev)
 	config.driver_data = pcf;
 	config.regmap = pcf->regmap;
 
-	rdev = regulator_register(&regulators[pdev->id], &config);
+	rdev = devm_regulator_register(&pdev->dev, &regulators[pdev->id],
+				       &config);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
@@ -102,21 +103,11 @@ static int pcf50633_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int pcf50633_regulator_remove(struct platform_device *pdev)
-{
-	struct regulator_dev *rdev = platform_get_drvdata(pdev);
-
-	regulator_unregister(rdev);
-
-	return 0;
-}
-
 static struct platform_driver pcf50633_regulator_driver = {
 	.driver = {
 		.name = "pcf50633-regltr",
 	},
 	.probe = pcf50633_regulator_probe,
-	.remove = pcf50633_regulator_remove,
 };
 
 static int __init pcf50633_regulator_init(void)
-- 
1.7.10.4


