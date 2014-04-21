Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaDUMEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:04:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42742 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaDUMCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:02:20 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-73-535508cb08f5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 4/9] extcon: max77693: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Mon, 21 Apr 2014 21:02:17 +0900
Message-id: <1398081742-24277-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSonuaIzTYYMsVXouD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK+PBsrWsBa3cFf/2PGVqYJzA2cXI
	wSEhYCKx5I5NFyMnkCkmceHeerYuRi4OIYGljBIdzZsZIRJANS/6WCESixglNvdegKpqYpI4
	8HwGWBWbgJbE/hc32EBsEQEFoKJnYB3MAs8YJU5cPcEMkhAWCJPY8v8LG8hqFgFVidvtZSBh
	XgFXic1fHrJCbJOT+LDnETtICaeAm8SFE+UgYSGgkke/QQ7iAirZxi6x9dUMdpAEi4CAxLfJ
	h1ggvpGV2HSAGWKMpMTBFTdYJjAKL2BkWMUomlqQXFCclF5krFecmFtcmpeul5yfu4kRGAen
	/z3r38F494D1IcZkoHETmaVEk/OBcZRXEm9obGZkYWpiamxkbmlGmrCSOO/9h0lBQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhhn1eae+LY5vPeIUnRBfnd+Y9ZxpSub095HFjuvNJ1dPsuF
	K0PFOkfx3QSTtWaNESabj9TFXT6XX9jE6O7a/qVKgPFswsYH4UGbj21adiz+bZm8/pm3ndu3
	CZ7ef2XNKqaXVf6etvKLfnsY9fGLih+evmzzo28v69Xqom+/f9d2u4Xt0MuoV1xKLMUZiYZa
	zEXFiQAGZ/ScmQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd3THKHBBpMa2SwO3q+3mPrwCZvF
	vyk32C2uf3nOatG/xcXi9QtDiwtPe9gszja9Ybe4vGsOm8XtxhVsDlwem1Z1snm8nPibzaNv
	yypGj6lT/jJ6HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGE
	NYwZD5atZS1o5a74t+cpUwPjBM4uRk4OCQETiSUv+lghbDGJC/fWs3UxcnEICSxilNjcewHK
	aWKSOPB8BiNIFZuAlsT+FzfYQGwRAQWgomesIEXMAs8YJU5cPcEMkhAWCJPY8v8LUBEHB4uA
	qsTt9jKQMK+Aq8TmLw+htslJfNjziB2khFPATeLCiXKQsBBQyaPfmxknMPIuYGRYxSiaWpBc
	UJyUnmuoV5yYW1yal66XnJ+7iREcZ8+kdjCubLA4xCjAwajEwzujJCRYiDWxrLgy9xCjBAez
	kghvxHqgEG9KYmVValF+fFFpTmrxIcZkoJsmMkuJJucDU0BeSbyhsYmZkaWRuaGFkbE5acJK
	4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTCutW82+3ere+bV+MelLwO3XZM60NufdE/Tv1u0
	/9nTOc1RF8SE+ZxaRfcveTu1XtNmzfzzS5kLZ97OPjVL7uSSqt3Rmav27ZbRnJOxec2jDy89
	lEqn/4jL/+rZ53wz6S+33Ta9lIeT9uivED89QeWcw5b1P2pU30qfnbfB0t5It8RTIlTm8ZQo
	JZbijERDLeai4kQA6tPBWfcCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use devm_extcon_dev_allocate() to simplify the memory control
of extcon device.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max77693.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index f0f18e2..2e15a24 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1175,8 +1175,8 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize extcon device */
-	info->edev = devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
-				  GFP_KERNEL);
+	info->edev = devm_extcon_dev_allocate(&pdev->dev,
+					      max77693_extcon_cable);
 	if (!info->edev) {
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		ret = -ENOMEM;
@@ -1184,14 +1184,13 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 	info->edev->name = DEV_NAME;
 	info->edev->dev.parent = &pdev->dev;
-	info->edev->supported_cable = max77693_extcon_cable;
+
 	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
 		goto err_irq;
 	}
 
-
 	/* Initialize MUIC register by using platform data or default data */
 	if (pdata && pdata->muic_data) {
 		init_data = pdata->muic_data->init_data;
-- 
1.8.0

