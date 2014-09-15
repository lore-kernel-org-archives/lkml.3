Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbaIOXJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:09:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50667 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467AbaIOWMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:12:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wolfram Sang <wsa@the-dreams.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 130/187] drivers/i2c/busses: use correct type for dma_map/unmap
Date: Mon, 15 Sep 2014 15:09:00 -0700
Message-Id: <1410818997-9432-131-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa@the-dreams.de>

commit 28772ac8711e4d7268c06e765887dd8cb6924f98 upstream.

dma_{un}map_* uses 'enum dma_data_direction' not 'enum dma_transfer_direction'.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/i2c/busses/i2c-at91.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 8edba9d..d13d3bb 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -210,7 +210,7 @@ static void at91_twi_write_data_dma_callback(void *data)
 	struct at91_twi_dev *dev = (struct at91_twi_dev *)data;
 
 	dma_unmap_single(dev->dev, sg_dma_address(&dev->dma.sg),
-			 dev->buf_len, DMA_MEM_TO_DEV);
+			 dev->buf_len, DMA_TO_DEVICE);
 
 	at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_STOP);
 }
@@ -289,7 +289,7 @@ static void at91_twi_read_data_dma_callback(void *data)
 	struct at91_twi_dev *dev = (struct at91_twi_dev *)data;
 
 	dma_unmap_single(dev->dev, sg_dma_address(&dev->dma.sg),
-			 dev->buf_len, DMA_DEV_TO_MEM);
+			 dev->buf_len, DMA_FROM_DEVICE);
 
 	/* The last two bytes have to be read without using dma */
 	dev->buf += dev->buf_len - 2;
-- 
1.9.1

