Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab3GGSFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 14:05:31 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60424 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab3GGSF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 14:05:29 -0400
From: Olof Johansson <olof@lixom.net>
To: vinod.koul@intel.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, djbw@fb.com,
        linux-arm-kernel@lists.infradead.org, b.zolnierkie@samsung.com,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] dma: iop: fix new warnings
Date: Sun,  7 Jul 2013 11:05:55 -0700
Message-Id: <1373220355-26712-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent "drivers/dma: remove unused support for MEMSET operations"
change has fallout from lack of build testing by the author. This fixes:

drivers/dma/iop-adma.c:1020:13: warning: unused variable 'dma_addr' [-Wunused-variable]
drivers/dma/iop-adma.c:1519:2: warning: format '%s' expects a matching 'char *' argument [-Wformat=]

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/dma/iop-adma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index c9cc08c..cc727ec 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -1017,7 +1017,7 @@ iop_adma_xor_val_self_test(struct iop_adma_device *device)
 	struct page *xor_srcs[IOP_ADMA_NUM_SRC_TEST];
 	struct page *zero_sum_srcs[IOP_ADMA_NUM_SRC_TEST + 1];
 	dma_addr_t dma_srcs[IOP_ADMA_NUM_SRC_TEST + 1];
-	dma_addr_t dma_addr, dest_dma;
+	dma_addr_t dest_dma;
 	struct dma_async_tx_descriptor *tx;
 	struct dma_chan *dma_chan;
 	dma_cookie_t cookie;
@@ -1516,7 +1516,7 @@ static int iop_adma_probe(struct platform_device *pdev)
 			goto err_free_iop_chan;
 	}
 
-	dev_info(&pdev->dev, "Intel(R) IOP: ( %s%s%s%s%s%s%s)\n",
+	dev_info(&pdev->dev, "Intel(R) IOP: ( %s%s%s%s%s%s)\n",
 		 dma_has_cap(DMA_PQ, dma_dev->cap_mask) ? "pq " : "",
 		 dma_has_cap(DMA_PQ_VAL, dma_dev->cap_mask) ? "pq_val " : "",
 		 dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
-- 
1.7.10.4

