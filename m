Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab3HAVte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:49:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39747 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab3HAVtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:49:33 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 15/51] DMA-API: net: b43legacy: replace
 dma_set_mask()+dma_set_coherent_mask() with new
 helper
Message-Id: <E1V50k5-0006qu-Nv@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 22:49:05 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the following sequence:

	dma_set_mask(dev, mask);
	dma_set_coherent_mask(dev, mask);

with a call to the new helper dma_set_mask_and_coherent().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/net/wireless/b43legacy/dma.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/dma.c b/drivers/net/wireless/b43legacy/dma.c
index faeafe2..3952d15 100644
--- a/drivers/net/wireless/b43legacy/dma.c
+++ b/drivers/net/wireless/b43legacy/dma.c
@@ -807,12 +807,9 @@ static int b43legacy_dma_set_mask(struct b43legacy_wldev *dev, u64 mask)
 	/* Try to set the DMA mask. If it fails, try falling back to a
 	 * lower mask, as we can always also support a lower one. */
 	while (1) {
-		err = dma_set_mask(dev->dev->dma_dev, mask);
-		if (!err) {
-			err = dma_set_coherent_mask(dev->dev->dma_dev, mask);
-			if (!err)
-				break;
-		}
+		err = dma_set_mask_and_coherent(dev->dev->dma_dev, mask);
+		if (!err)
+			break;
 		if (mask == DMA_BIT_MASK(64)) {
 			mask = DMA_BIT_MASK(32);
 			fallback = true;
-- 
1.7.4.4

