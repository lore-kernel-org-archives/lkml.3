Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaAGNil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:38:41 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:50923 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaAGNie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:38:34 -0500
MIME-Version: 1.0
Date: Tue, 7 Jan 2014 21:38:32 +0800
Message-ID: <CAPgLHd_RMOPLP2f4nA1vqNNddocMUX7f-gE29TTkuJZPUm=SWw@mail.gmail.com>
Subject: [PATCH -next] mtd: nuc900_nand: remove redundant return value check
 of platform_get_resource()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mcuos.com@gmail.com, dwmw2@infradead.org, computersforpeace@gmail.com,
        jg1.han@samsung.com
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove unneeded error handling on the result of a call
to platform_get_resource() when the value is passed to
devm_ioremap_resource().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mtd/nand/nuc900_nand.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mtd/nand/nuc900_nand.c b/drivers/mtd/nand/nuc900_nand.c
index 661fd14..9ee09a8 100644
--- a/drivers/mtd/nand/nuc900_nand.c
+++ b/drivers/mtd/nand/nuc900_nand.c
@@ -268,9 +268,6 @@ static int nuc900_nand_probe(struct platform_device *pdev)
 	chip->ecc.mode		= NAND_ECC_SOFT;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
-
 	nuc900_nand->reg = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(nuc900_nand->reg))
 		return PTR_ERR(nuc900_nand->reg);

