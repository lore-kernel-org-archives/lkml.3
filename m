Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaDANGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:06:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54314 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaDANGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:06:46 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: [PATCH v2 02/14] dma: edma: Correct the handling of src/dst_maxburst == 0
Date: Tue, 1 Apr 2014 16:06:03 +0300
Message-ID: <1396357575-30585-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When clients asks for maxburst = 0 it is basically the same case as if they
were asking for maxburst = 1 since in both case ASYNC need to be used and
the eDMA is expected to write/read one word per DMA request.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/dma/edma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index cd04eb7b182e..2742867fd1e6 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -285,6 +285,10 @@ static int edma_config_pset(struct dma_chan *chan, struct edmacc_param *pset,
 	int absync;
 
 	acnt = dev_width;
+
+	/* src/dst_maxburst == 0 is the same case as src/dst_maxburst == 1 */
+	if (!burst)
+		burst = 1;
 	/*
 	 * If the maxburst is equal to the fifo width, use
 	 * A-synced transfers. This allows for large contiguous
-- 
1.9.1

