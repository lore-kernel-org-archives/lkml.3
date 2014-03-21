Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbaCUPxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:53:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44825 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaCUPxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:53:44 -0400
Message-ID: <532C6085.9070203@infradead.org>
Date: Fri, 21 Mar 2014 08:53:41 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, LKML <linux-kernel@vger.kernel.org>
CC: linux-spi@vger.kernel.org, Wenyou Yang <wenyou.yang@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] spi: fix spi-atmel.c printk format warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix printk format warning by using %p extension 'ad' for dma_addr_t.

drivers/spi/spi-atmel.c:1228:3: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat]
drivers/spi/spi-atmel.c:1228:3: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Wenyou Yang <wenyou.yang@atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/spi/spi-atmel.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

I thought that a patch for this was already posted but I can't find it...
Applies to mainline.

--- linux-next-20140321.orig/drivers/spi/spi-atmel.c
+++ linux-next-20140321/drivers/spi/spi-atmel.c
@@ -1226,10 +1226,10 @@ static int atmel_spi_transfer_one_messag
 
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 		dev_dbg(&spi->dev,
-			"  xfer %p: len %u tx %p/%08x rx %p/%08x\n",
+			"  xfer %p: len %u tx %p/%pad rx %p/%pad\n",
 			xfer, xfer->len,
-			xfer->tx_buf, xfer->tx_dma,
-			xfer->rx_buf, xfer->rx_dma);
+			xfer->tx_buf, &xfer->tx_dma,
+			xfer->rx_buf, &xfer->rx_dma);
 	}
 
 msg_done:
