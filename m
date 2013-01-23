Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab3AWPiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:38:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:39788 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224Ab3AWPiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:38:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,523,1355126400"; 
   d="scan'208";a="194342987"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 3/4] dw_dmac: fill individual length of descriptor
Date: Wed, 23 Jan 2013 17:37:31 +0200
Message-Id: <1358955452-20960-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358955452-20960-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358955452-20960-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will be useful to have the length of the transfer in the descriptor. The
cyclic transfer functions remained untouched.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index c3062a5..026a3c7 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -756,6 +756,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		desc->lli.dar = dest + offset;
 		desc->lli.ctllo = ctllo;
 		desc->lli.ctlhi = xfer_count;
+		desc->len = xfer_count << src_width;
 
 		if (!first) {
 			first = desc;
@@ -852,8 +853,8 @@ slave_sg_todev_fill_desc:
 				dlen = len;
 				len = 0;
 			}
-
 			desc->lli.ctlhi = dlen >> mem_width;
+			desc->len = dlen;
 
 			if (!first) {
 				first = desc;
@@ -912,6 +913,7 @@ slave_sg_fromdev_fill_desc:
 				len = 0;
 			}
 			desc->lli.ctlhi = dlen >> reg_width;
+			desc->len = dlen;
 
 			if (!first) {
 				first = desc;
-- 
1.7.10.4

