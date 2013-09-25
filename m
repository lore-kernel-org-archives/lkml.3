Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3IYIRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:17:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29585 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab3IYIRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:17:08 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-09-52429bfe65e3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Pawel Moll'" <pawel.moll@arm.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 20/20] regulator: vexpress: use devm_regulator_register()
Date: Wed, 25 Sep 2013 17:17:02 +0900
Message-id: <001d01ceb9c7$9cf167e0$d6d437a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAA98Ow
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ91/s52CDNZdFbWY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvFhOlrWRxYPdbMW8PosXPWXXaPTas62Tz6tqxi9Pi8SS6ANYrLJiU1J7Ms
	tUjfLoErY8OBL6wF0zgqpvRtYWxg/MnWxcjJISFgIjH39ComCFtM4sK99UBxLg4hgWWMEn+3
	TmeGKfrzqI0dIjGdUWLf2v8sIAkhgV+MEu0/QkBsNgE1iS9fDgMVcXCICKhK/H/lDhJmFpjA
	KPHiiSVEua3E8r+3wVo5Bewklt37DHaEsICnxIJ3S9lBbBag1mV7JoIdxAtUv25SK5QtKPFj
	8j0WiJlaEut3HmeCsOUlNq95ywyyVkJAXeLRX12QsIiAkcTBtl/MECUiEvtevGMEOV9C4Bq7
	RNfbHawQuwQkvk0+xALRKyux6QDUu5ISB1fcYAE6fBaSzbOQbJ6FZPMsJCsWMLKsYhRNLUgu
	KE5KLzLRK07MLS7NS9dLzs/dxAiJ0wk7GO8dsD7EmAy0fiKzlGhyPjDO80riDY3NjCxMTUyN
	jcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAOF3rUPtkWY/k2Ufk7quq
	POkpXvLYw8WLad1KRS/DJ2FlN/luHS363Dht8to58WsWLji7OuGlDHO704JJggKneNj/zS4S
	ZW8QeRS9MP7nSutlexyazzRHVDo+jn9xRu+NdWrmsStHLj3INt2pw670Sb5Y6u0C8baTP2M9
	7/steT3z+5eHNh9shJVYijMSDbWYi4oTAV3ZPofpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd1/s52CDH6/EbSY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvFhOlrWRxYPdbMW8PosXPWXXaPTas62Tz6tqxi9Pi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPDgS+sBdM4Kqb0bWFsYPzJ1sXIySEhYCLx
	51EbO4QtJnHh3nqgOBeHkMB0Rol9a/+zgCSEBH4xSrT/CAGx2QTUJL58OQzUwMEhIqAq8f+V
	O0iYWWACo8SLJ5YQ5bYSy//eBmvlFLCTWHbvM9guYQFPiQXvloLtYgFqXbZnIhOIzQtUv25S
	K5QtKPFj8j0WiJlaEut3HmeCsOUlNq95ywyyVkJAXeLRX12QsIiAkcTBtl/MECUiEvtevGOc
	wCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgpPAM6kdjCsb
	LA4xCnAwKvHwChx1DBJiTSwrrsw9xCjBwawkwus8wylIiDclsbIqtSg/vqg0J7X4EGMy0KMT
	maVEk/OBCSqvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhgN
	Bc5bfu74lcP6Mk4sgO0q55XW/yIPpm0x6mYx39D9rd2L+fFtkzXn9u+NyOBfdHHfkp73p1sN
	oyYqqpSaat62Su3xN1TcXZ8RVrMiIa7puedrtT/z7Reffmt3ksv8oba2lY91ocGEwrMKq+JM
	ywPaREt4uhyzj1/zDP4Xs/LIjwVbgtmS7ZVYijMSDbWYi4oTAeMYX5xGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
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


