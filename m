Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab3AUJBC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:01:02 -0500
Received: from mga14.intel.com ([143.182.124.37]:2102 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab3AUJBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:01:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,505,1355126400"; 
   d="scan'208";a="193347415"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/2] dw_dmac: fill len field of the descriptor
Date: Mon, 21 Jan 2013 11:00:43 +0200
Message-Id: <1358758844-24711-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will be useful to have the length of the transfer in the descriptor. The
cyclic transfer functions remained untouched.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 3ff9ef7..d1b9ba2 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -754,6 +754,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 			first = desc;
 		} else {
 			prev->lli.llp = desc->txd.phys;
+			desc->len = xfer_count << src_width;
 			list_add_tail(&desc->desc_node,
 					&first->tx_list);
 		}
@@ -852,6 +853,7 @@ slave_sg_todev_fill_desc:
 				first = desc;
 			} else {
 				prev->lli.llp = desc->txd.phys;
+				desc->len = dlen;
 				list_add_tail(&desc->desc_node,
 						&first->tx_list);
 			}
@@ -910,6 +912,7 @@ slave_sg_fromdev_fill_desc:
 				first = desc;
 			} else {
 				prev->lli.llp = desc->txd.phys;
+				desc->len = dlen;
 				list_add_tail(&desc->desc_node,
 						&first->tx_list);
 			}
-- 
1.7.10.4

