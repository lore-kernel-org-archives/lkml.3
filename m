Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbaDXMn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:43:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13064 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860AbaDXMe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:34:58 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-d9-535904ef30f4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 3/9] extcon: max8997: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Thu, 24 Apr 2014 21:34:51 +0900
Message-id: <1398342897-23670-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42JZI2JSpPueJTLY4F+DjMXB+/UWUx8+YbP4
	N+UGu8X1L89ZLfq3uFi8fmFoceFpD5vF2aY37BaXd81hs7jduILNgctj06pONo+XE3+zefRt
	WcXoMXXKX0aP4ze2M3l83iQXwBbFZZOSmpNZllqkb5fAlbH68WO2gmecFeuu/2FuYFzG0cXI
	ySEhYCIx6+xsFghbTOLCvfVsXYxcHEICSxklZly6zQJTdOtDGytEYjqjRN+vM4wQThOTxL5N
	/1lBqtgEtCT2v7jBBmKLCChIbO59BtbBLPCMUeLE1RPMIAlhgVCJ/Z9ugTWwCKhKLPp0hgnE
	5hVwlVhwZDIbxDo5iQ97HrGD2JwCbhJnL1wFiwsB1axs+Ac2VEJgF7vE93d7WSAGCUh8m3wI
	yOYASshKbDrADDFHUuLgihssExiFFzAyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIjIbT
	/55N2MF474D1IcZkoHETmaVEk/OB0ZRXEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU
	7NTUgtSi+KLSnNTiQ4xMHJxSDYyst/8bZNm9dL4mOPGFQ3fpq/0zHmut7a81THDQVBZqNWjI
	c5I/a/qc/8Laih0bwqYHPLKdUSmW9l1Z3FitfpN0zNQP/7o7mYNePCyrmcr/NFSk9v8Sla+q
	M/a3+fceiuRg8jx+VTPqzpocl+JUhVWaT9ImeWS8MNJzO1i8T2jl59RF05e9/a/EUpyRaKjF
	XFScCAD5H1KwnAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQd33LJHBBns7RSwO3q+3mPrwCZvF
	vyk32C2uf3nOatG/xcXi9QtDiwtPe9gszja9Ybe4vGsOm8XtxhVsDlwem1Z1snm8nPibzaNv
	yypGj6lT/jJ6HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGE
	NYwZqx8/Zit4xlmx7vof5gbGZRxdjJwcEgImErc+tLFC2GISF+6tZ+ti5OIQEpjOKNH36wwj
	hNPEJLFv03+wKjYBLYn9L26wgdgiAgoSm3ufsYIUMQs8Y5Q4cfUEM0hCWCBUYv+nW2ANLAKq
	Eos+nWECsXkFXCUWHJnMBrFOTuLDnkfsIDangJvE2QtXweJCQDUrG/6xTmDkXcDIsIpRNLUg
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjONaeSe9gXNVgcYhRgINRiYdX4VZ4sBBrYllxZe4hRgkO
	ZiUR3tn/IoKFeFMSK6tSi/Lji0pzUosPMSYDXTWRWUo0OR+YBvJK4g2NTcyMLI3MDS2MjM1J
	E1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgTFEatWPDfbqQg1ca74cNDxVFtG7l/fLUsfD
	lya/e/Fbx1ei2d5R7pRY9DFd1tTlhpsmLWr9F7DVp+xfRblW7ft8o+Prl/yXN/Pob3XfWLd+
	22e2DPfCDV8Zc9o4jig4TvFoefd1UYdRmdtSzslLCkQrH4kG/1n34WPIhiTGW+xyr3anfmd3
	7FViKc5INNRiLipOBAAn5MBQ+QIAAA==
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
 drivers/extcon/extcon-max8997.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 804a446..e2ee2f5 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -699,8 +699,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	}
 
 	/* External connector */
-	info->edev = devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
-				  GFP_KERNEL);
+	info->edev = devm_extcon_dev_allocate(&pdev->dev, max8997_extcon_cable);
 	if (!info->edev) {
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		ret = -ENOMEM;
@@ -708,7 +707,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
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

