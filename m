Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160AbaICWXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:23:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933901AbaICWSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [PATCH 3.16 049/125] drivers/i2c/busses: use correct type for dma_map/unmap
Date: Wed,  3 Sep 2014 15:06:46 -0700
Message-Id: <20140903220625.118972185@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa@the-dreams.de>

commit 28772ac8711e4d7268c06e765887dd8cb6924f98 upstream.

dma_{un}map_* uses 'enum dma_data_direction' not 'enum dma_transfer_direction'.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-at91.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -210,7 +210,7 @@ static void at91_twi_write_data_dma_call
 	struct at91_twi_dev *dev = (struct at91_twi_dev *)data;
 
 	dma_unmap_single(dev->dev, sg_dma_address(&dev->dma.sg),
-			 dev->buf_len, DMA_MEM_TO_DEV);
+			 dev->buf_len, DMA_TO_DEVICE);
 
 	at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_STOP);
 }
@@ -289,7 +289,7 @@ static void at91_twi_read_data_dma_callb
 	struct at91_twi_dev *dev = (struct at91_twi_dev *)data;
 
 	dma_unmap_single(dev->dev, sg_dma_address(&dev->dma.sg),
-			 dev->buf_len, DMA_DEV_TO_MEM);
+			 dev->buf_len, DMA_FROM_DEVICE);
 
 	/* The last two bytes have to be read without using dma */
 	dev->buf += dev->buf_len - 2;


