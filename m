Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936776Ab3DJN6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:58:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:20948 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936740Ab3DJN6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:58:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,447,1363158000"; 
   d="scan'208";a="284281413"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 4/9] serial: 8250_dma: Provide default slave configuration parameters
Date: Wed, 10 Apr 2013 16:58:27 +0300
Message-Id: <1365602312-25436-5-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365602312-25436-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1365602312-25436-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some slave channel parameters will be always the same. For
example, direction for the Rx channel will always be
DMA_DEV_TO_MEM and DMA_MEM_TO_DEV for Tx channel.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dma.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index fdb6139e..7046769 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -149,8 +149,14 @@ int serial8250_request_dma(struct uart_8250_port *p)
 	struct uart_8250_dma	*dma = p->dma;
 	dma_cap_mask_t		mask;
 
-	dma->rxconf.src_addr = p->port.mapbase + UART_RX;
-	dma->txconf.dst_addr = p->port.mapbase + UART_TX;
+	/* Default slave configuration parameters */
+	dma->rxconf.direction		= DMA_DEV_TO_MEM;
+	dma->rxconf.src_addr_width	= DMA_SLAVE_BUSWIDTH_1_BYTE;
+	dma->rxconf.src_addr		= p->port.mapbase + UART_RX;
+
+	dma->txconf.direction		= DMA_MEM_TO_DEV;
+	dma->txconf.dst_addr_width	= DMA_SLAVE_BUSWIDTH_1_BYTE;
+	dma->txconf.dst_addr		= p->port.mapbase + UART_TX;
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
-- 
1.7.10.4

