Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761441Ab3JPRXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:23:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:32753 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761202Ab3JPRWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:22:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851280"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 10/28] dmaengine: imx-dma: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:28 +0530
Message-Id: <1381940926-25564-11-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/dma/imx-dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 55852c0..2af4028 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -771,7 +771,7 @@ static int imxdma_alloc_chan_resources(struct dma_chan *chan)
 		desc->desc.tx_submit = imxdma_tx_submit;
 		/* txd.flags will be overwritten in prep funcs */
 		desc->desc.flags = DMA_CTRL_ACK;
-		desc->status = DMA_SUCCESS;
+		desc->status = DMA_COMPLETE;
 
 		list_add_tail(&desc->node, &imxdmac->ld_free);
 		imxdmac->descs_allocated++;
-- 
1.7.0.4

