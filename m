Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaGUJn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:43:29 -0400
Received: from sauhun.de ([89.238.76.85]:45261 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbaGUJn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:43:26 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drivers/tty/serial: use correct type for dma_map/unmap
Date: Mon, 21 Jul 2014 11:42:04 +0200
Message-Id: <1405935725-10457-3-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1405935725-10457-1-git-send-email-wsa@the-dreams.de>
References: <1405935725-10457-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_{un}map_* uses 'enum dma_data_direction' not 'enum dma_transfer_direction'.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/tty/serial/atmel_serial.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index c4f750314100..7b63677475c1 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -706,7 +706,7 @@ static void atmel_release_tx_dma(struct uart_port *port)
 		dmaengine_terminate_all(chan);
 		dma_release_channel(chan);
 		dma_unmap_sg(port->dev, &atmel_port->sg_tx, 1,
-				DMA_MEM_TO_DEV);
+				DMA_TO_DEVICE);
 	}
 
 	atmel_port->desc_tx = NULL;
@@ -804,7 +804,7 @@ static int atmel_prepare_tx_dma(struct uart_port *port)
 	nent = dma_map_sg(port->dev,
 				&atmel_port->sg_tx,
 				1,
-				DMA_MEM_TO_DEV);
+				DMA_TO_DEVICE);
 
 	if (!nent) {
 		dev_dbg(port->dev, "need to release resource of dma\n");
@@ -883,7 +883,7 @@ static void atmel_release_rx_dma(struct uart_port *port)
 		dmaengine_terminate_all(chan);
 		dma_release_channel(chan);
 		dma_unmap_sg(port->dev, &atmel_port->sg_rx, 1,
-				DMA_DEV_TO_MEM);
+				DMA_FROM_DEVICE);
 	}
 
 	atmel_port->desc_rx = NULL;
@@ -968,7 +968,7 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
 			nent = dma_map_sg(port->dev,
 					&atmel_port->sg_rx,
 					1,
-					DMA_DEV_TO_MEM);
+					DMA_FROM_DEVICE);
 
 	if (!nent) {
 		dev_dbg(port->dev, "need to release resource of dma\n");
-- 
2.0.0

