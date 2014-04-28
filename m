Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbaD1Utn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:49:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39295 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbaD1Utl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:49:41 -0400
From: Joel Fernandes <joelf@ti.com>
To: Sekhar Nori <nsekhar@ti.com>, Matt Porter <matt@ohporter.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 2/2] dmaengine: edma: update DMA memcpy to use new param element
Date: Mon, 28 Apr 2014 15:48:48 -0500
Message-ID: <1398718128-22647-2-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398718128-22647-1-git-send-email-joelf@ti.com>
References: <1398718128-22647-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

edma param struct is now within an edma_pset struct introduced in Thomas
Gleixner's edma tx status series. Update memcpy function for the same.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 8926078..ec9c410 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -582,8 +582,8 @@ struct dma_async_tx_descriptor *edma_prep_dma_memcpy(
 	 * on completion of every TR, and enable transfer-completion
 	 * interrupt on completion of the whole transfer.
 	 */
-	edesc->pset[0].opt |= ITCCHEN;
-	edesc->pset[0].opt |= TCINTEN;
+	edesc->pset[0].param.opt |= ITCCHEN;
+	edesc->pset[0].param.opt |= TCINTEN;
 
 	return vchan_tx_prep(&echan->vchan, &edesc->vdesc, tx_flags);
 }
-- 
1.7.9.5

