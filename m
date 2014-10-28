Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbaJ1FW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 01:22:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859AbaJ1DwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:52:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 09/43] spi: dw-mid: respect 8 bit mode
Date: Tue, 28 Oct 2014 11:36:07 +0800
Message-Id: <20141028033523.805730513@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033523.407092670@linuxfoundation.org>
References: <20141028033523.407092670@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit b41583e7299046abdc578c33f25ed83ee95b9b31 upstream.

In case of 8 bit mode and DMA usage we end up with every second byte written as
0. We have to respect bits_per_word settings what this patch actually does.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-dw-mid.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -136,7 +136,7 @@ static int mid_spi_dma_transfer(struct d
 	txconf.dst_addr = dws->dma_addr;
 	txconf.dst_maxburst = LNW_DMA_MSIZE_16;
 	txconf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-	txconf.dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	txconf.dst_addr_width = dws->dma_width;
 	txconf.device_fc = false;
 
 	txchan->device->device_control(txchan, DMA_SLAVE_CONFIG,
@@ -159,7 +159,7 @@ static int mid_spi_dma_transfer(struct d
 	rxconf.src_addr = dws->dma_addr;
 	rxconf.src_maxburst = LNW_DMA_MSIZE_16;
 	rxconf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-	rxconf.src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	rxconf.src_addr_width = dws->dma_width;
 	rxconf.device_fc = false;
 
 	rxchan->device->device_control(rxchan, DMA_SLAVE_CONFIG,


