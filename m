Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab3E0MQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:16:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:60466 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216Ab3E0MOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:14:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,750,1363158000"; 
   d="scan'208";a="247199728"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 11/12] mmp_tdma: set cookies as well when asked for tx status
Date: Mon, 27 May 2013 15:14:41 +0300
Message-Id: <1369656882-25241-12-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_set_residue() sets only residue value, so user can't rely on the returned
values of cookies. That patch standardize the behaviour.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/mmp_tdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 43d5a6c..4472915 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -456,7 +456,8 @@ static enum dma_status mmp_tdma_tx_status(struct dma_chan *chan,
 {
 	struct mmp_tdma_chan *tdmac = to_mmp_tdma_chan(chan);
 
-	dma_set_residue(txstate, tdmac->buf_len - tdmac->pos);
+	dma_set_tx_state(txstate, chan->completed_cookie, chan->cookie,
+			 tdmac->buf_len - tdmac->pos);
 
 	return tdmac->status;
 }
-- 
1.8.2.rc0.22.gb3600c3

