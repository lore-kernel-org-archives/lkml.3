Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3IZCIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:08:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16827 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3IZCIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:08:47 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-8d-5243972eeeb5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 09/18] regulator: lp8788-buck: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:08:46 +0900
Message-id: <000f01ceba5d$550b6ca0$ff2245e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAANpKw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zI1296c5BBos3S1tMffiEzeLywkus
	Ft+udDBZXN41h81i7ZG77A6sHjtn3WX32LSqk82jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	MmZd+MJSsJWrYumRJvYGxjscXYycHBICJhJXzkxjhbDFJC7cW8/WxcjFISSwjFHi4MWXbDBF
	8x/fZodILGKUOD/9OTOE84tR4uKRy4wgVWwCahJfvhwGquLgEBFQlfj/yh2khllgHqPEh3/n
	2UFqhARsJU79vgg2lVPATuL0tY1gq4UF/CX2bP4DZrMA9U7omA1WzwtUf/DsETYIW1Dix+R7
	LCA2s4CWxPqdx5kgbHmJzWveMoPslRBQl3j0VxckLCJgJLH51gKoEhGJfS/eMYLcIyFwjV3i
	7sO3LBC7BCS+TT7EAtErK7HpADPEw5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYk
	FxQnpRcZ6xUn5haX5qXrJefnbmKERGj/Dsa7B6wPMSYDrZ/ILCWanA+M8LySeENjMyMLUxNT
	YyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MJ649XnJC4GmCepym0/s
	+DfJeLXd5K2+px75nZZ/VegtGMcVlqDzd2ZMrdn8kycb17Tdzlfm3hXUqz3f4/WXbpm9sqtO
	25ZOujTJKY3t4Y6X7ot4p+mJnjSyi9icFt4aMzlD1URgXQDD2cdrN9TONTHXaisVaN31bnUU
	h3Dj3ILcfAGuVf+uMyixFGckGmoxFxUnAgDZ192E5gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jAV296c5BBqumSVhMffiEzeLywkus
	Ft+udDBZXN41h81i7ZG77A6sHjtn3WX32LSqk82jb8sqRo/Pm+QCWKIaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYrKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwnrGDNmXfjCUrCVq2LpkSb2BsY7HF2MnBwSAiYS8x/fZoew
	xSQu3FvP1sXIxSEksIhR4vz058wQzi9GiYtHLjOCVLEJqEl8+XIYqIODQ0RAVeL/K3eQGmaB
	eYwSH/6dB5skJGArcer3RTYQm1PATuL0tY2sILawgL/Ens1/wGwWoN4JHbPB6nmB6g+ePcIG
	YQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aQvRIC6hKP/uqChEUEjCQ231oAVSIise/FO8YJ
	jEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOP6fSe1gXNlg
	cYhRgINRiYf3ArNzkBBrYllxZe4hRgkOZiUR3m9GQCHelMTKqtSi/Pii0pzU4kOMyUCPTmSW
	Ek3OB6amvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgXCGg
	sv4Uo+WnxYyxUdHM6ldVvYIu9B3ySxLzDHJebRmyNSczv9ZkWdkZN+Ft/2r6p/7K3Xvt+mq2
	xzO+SV5vPKrQdvnT/N6kznshOq+1Wq/sOuvy9kjJb9Gl76xKbr9gL51+5+ijiL/sZTZ/39T5
	/N94580b78hv1r0cJkJasyvLjzR0Tt68T4mlOCPRUIu5qDgRANeknVhDAwAA
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
 drivers/regulator/lp8788-buck.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/regulator/lp8788-buck.c b/drivers/regulator/lp8788-buck.c
index 0b015f2..948afc2 100644
--- a/drivers/regulator/lp8788-buck.c
+++ b/drivers/regulator/lp8788-buck.c
@@ -515,7 +515,7 @@ static int lp8788_buck_probe(struct platform_device *pdev)
 	cfg.driver_data = buck;
 	cfg.regmap = lp->regmap;
 
-	rdev = regulator_register(&lp8788_buck_desc[id], &cfg);
+	rdev = devm_regulator_register(&pdev->dev, &lp8788_buck_desc[id], &cfg);
 	if (IS_ERR(rdev)) {
 		ret = PTR_ERR(rdev);
 		dev_err(&pdev->dev, "BUCK%d regulator register err = %d\n",
@@ -529,18 +529,8 @@ static int lp8788_buck_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int lp8788_buck_remove(struct platform_device *pdev)
-{
-	struct lp8788_buck *buck = platform_get_drvdata(pdev);
-
-	regulator_unregister(buck->regulator);
-
-	return 0;
-}
-
 static struct platform_driver lp8788_buck_driver = {
 	.probe = lp8788_buck_probe,
-	.remove = lp8788_buck_remove,
 	.driver = {
 		.name = LP8788_DEV_BUCK,
 		.owner = THIS_MODULE,
-- 
1.7.10.4


