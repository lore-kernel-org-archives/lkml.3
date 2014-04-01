Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaDANMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:12:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35269 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbaDANHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:07:05 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: [PATCH v2 08/14] DMA: edma: Use different eventq for cyclic channels
Date: Tue, 1 Apr 2014 16:06:09 +0300
Message-ID: <1396357575-30585-9-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To improve latency with cyclic DMA operation it is preferred to
use different eventq/tc than the default which is used by all
other drivers (mmc, spi, i2c, etc).
When preparing the cyclic dma ask for non default queue for the
channel which is going to be used with cyclic mode.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/dma/edma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 1dd9e8806975..10048b40fac8 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -628,6 +628,9 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
 		edesc->pset[i].opt |= TCINTEN;
 	}
 
+	/* Use different eventq/tc for cyclic DMA to reduce latency */
+	edma_request_non_default_queue(echan->ch_num);
+
 	return vchan_tx_prep(&echan->vchan, &edesc->vdesc, tx_flags);
 }
 
-- 
1.9.1

