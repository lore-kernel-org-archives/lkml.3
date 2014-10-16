Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaJPJFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:05:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36407 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751603AbaJPJFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:05:05 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 03/11] dmaengine: jz4740: Remove chancnt affectations
Date: Thu, 16 Oct 2014 11:00:55 +0200
Message-Id: <1413450063-23829-4-git-send-email-maxime.ripard@free-electrons.com>
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
 drivers/dma/dma-jz4740.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/dma-jz4740.c b/drivers/dma/dma-jz4740.c
index 6a9d89c93b1f..8b7d8f4cafaf 100644
--- a/drivers/dma/dma-jz4740.c
+++ b/drivers/dma/dma-jz4740.c
@@ -562,10 +562,9 @@ static int jz4740_dma_probe(struct platform_device *pdev)
 	dd->device_prep_dma_cyclic = jz4740_dma_prep_dma_cyclic;
 	dd->device_control = jz4740_dma_control;
 	dd->dev = &pdev->dev;
-	dd->chancnt = JZ_DMA_NR_CHANS;
 	INIT_LIST_HEAD(&dd->channels);
 
-	for (i = 0; i < dd->chancnt; i++) {
+	for (i = 0; i < JZ_DMA_NR_CHANS; i++) {
 		chan = &dmadev->chan[i];
 		chan->id = i;
 		chan->vchan.desc_free = jz4740_dma_desc_free;
-- 
2.1.1

