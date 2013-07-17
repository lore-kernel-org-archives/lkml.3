Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933967Ab3GQAfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 20:35:02 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:60490 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933665Ab3GQAfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 20:35:01 -0400
MIME-Version: 1.0
Date: Wed, 17 Jul 2013 08:34:59 +0800
Message-ID: <CAPgLHd-T4sgoLn2nXFYjz+5cMvQgrnaxQ=GsWPYHyDo8p1uyzw@mail.gmail.com>
Subject: [PATCH] pch_dma: fix error return code in pch_dma_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: vinod.koul@intel.com, djbw@fb.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENODEV when no proper base address found error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/dma/pch_dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 237f1d5..956314d 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -860,6 +860,7 @@ static int pch_dma_probe(struct pci_dev *pdev,
 
 	if (!(pci_resource_flags(pdev, 1) & IORESOURCE_MEM)) {
 		dev_err(&pdev->dev, "Cannot find proper base address\n");
+		err = -ENODEV;
 		goto err_disable_pdev;
 	}
 

