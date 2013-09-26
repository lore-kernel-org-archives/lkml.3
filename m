Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab3IZH5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:57:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29153 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3IZH5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:57:22 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-f1-5243e8e142ee
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Milo Kim'" <milo.kim@ti.com>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
In-reply-to: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
Subject: [PATCH V3 07/14] regulator: lp8788-ldo: use devm_regulator_register()
Date: Thu, 26 Sep 2013 16:57:20 +0900
Message-id: <003f01ceba8e$07402610$15c07230$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jIjCzH3ID+v5Qym5l1DxbvczrwAAULhA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zI92HL5yDDGatULWY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF8l/rWBxYPXbOusvusWlVJ5tH35ZVjB7Hb2xn8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY2m/WcEMwYrrrY1MDYzL+boYOTkkBEwkOn++YIKwxSQu3FvP1sXIxSEksIxR4vqG
	aUwwRdsuTWSGSCxilHg74SSU84tRYuakU+wgVWwCahJfvhwGsjk4RARUJf6/cgepYRboZpS4
	uuwzWI2QgK1E47e/LCA2p4CdxKz9IIM4OYQF/CTure1lA7FZgHoXLtjOCmLzAtWvO3GIEcIW
	lPgx+R5YL7OAlsT6nceZIGx5ic1r3jKD7JUQUJd49FcX4gQjibXzNCEqRCT2vXjHCPHLNXaJ
	98+kITYJSHybfIgFolNWYtMBZogSSYmDK26wTGCUmIVk7ywke2ch2TsLyYYFjCyrGEVTC5IL
	ipPSiwz1ihNzi0vz0vWS83M3MUKitHcH4+0D1ocYk4HWT2SWEk3OB0Z5Xkm8obGZkYWpiamx
	kbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYM28+9C3g1c9l0/+89VxE
	aEzJl4j586Z83Pyl2HkHY8+l5MsWc/5znVftP192Ld73qZomq6e7G+/uiJvCP4vtBfL0Jgim
	5b7XETYJvueyNsNq8vlYnZXlrxwkWlQiElszYnVrw3xi2lcpcXZNZ/wXfaZDy+28xo1Xc1xK
	M5NX7L+Y4c5uMEuJpTgj0VCLuag4EQAIYixl6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd2HL5yDDP5PULSY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF8l/rWBxYPXbOusvusWlVJ5tH35ZVjB7Hb2xn8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWNpv1nBDMGK662NTA2My/m6GDk5JARMJLZd
	msgMYYtJXLi3nq2LkYtDSGARo8TbCSeZIZxfjBIzJ51iB6liE1CT+PLlMJDNwSEioCrx/5U7
	SA2zQDejxNVln8FqhARsJRq//WUBsTkF7CRm7T8JtkFYwE/i3tpeNhCbBah34YLtrCA2L1D9
	uhOHGCFsQYkfk++B9TILaEms33mcCcKWl9i85i0zyF4JAXWJR391IU4wklg7TxOiQkRi34t3
	jBMYhWYhGTQLyaBZSAbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwEngmtYNx
	ZYPFIUYBDkYlHt4LzM5BQqyJZcWVuYcYJTiYlUR4vxkBhXhTEiurUovy44tKc1KLDzEmA/05
	kVlKNDkfmKDySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoFR
	KaZEhfG/a0SF5cwf2bWeM6KK3zd7xEWZn5WYl5mjnvVXXOow3wtd70MV/c/F7u/fzHTSRimP
	f0nx/wbNp+6habn5EQYNup4SOjWMYh3nVjTuYi9TKLvWt9D8wNWj3HKXNc8X3gxWOnp07qLA
	2N1ugpyNLMsmfly8VuyMm87M7ue8HeUntJRYijMSDbWYi4oTAfF8VH9GAwAA
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


