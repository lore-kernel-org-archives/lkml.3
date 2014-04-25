Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaDYAoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:44:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57252 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaDYAme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:42:34 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-21-5359af78c1b6
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 3/9] extcon: max8997: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Fri, 25 Apr 2014 09:42:18 +0900
Message-id: <1398386544-16295-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSolu5PjLY4OATJouD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK2Pt1z2sBSc4K97962ZqYOzg6GLk
	5JAQMJH4t2MrM4QtJnHh3nq2LkYuDiGBpYwSk+YuYYcpWvtoBxNEYjqjxLGL/8ESQgJNTBK7
	L4aD2GwCWhL7X9xgA7FFBBQkNvc+YwVpYBZ4xihx4uoJsBXCAqESe34fZASxWQRUJV782Q0W
	5xVwldj2+zPUNjmJD3segdmcAm4Sh070skAsc5V4dW4OE0TNLnaJ59fjIeYISHybfAiohgMo
	Liux6QDUN5ISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmAknP73bMIO
	xnsHrA8xJgONm8gsJZqcD4ykvJJ4Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGanphak
	FsUXleakFh9iZOLglGpgjLYV2XbsxcmQ/VrrAr69skpwUMt9caWY53+swfvaov3K83K8rnHM
	TJpm/25fnPSK2ftPpXt853FInH1jjtCdb9+KKz45Lea56BmwUz87+LFEReLehaw5Vusc/3xf
	VRVU4/b8b3pa3pS17Ce0V1o8eTM9OWTiZ6kXTcaxL0uz5ixV6tvjr/SBW4mlOCPRUIu5qDgR
	AKDmVjqaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQd2K9ZHBBs17zC0O3q+3mPrwCZvF
	vyk32C2uf3nOatG/xcXi9QtDiwtPe9gszja9Ybe4vGsOm8XtxhVsDlwem1Z1snm8nPibzaNv
	yypGj6lT/jJ6HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGE
	NYwZa7/uYS04wVnx7l83UwNjB0cXIyeHhICJxNpHO5ggbDGJC/fWs3UxcnEICUxnlDh28T87
	SEJIoIlJYvfFcBCbTUBLYv+LG2wgtoiAgsTm3mesIA3MAs8YJU5cPcEMkhAWCJXY8/sgI4jN
	IqAq8eLPbrA4r4CrxLbfn9khtslJfNjzCMzmFHCTOHSilwVimavEq3NzmCYw8i5gZFjFKJpa
	kFxQnJSea6RXnJhbXJqXrpecn7uJERxpz6R3MK5qsDjEKMDBqMTDO0E2MliINbGsuDL3EKME
	B7OSCK/yKqAQb0piZVVqUX58UWlOavEhxmSgqyYyS4km5wOTQF5JvKGxiZmRpZG5oYWRsTlp
	wkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MK6P9XjheiOOk3HPjADWs9+le3/eF/GzLdfe
	93xfTNGuzQsnq6ywmHVuf76Fla6X4A2Xyqt/4yqiT072tkr+xSM12S7E47nRwimrJ81gulTU
	wBT6+L5u142kfS+yd+lNeJo7LT84ecKegN2M9aqLs5Y75Ri2efvZLH7GP7nj7dsLN1zaPnXv
	C1ViKc5INNRiLipOBAAcXKVH+AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use devm_extcon_dev_allocate() to simplify the memory control
of extcon device.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max8997.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 804a446..d9f7f1b 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -699,16 +699,15 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	}
 
 	/* External connector */
-	info->edev = devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
-				  GFP_KERNEL);
-	if (!info->edev) {
+	info->edev = devm_extcon_dev_allocate(&pdev->dev, max8997_extcon_cable);
+	if (IS_ERR(info->edev)) {
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		ret = -ENOMEM;
 		goto err_irq;
 	}
 	info->edev->name = DEV_NAME;
 	info->edev->dev.parent = &pdev->dev;
-	info->edev->supported_cable = max8997_extcon_cable;
+
 	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
-- 
1.8.0

