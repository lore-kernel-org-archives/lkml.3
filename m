Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab3IZCL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:11:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22384 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab3IZCL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:11:27 -0400
X-AuditID: cbfee68e-b7f756d000004512-19-524397ce56a3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'MyungJoo Ham'" <myungjoo.ham@samsung.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 14/18] regulator: pcf50633: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:11:26 +0900
Message-id: <001401ceba5d$b494f970$1dbeec50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAATrRw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t8zY91z052DDL5eV7eY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF7cYVbA6sHjtn3WX32LSqk82jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	MlYsVS/4y1XR9PEDewPjTM4uRk4OCQETiZNdE1ghbDGJC/fWs3UxcnEICSxjlLh/awlzFyMH
	WNHHB5EQ8UWMEuemzwdrEBL4xSixfx87iM0moCbx5cthdpB6EQFVif+v3EHCzAIzGCU+vNGB
	KLeVOPX7IhuIzSlgJ3H62kawMcICPhLvTp0Ci7MAtT75OB/M5gWqP9GzFsoWlPgx+R4LxEwt
	ifU7jzNB2PISm9e8hTpTXeLRX12QsIiAkcTJy4+ZIUpEJPa9eMcIcr6EwDl2iRMfdkHtEpD4
	NvkQC0SvrMSmA8yQYJCUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3ISK84
	Mbe4NC9dLzk/dxMjJDL7djDePGB9iDEZaP1EZinR5HxgZOeVxBsamxlZmJqYGhuZW5qRJqwk
	zqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXFWQwHbed6Ox3JNrNuaWlf9n2dneu47
	S+CCm0/Vt1yvPZ99daKQkVDHnfmvH/Ot3eqmwvzE4YCA5qRdk/dLte95bnVHwmhxX2ZEbvBL
	g3tPZ2UtZfnU11Nw/PJzp+kv3i35mMjh9fa9p3f4Q94LrT8de7QuF88WuM31+VPMSvPA3wcv
	pkZpVfEpsRRnJBpqMRcVJwIAdrbJL+ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jAd1z052DDO6/ULaY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF7cYVbA6sHjtn3WX32LSqk82jb8sqRo/Pm+QCWKIaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYrKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwnrGDNWLFUv+MtV0fTxA3sD40zOLkYODgkBE4mPDyK7GDmB
	TDGJC/fWs3UxcnEICSxilDg3fT4rSEJI4BejxP597CA2m4CaxJcvh9lBekUEVCX+v3IHCTML
	zGCU+PBGB6LcVuLU74tsIDangJ3E6WsbwcYIC/hIvDt1CizOAtT65ON8MJsXqP5Ez1ooW1Di
	x+R7LBAztSTW7zzOBGHLS2xe85YZ4mR1iUd/dUHCIgJGEicvP2aGKBGR2PfiHeMERqFZSCbN
	QjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHPfPpHYwrmywOMQowMGo
	xMN7gdk5SIg1say4MvcQowQHs5II7zcjoBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJLiSbnA1NS
	Xkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwageYyG43Cr4/
	n23ljh9+1lzH91xQcK27kv+1YPqbLReWnOdN2m8X0LFhUvyNDctPrmwM7t83W3Zj7azS8wVT
	zi255fWHRcT24+nNO1TnanR2hm5j5gmdZmzW4i1gZdFt8+z+3qXMygfsSrr6ZLLjRFdumXZE
	WXr3mfPr9StYlZ4kv5xqu+FGvBJLcUaioRZzUXEiAG7au8I/AwAA
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


