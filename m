Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab3HAVnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:43:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39729 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab3HAVnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:43:31 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 09/51] DMA-API: net: broadcom/b44: replace
 dma_set_mask()+dma_set_coherent_mask() with new
 helper
Message-Id: <E1V50eG-0006qI-8D@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 22:43:04 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the following sequence:

	dma_set_mask(dev, mask);
	dma_set_coherent_mask(dev, mask);

with a call to the new helper dma_set_mask_and_coherent().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/net/ethernet/broadcom/b44.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 9b017d9..b4d2018 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -2183,8 +2183,7 @@ static int b44_init_one(struct ssb_device *sdev,
 		goto err_out_free_dev;
 	}
 
-	if (dma_set_mask(sdev->dma_dev, DMA_BIT_MASK(30)) ||
-	    dma_set_coherent_mask(sdev->dma_dev, DMA_BIT_MASK(30))) {
+	if (dma_set_mask_and_coherent(sdev->dma_dev, DMA_BIT_MASK(30))) {
 		dev_err(sdev->dev,
 			"Required 30BIT DMA mask unsupported by the system\n");
 		goto err_out_powerdown;
-- 
1.7.4.4

