Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3IZHs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:48:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44914 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab3IZHsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:48:25 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-53-5243e6c8e2ae
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Krystian Garbaciak'" <krystian.garbaciak@diasemi.com>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
In-reply-to: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
Subject: [PATCH V3 03/14] regulator: da9063: use devm_regulator_register()
Date: Thu, 26 Sep 2013 16:48:23 +0900
Message-id: <003301ceba8c$c71716d0$55454470$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jIjCzH3ID+v5Qym5l1DxbvczrwAACT1Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zQ90Tz5yDDL7PYbeY+vAJm8WzW3uZ
	LC4vvMRqceTxZzaLb1c6gNxdc9gc2DxWfNL32DnrLrvHplWdbB6HDncwevRtWcXo8XmTXABb
	FJdNSmpOZllqkb5dAlfG/n6DgrsCFV+fXmFsYLzF28XIySEhYCKx7P9NFghbTOLCvfVsXYxc
	HEICyxgl/p/+wNzFyAFW1L+eEyI+nVHi54nNjBDOL0aJ/q3fmUG62QTUJL58OcwO0iAioCrx
	/5U7SA2zwFVGiRPPtoHVCAnYSjR++wu2jVPATmLW/pNgcWEBL4kNc/eygdgsQL2TLs0Fq+EF
	ql/SNYkNwhaU+DH5HlicWUBLYv3O40wQtrzE5jVvoQ5Vl3j0VxfiBCOJM/u4ICpEJPa9eAd2
	soTAI3aJh+c/s0KsEpD4NvkQC0SrrMSmA8yQcJCUOLjiBssERolZSBbPQrJ4FpLFs5CsWMDI
	sopRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjJG4n7GC8d8D6EGMy0PqJzFKiyfnAuM8riTc0
	NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6ON4XLtqpkJ
	N9g/PLCt5vxi3fGO0adAyqJPUjKs/Z13dX7Pn2d84ntOWMeEmmmL3WzUWfw91KP9b/vC0sC3
	btdnhC+Zl/S4pfTLRgFLx6iXSU/c6y+WLF2ZzPa1wkD94J/NPWZTih2dpzvYu613M12XO8dv
	DdMiwz+soXMdt7jJCK9InCyapcRSnJFoqMVcVJwIAOkDmrjxAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jQd0Tz5yDDN69YbKY+vAJm8WzW3uZ
	LC4vvMRqceTxZzaLb1c6gNxdc9gc2DxWfNL32DnrLrvHplWdbB6HDncwevRtWcXo8XmTXABb
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QGUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjP39BgV3BSq+Pr3C2MB4i7eL
	kYNDQsBEon89ZxcjJ5ApJnHh3nq2LkYuDiGB6YwSP09sZoRwfjFK9G/9zgxSxSagJvHly2F2
	kGYRAVWJ/6/cQWqYBa4ySpx4tg2sRkjAVqLx218WEJtTwE5i1v6TYHFhAS+JDXP3soHYLEC9
	ky7NBavhBapf0jWJDcIWlPgx+R5YnFlAS2L9zuNMELa8xOY1b5khjlaXePRXF+IEI4kz+7gg
	KkQk9r14xziBUWgWkkGzkAyahWTQLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIE
	J4Vn0jsYVzVYHGIU4GBU4uG9wOwcJMSaWFZcmXuIUYKDWUmE95sRUIg3JbGyKrUoP76oNCe1
	+BBjMtCfE5mlRJPzgQkrryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBb
	mDg4pRoYLUN0Fuq9StBZuEmbNXMPu47GDKmWr7VTH26XC7m4/5HcS53j0xr+qZvazvm889p+
	h7NpQZ9cr0Rf1IpMfMGxpIp5398P22TtIj9mzX6ntW6BY9IbFbZ5HRcP93QXOUyzNv8mkL49
	3NXZV18tyOu77M+E2ilupwoO/RV03mRzbNohk9jE/gRxJZbijERDLeai4kQAwBZOeE4DAAA=
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


