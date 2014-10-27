Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaJ0TDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:03:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52686 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbaJ0TDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 039/105] spi: dw-mid: respect 8 bit mode
Date: Mon, 27 Oct 2014 11:56:14 -0700
Message-Id: <1414436240-13879-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit b41583e7299046abdc578c33f25ed83ee95b9b31 upstream.

In case of 8 bit mode and DMA usage we end up with every second byte written as
0. We have to respect bits_per_word settings what this patch actually does.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/spi/spi-dw-mid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index 6d207af..48c170c 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -136,7 +136,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 	txconf.dst_addr = dws->dma_addr;
 	txconf.dst_maxburst = LNW_DMA_MSIZE_16;
 	txconf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-	txconf.dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	txconf.dst_addr_width = dws->dma_width;
 	txconf.device_fc = false;
 
 	txchan->device->device_control(txchan, DMA_SLAVE_CONFIG,
@@ -159,7 +159,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 	rxconf.src_addr = dws->dma_addr;
 	rxconf.src_maxburst = LNW_DMA_MSIZE_16;
 	rxconf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-	rxconf.src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	rxconf.src_addr_width = dws->dma_width;
 	rxconf.device_fc = false;
 
 	rxchan->device->device_control(rxchan, DMA_SLAVE_CONFIG,
-- 
1.9.1

