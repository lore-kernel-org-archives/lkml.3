Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaIPNyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:54:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54327 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809AbaIPNyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:54:04 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v2 1/2] dmaengine: omap-dma: Add memory barrier to dma_resume path
Date: Tue, 16 Sep 2014 16:53:48 +0300
Message-ID: <1410875629-1540-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410875629-1540-1-git-send-email-peter.ujfalusi@ti.com>
References: <1410875629-1540-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mb() call to resume path to ensure the necessary barrier.
Resume can happen after waking up from suspend for example.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/dma/omap-dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index 4cf7d9a950d7..c01ea505ee7c 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -1017,6 +1017,8 @@ static int omap_dma_resume(struct omap_chan *c)
 		return -EINVAL;
 
 	if (c->paused) {
+		mb();
+
 		omap_dma_start(c, c->desc);
 		c->paused = false;
 	}
-- 
2.1.0

