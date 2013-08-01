Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab3HAV6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:58:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39777 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757613Ab3HAV6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:58:35 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 24/51] DMA-API: dma: pl330: add
 dma_set_mask_and_coherent() call
Message-Id: <E1V50sr-0006ro-22@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 22:58:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA API requires drivers to call the appropriate dma_set_mask()
functions before doing any DMA mapping.  Add this required call to
the AMBA PL08x driver.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/dma/pl330.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 593827b..9d30c53 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2869,6 +2869,10 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 
 	pdat = adev->dev.platform_data;
 
+	ret = dma_set_mask_and_coherent(&adev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
+
 	/* Allocate a new DMAC and its Channels */
 	pdmac = devm_kzalloc(&adev->dev, sizeof(*pdmac), GFP_KERNEL);
 	if (!pdmac) {
-- 
1.7.4.4

