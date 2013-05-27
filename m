Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab3E0MOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:14:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:21067 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab3E0MOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:14:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,750,1363158000"; 
   d="scan'208";a="343801812"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 01/12] imx-sdma: remove useless variable
Date: Mon, 27 May 2013 15:14:31 +0300
Message-Id: <1369656882-25241-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

last_used variable is applied only once, so, let's substitute it by its value.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/imx-sdma.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 092867b..285e10c 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1119,15 +1119,12 @@ static int sdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 }
 
 static enum dma_status sdma_tx_status(struct dma_chan *chan,
-					    dma_cookie_t cookie,
-					    struct dma_tx_state *txstate)
+				      dma_cookie_t cookie,
+				      struct dma_tx_state *txstate)
 {
 	struct sdma_channel *sdmac = to_sdma_chan(chan);
-	dma_cookie_t last_used;
 
-	last_used = chan->cookie;
-
-	dma_set_tx_state(txstate, chan->completed_cookie, last_used,
+	dma_set_tx_state(txstate, chan->completed_cookie, chan->cookie,
 			sdmac->chn_count - sdmac->chn_real_count);
 
 	return sdmac->status;
-- 
1.8.2.rc0.22.gb3600c3

