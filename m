Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3IZCEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:04:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20928 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3IZCET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:04:19 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-ca-52439622bc8c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 03/18] regulator: da9063: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:04:18 +0900
Message-id: <000901ceba5c$b56e10d0$204a3270$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAADQpg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zI12lac5BBv/fK1usf3CMyWLqwyds
	FpcXXmK1+Halg8ni8q45bA6sHjtn3WX32LSqk82jb8sqRo/vS9ewe3zeJBfAGsVlk5Kak1mW
	WqRvl8CVsb/foOCuQMXXp1cYGxhv8XYxcnJICJhIHDq5gxnCFpO4cG89WxcjF4eQwDJGiX1b
	NjJ2MXKAFV26XAURn84oceX1Y0YI5xejxKU7D9hAutkE1CS+fDnMDtIgIqAq8f+VO0gNs8BC
	RokpSx6AbRASsJU49fsiWD2ngJ3E6WsbWUFsYQEviRuLnrKA2CxAvd03WxlBbF6g+pu3VrJC
	2IISPybfA6thFtCSWL/zOBOELS+xec1bZohD1SUe/dUFCYsIGEnMPriHEaJERGLfi3dgN0sI
	3GOX2PH6HBvELgGJb5MPsUD0ykpsOgANCEmJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhF
	UwuSC4qT0otM9IoTc4tL89L1kvNzNzFC4nTCDsZ7B6wPMSYDrZ/ILCWanA+M87ySeENjMyML
	UxNTYyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MM7bee7NhNB5CQyT
	goQPcoZ/OSfD0ZigpH/cOy5lXWXdTn6TKubpM0Q/RR9KPyG47PTq/Zxdz80XPKlck/ygbNZ+
	4fmvXmSFpIrtYn45K3LVPh9xq7VB5Wohz6QvinfUJ/Beuhp+N8+Dt2HqqY/FBud2Wsm7Pr2l
	tlflgq5sXmS829KoyAd1i5RYijMSDbWYi4oTAQcorLDpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQV2lac5BBv9+y1usf3CMyWLqwyds
	FpcXXmK1+Halg8ni8q45bA6sHjtn3WX32LSqk82jb8sqRo/vS9ewe3zeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLG/36DgrkDF16dXGBsYb/F2MXJwSAiYSFy6
	XNXFyAlkiklcuLeerYuRi0NIYDqjxJXXjxkhnF+MEpfuPGADqWITUJP48uUwO0iziICqxP9X
	7iA1zAILGSWmLHnADFIjJGArcer3RbB6TgE7idPXNrKC2MICXhI3Fj1lAbFZgHq7b7Yygti8
	QPU3b61khbAFJX5MvgdWwyygJbF+53EmCFteYvOat8wQR6tLPPqrCxIWETCSmH1wDyNEiYjE
	vhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgJPBM
	egfjqgaLQ4wCHIxKPLwXmJ2DhFgTy4orcw8xSnAwK4nwfjMCCvGmJFZWpRblxxeV5qQWH2JM
	Bnp0IrOUaHI+MEHllcQbGpuYGVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwen
	VAOj+17xjL5j7loufIc+3P7tIvLsem6ZyYTHYSrtd+aYbnF7lGOZJ/DksWvQau6u2fqy3Dw7
	9xjV7F0duGmz4MO6u2p5yyy6bt0pKdq6geNw250pO38mHOkyld19fAfrwc2PIhcdjy7tPcJ6
	Umu/zYuGWLcfMrKWu1LifqieaeZpDWopXnppSu1UJZbijERDLeai4kQAJcbl40YDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/da9063-regulator.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index 3d910f4..56727eb 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -847,13 +847,13 @@ static int da9063_regulator_probe(struct platform_device *pdev)
 		if (da9063_reg_matches)
 			config.of_node = da9063_reg_matches[id].of_node;
 		config.regmap = da9063->regmap;
-		regl->rdev = regulator_register(&regl->desc, &config);
+		regl->rdev = devm_regulator_register(&pdev->dev, &regl->desc,
+						     &config);
 		if (IS_ERR(regl->rdev)) {
 			dev_err(&pdev->dev,
 				"Failed to register %s regulator\n",
 				regl->desc.name);
-			ret = PTR_ERR(regl->rdev);
-			goto err;
+			return PTR_ERR(regl->rdev);
 		}
 		id++;
 		n++;
@@ -862,9 +862,8 @@ static int da9063_regulator_probe(struct platform_device *pdev)
 	/* LDOs overcurrent event support */
 	irq = platform_get_irq_byname(pdev, "LDO_LIM");
 	if (irq < 0) {
-		ret = irq;
 		dev_err(&pdev->dev, "Failed to get IRQ.\n");
-		goto err;
+		return irq;
 	}
 
 	regulators->irq_ldo_lim = regmap_irq_get_virq(da9063->regmap_irq, irq);
@@ -881,27 +880,15 @@ static int da9063_regulator_probe(struct platform_device *pdev)
 	}
 
 	return 0;
-
-err:
-	/* Wind back regulators registeration */
-	while (--n >= 0)
-		regulator_unregister(regulators->regulator[n].rdev);
-
-	return ret;
 }
 
 static int da9063_regulator_remove(struct platform_device *pdev)
 {
 	struct da9063_regulators *regulators = platform_get_drvdata(pdev);
-	struct da9063_regulator *regl;
 
 	free_irq(regulators->irq_ldo_lim, regulators);
 	free_irq(regulators->irq_uvov, regulators);
 
-	for (regl = &regulators->regulator[regulators->n_regulators - 1];
-	     regl >= &regulators->regulator[0]; regl--)
-		regulator_unregister(regl->rdev);
-
 	return 0;
 }
 
-- 
1.7.10.4


