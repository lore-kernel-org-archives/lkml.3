Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab3ARHqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:46:38 -0500
Received: from norkia.v3.sk ([91.210.183.14]:56999 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab3ARHqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:46:36 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH 3/3] dma: mv_xor: get rid of a DMA-API sanity check warning
Date: Fri, 18 Jan 2013 08:46:22 +0100
Message-Id: <1358495182-30964-3-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1358495154.28503.5.camel@unicorn>
References: <1358495154.28503.5.camel@unicorn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mv_xor mv_xor.0: DMA-API: device driver frees DMA memory with different direction [device address=0x000000001dea4000] [size=4096 bytes] [mapped with DMA_FROM_DEVICE] [unmapped with DMA_BIDIRECTIONAL]

Change xor self test destination buffer allocation direction to bidirectional,
as it's what mv_xor_run_tx_complete_actions() frees for multiple sources.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/dma/mv_xor.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index d00a834..1e90f5d 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1042,7 +1042,7 @@ mv_xor_xor_self_test(struct mv_xor_chan *mv_chan)
 
 	/* test xor */
 	dest_dma = dma_map_page(dma_chan->device->dev, dest, 0, PAGE_SIZE,
-				DMA_FROM_DEVICE);
+				DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dma_chan->device->dev, dest_dma)) {
 		dev_err(dma_chan->device->dev,
 			"Could not map destination page, disabling\n");
-- 
1.7.1

