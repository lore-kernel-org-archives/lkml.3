Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbaICKFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:05:23 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57433 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932307AbaICJ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:57:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 39/56] drivers/i2c/busses: use correct type for dma_map/unmap
Date: Wed,  3 Sep 2014 11:26:58 +0200
Message-Id: <54a4167859c75a9bd83434b7547ebd398aeb2d05.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <wsa@the-dreams.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 28772ac8711e4d7268c06e765887dd8cb6924f98 upstream.

dma_{un}map_* uses 'enum dma_data_direction' not 'enum dma_transfer_direction'.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/i2c/busses/i2c-at91.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index fd059308affa..9d3e846e0137 100644
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
2.1.0

