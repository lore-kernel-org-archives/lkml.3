Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3AXKfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:35:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:52229 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab3AXKer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:34:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,528,1355126400"; 
   d="scan'208";a="281604431"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 3/4] dw_dmac: fill individual length of descriptor
Date: Thu, 24 Jan 2013 12:34:19 +0200
Message-Id: <1359023660-29084-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359023660-29084-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1359023660-29084-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will be useful to have the length of the transfer in the descriptor. The
cyclic transfer functions remained untouched.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 7b5a088..3b788c8 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -759,6 +759,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		desc->lli.dar = dest + offset;
 		desc->lli.ctllo = ctllo;
 		desc->lli.ctlhi = xfer_count;
+		desc->len = xfer_count << src_width;
 
 		if (!first) {
 			first = desc;
@@ -857,6 +858,7 @@ slave_sg_todev_fill_desc:
 			}
 
 			desc->lli.ctlhi = dlen >> mem_width;
+			desc->len = dlen;
 
 			if (!first) {
 				first = desc;
@@ -915,6 +917,7 @@ slave_sg_fromdev_fill_desc:
 				len = 0;
 			}
 			desc->lli.ctlhi = dlen >> reg_width;
+			desc->len = dlen;
 
 			if (!first) {
 				first = desc;
-- 
1.7.10.4

