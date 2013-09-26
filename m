Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3IZHvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:51:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56747 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab3IZHvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:51:46 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-d8-5243e791f215
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
In-reply-to: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
Subject: [PATCH V3 09/14] regulator: pcap: use devm_regulator_register()
Date: Thu, 26 Sep 2013 16:51:45 +0900
Message-id: <003901ceba8d$3f1467a0$bd3d36e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jIjCzH3ID+v5Qym5l1DxbvczrwAAKhEA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zQ92Jz52DDKY+k7WY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpsDi8fOWXfZPTat6mTz6NuyitHj8ya5AJYoLpuU1JzMstQifbsErozDF3vZ
	Ctq5Kw7tm83WwDiHs4uRk0NCwETi88MmRghbTOLCvfVsXYxcHEICyxglfq85wwJT9LjlCwtE
	YhGjRNOJm8wgCSGBX4wSN+7Vg9hsAmoSX74cZu9i5OAQEVCV+P/KHcRkFsiV6N6WDlFtK9H4
	7S/YSE4BO4lZ+0+CTREW8JA4OuU4WJwFqHP2iy4mkFZeoPoTN2VBwrwCghI/Jt8DK2EW0JJY
	v/M4E4QtL7F5zVtmkHIJAXWJR391IfYbSSy9rAdRISKx78U7RpDbJQROsUvM/f6aCWKTgMS3
	yYdYIFplJTYdYIb4VVLi4IobLBMYJWYhWTwLyeJZSBbPQrJiASPLKkbR1ILkguKk9CJDveLE
	3OLSvHS95PzcTYyQaOzdwXj7gPUhxmSg9ROZpUST84HRnFcSb2hsZmRhamJqbGRuaUaasJI4
	r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxoBLcaubuRpqHJaIHD2xhtFQi+eOOZ/7
	6T2zZI/7XPz32ClasYZfb4+6eaFgabCV7PwFG2pMf3s52rPeOXI9PzojU83KePqnSyl/Ngi8
	4bpqWdI6aX3J4T2eYo9fb7X/P/mP8qydtdJcxl7t22tDHp81np989dHNfdeYK86f//dqydrP
	T7Wnn1ZiKc5INNRiLipOBADypb+J3AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd2Jz52DDFo2SVlMffiEzeLywkus
	Ft+udDBZXN41h82BxWPnrLvsHptWdbJ59G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPG4Yu9bAXt3BWH9s1ma2Ccw9nFyMkhIWAi8bjlCwuELSZx4d56
	ti5GLg4hgUWMEk0nbjKDJIQEfjFK3LhXD2KzCahJfPlymL2LkYNDREBV4v8rdxCTWSBXontb
	OkS1rUTjt79gIzkF7CRm7T8JNkVYwEPi6JTjYHEWoM7ZL7qYQFp5gepP3JQFCfMKCEr8mHwP
	rIRZQEti/c7jTBC2vMTmNW+ZQcolBNQlHv3VhdhvJLH0sh5EhYjEvhfvGCcwCs1CMmgWkkGz
	kAyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgWH8mtYNxZYPFIUYBDkYlHt4L
	zM5BQqyJZcWVuYcYJTiYlUR4vxkBhXhTEiurUovy44tKc1KLDzEmA705kVlKNDkfmIbySuIN
	jU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoGxLpDd5ecCfgX9b7MC
	zsUvm3/o9YE7l9aorVde/tz/QoHByvLkpoYDxyetdYoSFEphVN0/v3ffkbyWllcX//G0vHdU
	e+i1QtvJ+tb+LTniPXz52ct+VF/6y/ZAUmLLjuPvfkxcZ6j87N70tdsD/j2ZzaCUJ33/ys8l
	ojs+mC6wNAnv8r20fSvrOSWW4oxEQy3mouJEAMtgbbw5AwAA
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
 drivers/regulator/pcap-regulator.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/pcap-regulator.c b/drivers/regulator/pcap-regulator.c
index b49eaee..3727b7d 100644
--- a/drivers/regulator/pcap-regulator.c
+++ b/drivers/regulator/pcap-regulator.c
@@ -246,7 +246,8 @@ static int pcap_regulator_probe(struct platform_device *pdev)
 	config.init_data = dev_get_platdata(&pdev->dev);
 	config.driver_data = pcap;
 
-	rdev = regulator_register(&pcap_regulators[pdev->id], &config);
+	rdev = devm_regulator_register(&pdev->dev, &pcap_regulators[pdev->id],
+				       &config);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
@@ -255,22 +256,12 @@ static int pcap_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int pcap_regulator_remove(struct platform_device *pdev)
-{
-	struct regulator_dev *rdev = platform_get_drvdata(pdev);
-
-	regulator_unregister(rdev);
-
-	return 0;
-}
-
 static struct platform_driver pcap_regulator_driver = {
 	.driver = {
 		.name	= "pcap-regulator",
 		.owner	= THIS_MODULE,
 	},
 	.probe	= pcap_regulator_probe,
-	.remove	= pcap_regulator_remove,
 };
 
 static int __init pcap_regulator_init(void)
-- 
1.7.10.4


