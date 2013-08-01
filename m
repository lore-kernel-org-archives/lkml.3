Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab3HAVui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:50:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39750 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190Ab3HAVud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:50:33 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 16/51] DMA-API: ppc: vio.c: replace
 dma_set_mask()+dma_set_coherent_mask() with new
 helper
Message-Id: <E1V50l4-0006r0-7D@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 22:50:06 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the following sequence:

	dma_set_mask(dev, mask);
	dma_set_coherent_mask(dev, mask);

with a call to the new helper dma_set_mask_and_coherent().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/powerpc/kernel/vio.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 536016d..045f026 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1412,8 +1412,7 @@ struct vio_dev *vio_register_device_node(struct device_node *of_node)
 
 		/* needed to ensure proper operation of coherent allocations
 		 * later, in case driver doesn't set it explicitly */
-		dma_set_mask(&viodev->dev, DMA_BIT_MASK(64));
-		dma_set_coherent_mask(&viodev->dev, DMA_BIT_MASK(64));
+		dma_set_mask_and_coherent(&viodev->dev, DMA_BIT_MASK(64));
 	}
 
 	/* register with generic device framework */
-- 
1.7.4.4

