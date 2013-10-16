Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761594Ab3JPR02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:26:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:64778 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761457Ab3JPRXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:23:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851329"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>,
        Anatolij Gustschin <agust@denx.de>
Subject: [PATCH 20/28] dmaengine: ppc4xx: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:38 +0530
Message-Id: <1381940926-25564-21-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
CC: Anatolij Gustschin <agust@denx.de>
---
 drivers/dma/ppc4xx/adma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index 370ff82..60e02ae 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -3891,7 +3891,7 @@ static enum dma_status ppc440spe_adma_tx_status(struct dma_chan *chan,
 
 	ppc440spe_chan = to_ppc440spe_adma_chan(chan);
 	ret = dma_cookie_status(chan, cookie, txstate);
-	if (ret == DMA_SUCCESS)
+	if (ret == DMA_COMPLETE)
 		return ret;
 
 	ppc440spe_adma_slot_cleanup(ppc440spe_chan);
-- 
1.7.0.4

