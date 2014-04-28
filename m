Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbaD1Utr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:49:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47116 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756423AbaD1Uto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:49:44 -0400
From: Joel Fernandes <joelf@ti.com>
To: Sekhar Nori <nsekhar@ti.com>, Matt Porter <matt@ohporter.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 1/2] dmaengine: edma: Document variables used for residue accounting
Date: Mon, 28 Apr 2014 15:48:47 -0500
Message-ID: <1398718128-22647-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The granular residue accounting code uses certain variables specifically
for residue accounting. Document these in the structure declaration.
Also move around some elements and group them together.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 4c574f60..8926078 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -70,12 +70,34 @@ struct edma_desc {
 	int				cyclic;
 	int				absync;
 	int				pset_nr;
+	struct edma_chan		*echan;
 	int				processed;
+
+	/*
+	 * The following 4 elements are used for residue accounting.
+	 *
+	 * - processed_stat: the number of SG elements we have traversed
+	 * so far to cover accounting. This is updated directly to processed
+	 * during edma_callback and is always <= processed, because processed
+	 * refers to the number of pending transfer (programmed to EDMA
+	 * controller), where as processed_stat tracks number of transfers
+	 * accounted for so far.
+	 *
+	 * - residue: The amount of bytes we have left to transfer for this desc
+	 *
+	 * - residue_stat: The residue in bytes of data we have covered
+	 * so far for accounting. This is updated directly to residue
+	 * during callbacks to keep it current.
+	 *
+	 * - sg_len: Tracks the length of the current intermediate transfer,
+	 * this is required to update the residue during intermediate transfer
+	 * completion callback.
+	 */
 	int				processed_stat;
-	u32				residue;
 	u32				sg_len;
+	u32				residue;
 	u32				residue_stat;
-	struct edma_chan		*echan;
+
 	struct edma_pset		pset[0];
 };
 
-- 
1.7.9.5

