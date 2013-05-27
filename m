Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab3E0MOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:14:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:32011 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932141Ab3E0MOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:14:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,750,1363158000"; 
   d="scan'208";a="343975663"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 03/12] edma: no need to assign residue to 0 explicitly
Date: Mon, 27 May 2013 15:14:33 +0300
Message-Id: <1369656882-25241-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Residue value is assigned to 0 by dma_cookie_status().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/edma.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index cd7e328..8e11499 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -502,8 +502,6 @@ static enum dma_status edma_tx_status(struct dma_chan *chan,
 	} else if (echan->edesc && echan->edesc->vdesc.tx.cookie == cookie) {
 		struct edma_desc *edesc = echan->edesc;
 		txstate->residue = edma_desc_size(edesc);
-	} else {
-		txstate->residue = 0;
 	}
 	spin_unlock_irqrestore(&echan->vchan.lock, flags);
 
-- 
1.8.2.rc0.22.gb3600c3

