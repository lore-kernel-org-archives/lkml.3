Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaJPJJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:09:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36424 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751950AbaJPJFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:05:09 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Barry Song <baohua@kernel.org>
Subject: [PATCH 10/11] dmaengine: sirf: Remove chancnt affectations
Date: Thu, 16 Oct 2014 11:01:02 +0200
Message-Id: <1413450063-23829-11-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413450063-23829-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413450063-23829-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

chanctnt is already filled by dma_async_device_register, which uses the channel
list to know how much channels there is.

Since it's already filled, we can safely remove it from the drivers' probe
function.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/sirf-dma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index aac03ab10c54..fbe291584e8a 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -735,7 +735,6 @@ static int sirfsoc_dma_probe(struct platform_device *op)
 
 	dma = &sdma->dma;
 	dma->dev = dev;
-	dma->chancnt = SIRFSOC_DMA_CHANNELS;
 
 	dma->device_alloc_chan_resources = sirfsoc_dma_alloc_chan_resources;
 	dma->device_free_chan_resources = sirfsoc_dma_free_chan_resources;
@@ -752,7 +751,7 @@ static int sirfsoc_dma_probe(struct platform_device *op)
 	dma_cap_set(DMA_INTERLEAVE, dma->cap_mask);
 	dma_cap_set(DMA_PRIVATE, dma->cap_mask);
 
-	for (i = 0; i < dma->chancnt; i++) {
+	for (i = 0; i < SIRFSOC_DMA_CHANNELS; i++) {
 		schan = &sdma->channels[i];
 
 		schan->chan.device = dma;
-- 
2.1.1

