Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab3AYJs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:48:27 -0500
Received: from mga14.intel.com ([143.182.124.37]:17499 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab3AYJsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:48:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,537,1355126400"; 
   d="scan'208";a="195026631"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v4 3/4] dw_dmac: fill individual length of descriptor
Date: Fri, 25 Jan 2013 11:48:02 +0200
Message-Id: <1359107283-5274-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359107283-5274-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1359107283-5274-1-git-send-email-andriy.shevchenko@linux.intel.com>
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

