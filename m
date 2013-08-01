Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab3HAVsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:48:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39744 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3HAVsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:48:32 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 14/51] DMA-API: net: b43: replace
 dma_set_mask()+dma_set_coherent_mask() with new
 helper
Message-Id: <E1V50j7-0006qn-J7@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 22:48:05 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the following sequence:

	dma_set_mask(dev, mask);
	dma_set_coherent_mask(dev, mask);

with a call to the new helper dma_set_mask_and_coherent().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/net/wireless/b43/dma.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index f7c70b3..88aa314 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1065,12 +1065,9 @@ static int b43_dma_set_mask(struct b43_wldev *dev, u64 mask)
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

