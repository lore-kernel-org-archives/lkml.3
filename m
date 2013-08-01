Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab3HAVxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:53:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39759 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab3HAVxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:53:34 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 19/51] DMA-API: media: dt3155v4l: replace
 dma_set_mask()+dma_set_coherent_mask() with new
 helper
Message-Id: <E1V50nz-0006rJ-UO@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 22:53:07 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the following sequence:

	dma_set_mask(dev, mask);
	dma_set_coherent_mask(dev, mask);

with a call to the new helper dma_set_mask_and_coherent().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 90d6ac4..081407b 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -901,10 +901,7 @@ dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	int err;
 	struct dt3155_priv *pd;
 
-	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-	if (err)
-		return -ENODEV;
-	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (err)
 		return -ENODEV;
 	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
-- 
1.7.4.4

