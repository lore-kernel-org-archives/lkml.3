Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3IZHy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:54:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:46480 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab3IZHy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:54:28 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-e2-5243e832cac2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Pawel Moll'" <pawel.moll@arm.com>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
In-reply-to: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
Subject: [PATCH V3 14/14] regulator: vexpress: use devm_regulator_register()
Date: Thu, 26 Sep 2013 16:54:26 +0900
Message-id: <003e01ceba8d$9f3db6e0$ddb924a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jIjCzH3ID+v5Qym5l1DxbvczrwAAQdhA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zI12jF85BBttv6VtMffiEzeLywkus
	Ft+udDBZXN41h81iwvS1LA6sHmvmrWH02DnrLrvHplWdbB59W1YxenzeJBfAGsVlk5Kak1mW
	WqRvl8CVMe/jPJaCgxwVK188Zm1gnM/excjJISFgIvHlzwxWCFtM4sK99WxdjFwcQgLLGCX2
	b5oEV7Rw3zWoxHRGiYUP1kA5vxglrr+YzwZSxSagJvHly2GgDg4OEQFVif+v3EHCzAITGCVe
	PLEEsYUEbCUav/1lAbE5BewkZu0/yQxiCwv4SLx7dQgszgLU+uXsCbA4L1D9n+3LWSFsQYkf
	k++xQMzUkli/8zgThC0vsXnNW2aQtRIC6hKP/uqChEUEjCSOvtzBDFEiIrHvxTtGkJMlBG6x
	S5ybtZYVYpeAxLfJIHtBemUlNh1ghvhXUuLgihssQIfPQrJ5FpLNs5BsnoVkxQJGllWMoqkF
	yQXFSelFhnrFibnFpXnpesn5uZsYIZHau4Px9gHrQ4zJQOsnMkuJJucDIz2vJN7Q2MzIwtTE
	1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzT5H/Z/svgtlNJkz/v
	Fft9ZcCX5ykfm5eqyS/78OQdZ1N+3KO4Jz2z6yOtD2/OXtyx+Hiq0ISMuMRSDrnTS9oiBCbY
	1/WdcGh4+L1TM+tJcODkb8LN38scFtbe0XVflHppms6n0wZ6GhcPb9cuXNSSWb9P9oaBQCO/
	0zHBxupOdUGRMwqlQkosxRmJhlrMRcWJAMT8V97qAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV2jF85BBvMeaFtMffiEzeLywkus
	Ft+udDBZXN41h81iwvS1LA6sHmvmrWH02DnrLrvHplWdbB59W1YxenzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDHv4zyWgoMcFStfPGZtYJzP3sXIySEhYCKx
	cN81NghbTOLCvfVANheHkMB0RomFD9ZAOb8YJa6/mA9WxSagJvHly2Ggbg4OEQFVif+v3EHC
	zAITGCVePLEEsYUEbCUav/1lAbE5BewkZu0/yQxiCwv4SLx7dQgszgLU+uXsCbA4L1D9n+3L
	WSFsQYkfk++xQMzUkli/8zgThC0vsXnNW2aQtRIC6hKP/uqChEUEjCSOvtzBDFEiIrHvxTvG
	CYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgNPJPewbiq
	weIQowAHoxIP7wVm5yAh1sSy4srcQ4wSHMxKIrzfjIBCvCmJlVWpRfnxRaU5qcWHGJOBHp3I
	LCWanA9MUXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwDiZ
	aVrjfIEVTPv23mOoCrebc0zLtPvB5/UnK3wqd0xl+Zu250612/5v8z4mT5lXuPR/2YoJb7cG
	yExlMzj0MlbHcfFPzqys+euKlNq4u1d6rb5qucaW5SfDlQnpHG/UD8gZ7ulf39aSumblJjdv
	C8maZx++tChZZrkx2rxPn9s1/ZdLQvYvmYtKLMUZiYZazEXFiQD3m7pGRwMAAA==
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


