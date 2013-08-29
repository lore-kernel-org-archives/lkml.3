Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab3H2XJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:09:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58574 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3H2XGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:06:35 -0400
From: Joel Fernandes <joelf@ti.com>
To: Sekhar Nori <nsekhar@ti.com>, Matt Porter <matt@ohporter.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sricharan R <r.sricharan@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Franklin Cooper <fcooper@ti.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH v4 6/6] dma: edma: Remove limits on number of slots
Date: Thu, 29 Aug 2013 18:05:45 -0500
Message-ID: <1377817545-18015-7-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377817545-18015-1-git-send-email-joelf@ti.com>
References: <1377817545-18015-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this series, this check is no longer required and
we shouldn't need to reject drivers DMA'ing more than the
MAX number of slots.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 25e47d4..d966413 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -287,12 +287,6 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 		return NULL;
 	}
 
-	if (sg_len > MAX_NR_SG) {
-		dev_err(dev, "Exceeded max SG segments %d > %d\n",
-			sg_len, MAX_NR_SG);
-		return NULL;
-	}
-
 	edesc = kzalloc(sizeof(*edesc) + sg_len *
 		sizeof(edesc->pset[0]), GFP_ATOMIC);
 	if (!edesc) {
-- 
1.8.1.2

