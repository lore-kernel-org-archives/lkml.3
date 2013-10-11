Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab3JKKCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:02:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:27737 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756587Ab3JKKCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:02:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1079,1371106800"; 
   d="scan'208";a="373396940"
From: Youquan Song <youquan.song@intel.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com, gregkh@linuxfoundation.org
Cc: andriy.shevchenko@intel.com, mika.westerberg@intel.com,
        linux-kernel@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 2/2] dma: calculate the data tranferred by 8250
Date: Fri, 11 Oct 2013 17:42:18 -0400
Message-Id: <1381527738-9339-3-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1381527738-9339-2-git-send-email-youquan.song@intel.com>
References: <1381527738-9339-1-git-send-email-youquan.song@intel.com>
 <1381527738-9339-2-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using UART transfers data by DMA mode, but it always shows 0 at 
/sys/class/dma/dma0chan*/bytes_transferred.

Call the new function to calculate how many the data has been transferred
 after doing it by DMA mode. 

Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 drivers/tty/serial/8250/8250_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 7046769..b22ef80 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -83,7 +83,7 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 	desc->callback = __dma_tx_complete;
 	desc->callback_param = p;
 
-	dma->tx_cookie = dmaengine_submit(desc);
+	dma->tx_cookie = dma_tx_submit_cal(desc, dma->txchan, dma->tx_size);
 
 	dma_sync_single_for_device(dma->txchan->device->dev, dma->tx_addr,
 				   UART_XMIT_SIZE, DMA_TO_DEVICE);
-- 
1.7.7.4

