Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab3HAV5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:57:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39774 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab3HAV5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:57:35 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 23/51] DMA-API: dma: pl08x: add
 dma_set_mask_and_coherent() call
Message-Id: <E1V50rs-0006rf-UM@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 22:57:08 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA API requires drivers to call the appropriate dma_set_mask()
functions before doing any DMA mapping.  Add this required call to
the AMBA PL08x driver.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/dma/amba-pl08x.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 06fe45c..c23f876 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1853,6 +1853,11 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	if (ret)
 		return ret;
 
+	/* Ensure that we can do DMA */
+	ret = dma_set_mask_and_coherent(&adev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		goto out_no_pl08x;
+
 	/* Create the driver state holder */
 	pl08x = kzalloc(sizeof(*pl08x), GFP_KERNEL);
 	if (!pl08x) {
-- 
1.7.4.4

