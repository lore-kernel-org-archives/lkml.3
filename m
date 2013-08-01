Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab3HAVoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:44:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39732 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab3HAVob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:44:31 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 10/51] DMA-API: net: broadcom/bnx2x: replace
 dma_set_mask()+dma_set_coherent_mask() with new
 helper
Message-Id: <E1V50fE-0006qO-D1@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 22:44:04 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the following sequence:

	dma_set_mask(dev, mask);
	dma_set_coherent_mask(dev, mask);

with a call to the new helper dma_set_mask_and_coherent().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index e5da078..f822e9c 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12035,13 +12035,9 @@ static int bnx2x_set_coherency_mask(struct bnx2x *bp)
 {
 	struct device *dev = &bp->pdev->dev;
 
-	if (dma_set_mask(dev, DMA_BIT_MASK(64)) == 0) {
+	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) == 0) {
 		bp->flags |= USING_DAC_FLAG;
-		if (dma_set_coherent_mask(dev, DMA_BIT_MASK(64)) != 0) {
-			dev_err(dev, "dma_set_coherent_mask failed, aborting\n");
-			return -EIO;
-		}
-	} else if (dma_set_mask(dev, DMA_BIT_MASK(32)) != 0) {
+	} else if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32)) != 0) {
 		dev_err(dev, "System does not support DMA, aborting\n");
 		return -EIO;
 	}
-- 
1.7.4.4

