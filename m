Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3CEXfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:35:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:31759 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab3CEXfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:35:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,791,1355126400"; 
   d="scan'208";a="209340572"
Subject: [PATCH v2] ioatdma: make debug output more readable
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 16:35:02 -0700
Message-ID: <20130305233502.28266.98605.stgit@djiang5-linux2.ch.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making OP field a hex instead of integer to make it more readable. Also add
the dump out of the NEXT field.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/ioat/dma.h    |    2 +-
 drivers/dma/ioat/dma_v3.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 53a4cbb..95ae7b3 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -179,7 +179,7 @@ __dump_desc_dbg(struct ioat_chan_common *chan, struct ioat_dma_descriptor *hw,
 	struct device *dev = to_dev(chan);
 
 	dev_dbg(dev, "desc[%d]: (%#llx->%#llx) cookie: %d flags: %#x"
-		" ctl: %#x (op: %d int_en: %d compl: %d)\n", id,
+		" ctl: %#10.8x (op: %#x int_en: %d compl: %d)\n", id,
 		(unsigned long long) tx->phys,
 		(unsigned long long) hw->next, tx->cookie, tx->flags,
 		hw->ctl, hw->ctl_f.op, hw->ctl_f.int_en, hw->ctl_f.compl_write);
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 53ea4bd..68e07e6 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -605,7 +605,7 @@ dump_pq_desc_dbg(struct ioat2_dma_chan *ioat, struct ioat_ring_ent *desc, struct
 	int i;
 
 	dev_dbg(dev, "desc[%d]: (%#llx->%#llx) flags: %#x"
-		" sz: %#x ctl: %#x (op: %d int: %d compl: %d pq: '%s%s' src_cnt: %d)\n",
+		" sz: %#10.8x ctl: %#x (op: %#x int: %d compl: %d pq: '%s%s' src_cnt: %d)\n",
 		desc_id(desc), (unsigned long long) desc->txd.phys,
 		(unsigned long long) (pq_ex ? pq_ex->next : pq->next),
 		desc->txd.flags, pq->size, pq->ctl, pq->ctl_f.op, pq->ctl_f.int_en,
@@ -617,6 +617,7 @@ dump_pq_desc_dbg(struct ioat2_dma_chan *ioat, struct ioat_ring_ent *desc, struct
 			(unsigned long long) pq_get_src(descs, i), pq->coef[i]);
 	dev_dbg(dev, "\tP: %#llx\n", pq->p_addr);
 	dev_dbg(dev, "\tQ: %#llx\n", pq->q_addr);
+	dev_dbg(dev, "\tNEXT (%s): %#llx\n", pq_ex ? "ext" : "", pq->next);
 }
 
 static struct dma_async_tx_descriptor *

