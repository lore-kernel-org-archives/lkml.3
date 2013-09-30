Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3I3AxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:53:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21055 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab3I3AxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:53:10 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-58-5248cb758f46
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Krystian Garbaciak'" <krystian.garbaciak@diasemi.com>
References: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
In-reply-to: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
Subject: [PATCH V4 03/14] regulator: da9063: use devm_regulator_register()
Date: Mon, 30 Sep 2013 09:53:09 +0900
Message-id: <007601cebd77$6e616e80$4b244b80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac69dwY7qCw/SuPGSmKRawAumfnevwAAFJ0w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zI93S0x5BBpuPi1pMffiEzeLZrb1M
	FpcXXmK1OPL4M5vFtysdQO6uOWwObB4rPul77Jx1l91j06pONo9DhzsYPfq2rGL0+LxJLoAt
	issmJTUnsyy1SN8ugStjf79BwV2Biq9PrzA2MN7i7WLk5JAQMJF4d7mXFcIWk7hwbz1bFyMX
	h5DAMkaJzVcnsMIUfVu4jhEiMZ1R4uTVW1BVvxgl9h6ZzwJSxSagJvHly2H2LkYODhEBVYn/
	r9xBapgFrjJKnHi2jRmkRkjAVmLO+bOMIDangJ3EnQ2tYLawgJfE1g97mEBsFqDeZ22P2EBs
	XqD6hsvNTBC2oMSPyffAdjELaEms33mcCcKWl9i85i0zyF4JAXWJR391QcIiAkYSD2b3MkOU
	iEjse/EO7AEJgbfsEk0/LzBC7BKQ+Db5EAtEr6zEpgPMEA9LShxccYNlAqPELCSbZyHZPAvJ
	5llIVixgZFnFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJERK7vTsYbx+wPsSYDLR+IrOUaHI+
	MPbzSuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDI
	8eGAV2x6jtzyn68Ki4T1jG5NUU+6fulX1l8BVf1VeXw8nW9WVtYYTfqzaLJuSeuLONtrAoUz
	5jeUK24zP53u2PfA2PPKkgrr9bb7l5U/v7u2YbamlKfF3D1MGyZPuGWcuUb7UWDKkp1q3FG/
	Dk1fd2L6D+G1Xb13Nn2axhWuJd2YtsmKe4m3EktxRqKhFnNRcSIACQAlyfMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQd3S0x5BBhuOCVpMffiEzeLZrb1M
	FpcXXmK1OPL4M5vFtysdQO6uOWwObB4rPul77Jx1l91j06pONo9DhzsYPfq2rGL0+LxJLoAt
	qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoDCWF
	ssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxv5+g4K7AhVfn15hbGC8xdvF
	yMkhIWAi8W3hOkYIW0ziwr31bF2MXBxCAtMZJU5evQXl/GKU2HtkPgtIFZuAmsSXL4fZuxg5
	OEQEVCX+v3IHqWEWuMooceLZNmaQGiEBW4k558+CTeUUsJO4s6EVzBYW8JLY+mEPE4jNAtT7
	rO0RG4jNC1TfcLmZCcIWlPgx+R7YLmYBLYn1O48zQdjyEpvXvGUG2SshoC7x6K8uSFhEwEji
	wexeZogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ
	+bmbGMGJ4ZnUDsaVDRaHGAU4GJV4eCcs9wgSYk0sK67MPcQowcGsJMK7PAkoxJuSWFmVWpQf
	X1Sak1p8iDEZ6NGJzFKiyfnApJVXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTU
	gtQimC1MHJxSDYxOl6bLPQqbYnSrSM1KuJT/M9OUwKpq5oROjZVnfyw4ZMnsensy9/ofwfsf
	ZTr9XXsyOl/gHfOvS7L9PQevzfqgqKJvsHXPlaNeD6Rmxzpc+rXJY9HmGRffTbm2mOsds2eU
	hNp1e062ia0lmX9aE5U0lgi/CF0gFuLKfXcXc96vOKNzRjfkLzgpsRRnJBpqMRcVJwIA7jP4
	alADAAA=
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


