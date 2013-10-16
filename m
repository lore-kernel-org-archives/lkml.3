Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761519Ab3JPRXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:23:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:18190 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761514Ab3JPRXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:23:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="417851414"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
        linux@arm.linux.org.uk, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 27/28] serial: sh: use DMA_COMPLETE for dma completion status
Date: Wed, 16 Oct 2013 21:58:45 +0530
Message-Id: <1381940926-25564-28-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Greg, pls ack this as it has depedency on my tree

 drivers/tty/serial/sh-sci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 5377502..7d8103c 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1433,7 +1433,7 @@ static void work_fn_rx(struct work_struct *work)
 	desc = s->desc_rx[new];
 
 	if (dma_async_is_tx_complete(s->chan_rx, s->active_rx, NULL, NULL) !=
-	    DMA_SUCCESS) {
+	    DMA_COMPLETE) {
 		/* Handle incomplete DMA receive */
 		struct dma_chan *chan = s->chan_rx;
 		struct shdma_desc *sh_desc = container_of(desc,
-- 
1.7.0.4

