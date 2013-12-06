Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab3LFHJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:09:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:15623 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab3LFHJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:09:33 -0500
X-AuditID: cbfee68f-b7f256d000003c1b-96-52a1782a433e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
In-reply-to: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
Subject: [PATCH 3/6] regulator: fixed: use devm_regulator_register()
Date: Fri, 06 Dec 2013 16:09:29 +0900
Message-id: <000c01cef252$1b341040$519c30c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7yUb+lAqO9MkXdRJaD6VTAoDhw9gAAD2hQ
Content-language: ko
x-cr-hashedpuzzle: A9I+ BbPS C5Dx FwHM LbmZ M8vX Tq6L VmmJ a7fW fJPM ffPR id68
 i/WT nJvb pmzO
 rHX8;4;YgByAG8AbwBuAGkAZQBAAGsAZQByAG4AZQBsAC4AbwByAGcAOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABnAGkAcgBkAHcAbwBvAGQAQABnAG0AYQBpAGwALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{179D4714-B600-4A38-AF57-1147BDF09400};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Fri,
 06 Dec 2013 07:09:23
 GMT;WwBQAEEAVABDAEgAIAAzAC8ANgBdACAAcgBlAGcAdQBsAGEAdABvAHIAOgAgAGYAaQB4AGUAZAA6ACAAdQBzAGUAIABkAGUAdgBtAF8AcgBlAGcAdQBsAGEAdABvAHIAXwByAGUAZwBpAHMAdABlAHIAKAApAA==
x-cr-puzzleid: {179D4714-B600-4A38-AF57-1147BDF09400}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zI12tioVBBtf/iFlMffiEzeLywkus
	Ft+udDBZXN41h82BxWPnrLvsHptWdbJ59G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8a6lU/Z
	C05xVLxatom5gXERexcjJ4eEgInEgvNdULaYxIV769m6GLk4hASWMUr0X1jNDFO0++p+qMR0
	Rone51+hnF+MEst2bAOrYhNQk/jy5TDQKA4OEQFVif+v3EFMZoFcie5t6SCmkICtxKr71SDF
	nAJ2En+OvgFrFBZwkbi++wwbiM0C1Di1ezFYnBeovGvRVSYIW1Dix+R7LCA2s4CWxPqdx5kg
	bHmJzWveMoOMlxBQl3j0VxckLCJgJPH/+A1GiBIRiX0v3jFCfPKHRWLlnnoI21Si78ENVpBH
	JAQesUu8f3OTCeIGAYlvkw+xQMyUldh0ABoKkhIHV9xgmcAoNQvJRbOQXDQLyUWzkKxewMiy
	ilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMkgvt3MN49YH2IMRlo/URmKdHkfGACyCuJNzQ2
	M7IwNTE1NjK3NCNNWEmc9/7DpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjL6OJx/M3N0m
	sHS3WYOwYJzIbr9ThxodH65+deHZ4muKQl8PLL9kcE7K/ffGKVUx3OfvdT5euUggwm6FlP4i
	5cjwBe7/pAQa3xwXvbn2lPZ3xwVsFZtk7yvs6tzzOeaP4aX8xPzMgwqXDwRdm2ZVvzW964vw
	kw6n8xd07jnaXEt9Mcns05wqySNKLMUZiYZazEXFiQB8WtnT9gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jQV2tioVBBnvnCFtMffiEzeLywkus
	Ft+udDBZXN41h82BxWPnrLvsHptWdbJ59G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPGupVP2QtOcVS8WraJuYFxEXsXIyeHhICJxO6r+9kgbDGJC/fW
	A9lcHEIC0xklep9/hXJ+MUos27GNGaSKTUBN4suXw0DdHBwiAqoS/1+5g5jMArkS3dvSQUwh
	AVuJVferQYo5Bewk/hx9A9YoLOAicX33GbBVLECNU7sXg8V5gcq7Fl1lgrAFJX5MvscCYjML
	aEms33mcCcKWl9i85i0zyHgJAXWJR391QcIiAkYS/4/fYIQoEZHY9+IdI8Qnf1gkVu6ph7BN
	Jfoe3GCdwCgyC8mGWUg2zEKyYRaSUQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBKeH
	Z1I7GFc2WBxiFOBgVOLh5Vi1IEiINbGsuDL3EKMEB7OSCG+P+MIgId6UxMqq1KL8+KLSnNTi
	Q4zJwACYyCwlmpwPTF15JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnC
	xMEp1cDoeE5lvtXbDS/1l4fMd/5cd22m8PVtie/euumcmOty9VWfaWHAuV3Fp7xOSq5eb8ll
	KXzzlr5ERiO3UGrH6Z9Orl5dIt/O7P4r1Tu3aV7MoWKtwNMyLl8aw0L68ri27284JWRkerPK
	a/4CzzffGCynPVKe9HCZ8hzLi64fH/X7P828eV9oReonJZbijERDLeai4kQAiNt20VMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/fixed.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 5ea64b9..f45cc1ac 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -186,7 +186,8 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	cfg.driver_data = drvdata;
 	cfg.of_node = pdev->dev.of_node;
 
-	drvdata->dev = regulator_register(&drvdata->desc, &cfg);
+	drvdata->dev = devm_regulator_register(&pdev->dev, &drvdata->desc,
+						&cfg);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
@@ -212,7 +213,6 @@ static int reg_fixed_voltage_remove(struct platform_device *pdev)
 {
 	struct fixed_voltage_data *drvdata = platform_get_drvdata(pdev);
 
-	regulator_unregister(drvdata->dev);
 	kfree(drvdata->desc.supply_name);
 	kfree(drvdata->desc.name);
 
-- 
1.7.10.4


