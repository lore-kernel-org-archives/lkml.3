Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab3IZHwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:52:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30097 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab3IZHwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:52:12 -0400
X-AuditID: cbfee68e-b7f756d000004512-72-5243e7aa41f6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
In-reply-to: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
Subject: [PATCH V3 10/14] regulator: pcf50633: use devm_regulator_register()
Date: Thu, 26 Sep 2013 16:52:10 +0900
Message-id: <003a01ceba8d$4e4c2050$eae460f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jIjCzH3ID+v5Qym5l1DxbvczrwAALdjQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zfd1Vz52DDM5vtLaY+vAJm8XlhZdY
	LZZMns9q8e1KB5PF5V1z2BxYPXbOusvusWlVJ5vHkjeHWD36tqxi9Pi8SS6ANYrLJiU1J7Ms
	tUjfLoErY8VS9YK/XBVNHz+wNzDO5Oxi5OSQEDCRaDn3kg3CFpO4cG89kM3FISSwjFHiyqYV
	jDBFO9++Y4dITGeUeLXsLyuE84tR4t/x4ywgVWwCahJfvhwGquLgEBFQlfj/yh0kzCwwlVGi
	e205iC0kYCvR+O0vWDmngJ3ErP0nmUFsYQEfibXzr4BdwQLUeq2lC2wxL1D9ketXoWxBiR+T
	77FAzNSSWL/zOBOELS+xec1bZpC1EgLqEo/+6oKERQSMJLacvcIOUSIise/FO0aQkyUEbrFL
	nH37hhlil4DEt8mHWCB6ZSU2HWCG+FdS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC
	5ILipPQiI73ixNzi0rx0veT83E2MkDjt28F484D1IcZkoPUTmaVEk/OBcZ5XEm9obGZkYWpi
	amxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkYDxj1u286xOk8rDWtf
	e8L4kVdvLdPX2Zf4PkVeuzBtUW1XyJpfWwSle7RNDv3genPhgcKSSd0HnvwRYJybVarHtVTB
	SDglS8Y0+Jir8VrDL5sz/1mLJh9If1x3/kTf+XCvZ4KGm65PFk26dCz+fYjdAu/8PoGDtbGP
	5318+uTMnVAuERt/3YVKLMUZiYZazEXFiQAtWYme6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd1Vz52DDL6vMreY+vAJm8XlhZdY
	LZZMns9q8e1KB5PF5V1z2BxYPXbOusvusWlVJ5vHkjeHWD36tqxi9Pi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPFUvWCv1wVTR8/sDcwzuTsYuTkkBAwkdj5
	9h07hC0mceHeerYuRi4OIYHpjBKvlv1lhXB+MUr8O36cBaSKTUBN4suXw0AdHBwiAqoS/1+5
	g4SZBaYySnSvLQexhQRsJRq//QUr5xSwk5i1/yQziC0s4COxdv4VNhCbBaj1WksXI4jNC1R/
	5PpVKFtQ4sfkeywQM7Uk1u88zgRhy0tsXvOWGWSthIC6xKO/uiBhEQEjiS1nr7BDlIhI7Hvx
	jnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQITgLPpHcw
	rmqwOMQowMGoxMN7gdk5SIg1say4MvcQowQHs5II7zcjoBBvSmJlVWpRfnxRaU5q8SHGZKBH
	JzJLiSbnAxNUXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUw
	+v55IJM4d/HD/EefCibMnKAnfqEkXUvhc8mhX6/PGAXrye6QqGXTm371+Aee6xcnm6/8X6kp
	7PPKWvzs9TN8oXNMitYmLReQ2vA764wuw+wNhttubrJrX87JnJFua3RWvvX6rJsbvrJzpUvU
	tpqGShszTizjNPL4b8L/7d+iKU9aX64qYMi5o8RSnJFoqMVcVJwIAH3d6kVGAwAA
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


