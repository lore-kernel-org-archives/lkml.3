Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab3IZCNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:13:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45189 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3IZCNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:13:43 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-7d-5243985555a6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@linaro.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Pawel Moll'" <pawel.moll@arm.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 18/18] regulator: vexpress: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:13:41 +0900
Message-id: <001801ceba5e$04fa2e80$0eee8b80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAYm6A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ93QGc5BBqvOGFpsun6d1eLywkus
	Ft+udDBZXN41h81iwvS1LA6sHmvmrWH02DnrLrvHnWt72Dz6tqxi9Pi8SS6ANYrLJiU1J7Ms
	tUjfLoErY97HeSwFBzkqVr54zNrAOJ+9i5GTQ0LARKLr3AVGCFtM4sK99WxdjFwcQgLLGCX6
	Vx5lgym6/OMoK0RiOqPEtukHGSGcX4wSVy9uBatiE1CT+PLlMNhYEQFViT3Pn4DZzAITGCVe
	PLEEsYUEbCVO/b4IVs8pYCdx+tpGoKkcHMICPhIzXoCVswC1nly5hh0kzAtU/u2WKkiYV0BQ
	4sfkeywQE7Uk1u88zgRhy0tsXvOWGaRcQkBd4tFfXYgDjCSaL/ZBlYhI7HvxDuxiCYFr7BKf
	p/6GWiUg8W3yIRaIXlmJTQeYId6VlDi44gYL0NmzkGyehWTzLCSbZyFZsYCRZRWjaGpBckFx
	UnqRqV5xYm5xaV66XnJ+7iZGSJxO3MF4/4D1IcZkoPUTmaVEk/OBcZ5XEm9obGZkYWpiamxk
	bmlGmrCSOK96i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkb9ktsXbN8ecfS7uHnWzXV7
	dAuf/th3qfre7uJKn1sTL8tu6lXSzrKIav/ZekPWM2Hz1+msXkb7gnXLFGbwdy52SHrJWNvY
	rMIXsWX7Jd6cE9cCPsxRcGwPNA+c+p9Rah73Yf5rtXtPpda7iv2dOu3KrOJsmddljPfczvy4
	9z+eWfCB0I6eCBUlluKMREMt5qLiRABmTWEB6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd3QGc5BBn8a9Sw2Xb/OanF54SVW
	i29XOpgsLu+aw2YxYfpaFgdWjzXz1jB67Jx1l93jzrU9bB59W1YxenzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDHv4zyWgoMcFStfPGZtYJzP3sXIySEhYCJx
	+cdRVghbTOLCvfVsXYxcHEIC0xkltk0/yAjh/GKUuHpxKxtIFZuAmsSXL4fBukUEVCX2PH8C
	ZjMLTGCUePHEEsQWErCVOPX7Ilg9p4CdxOlrG4E2cHAIC/hIzHgBVs4C1Hpy5Rp2kDAvUPm3
	W6ogYV4BQYkfk++xQEzUkli/8zgThC0vsXnNW2aQcgkBdYlHf3UhDjCSaL7YB1UiIrHvxTvG
	CYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgJPJPewbiq
	weIQowAHoxIP7wVm5yAh1sSy4srcQ4wSHMxKIrzfjIBCvCmJlVWpRfnxRaU5qcWHGJOB/pzI
	LCWanA9MUHkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwDjx
	HkuYQ2V+XI/FLhef5WxHG47ZJyeJ5aSt7L66++QG00mWK5cv/mXD+n17Xfq7NP41tge0PC83
	hudutPbIq3mvVZkUrDpFJc7sia36Nv+wopRlLlNiIxcxSqv+fDKn/10Mk3bcTomJvAUH1nY8
	8Od3ajk5z+2x0/uCd8db+b5+vbVRe0PVVSWW4oxEQy3mouJEAEgVa8hGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/regulator/vexpress.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/vexpress.c b/drivers/regulator/vexpress.c
index 4668c7f..f3ae28a 100644
--- a/drivers/regulator/vexpress.c
+++ b/drivers/regulator/vexpress.c
@@ -96,7 +96,7 @@ static int vexpress_regulator_probe(struct platform_device *pdev)
 	config.driver_data = reg;
 	config.of_node = pdev->dev.of_node;
 
-	reg->regdev = regulator_register(&reg->desc, &config);
+	reg->regdev = devm_regulator_register(&pdev->dev, &reg->desc, &config);
 	if (IS_ERR(reg->regdev)) {
 		err = PTR_ERR(reg->regdev);
 		goto error_regulator_register;
@@ -119,7 +119,6 @@ static int vexpress_regulator_remove(struct platform_device *pdev)
 	struct vexpress_regulator *reg = platform_get_drvdata(pdev);
 
 	vexpress_config_func_put(reg->func);
-	regulator_unregister(reg->regdev);
 
 	return 0;
 }
-- 
1.7.10.4


