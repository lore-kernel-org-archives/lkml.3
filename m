Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab3HAVzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:55:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39768 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab3HAVzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:55:36 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 21/51] DMA-API: usb: ssb-hcd: replace
 dma_set_mask()+dma_set_coherent_mask() with new
 helper
Message-Id: <E1V50pw-0006rU-Dx@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 22:55:08 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the following sequence:

	dma_set_mask(dev, mask);
	dma_set_coherent_mask(dev, mask);

with a call to the new helper dma_set_mask_and_coherent().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/usb/host/ssb-hcd.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ssb-hcd.c b/drivers/usb/host/ssb-hcd.c
index 74af2c6..0196f76 100644
--- a/drivers/usb/host/ssb-hcd.c
+++ b/drivers/usb/host/ssb-hcd.c
@@ -163,8 +163,7 @@ static int ssb_hcd_probe(struct ssb_device *dev,
 
 	/* TODO: Probably need checks here; is the core connected? */
 
-	if (dma_set_mask(dev->dma_dev, DMA_BIT_MASK(32)) ||
-	    dma_set_coherent_mask(dev->dma_dev, DMA_BIT_MASK(32)))
+	if (dma_set_mask_and_coherent(dev->dma_dev, DMA_BIT_MASK(32)))
 		return -EOPNOTSUPP;
 
 	usb_dev = kzalloc(sizeof(struct ssb_hcd_device), GFP_KERNEL);
-- 
1.7.4.4

