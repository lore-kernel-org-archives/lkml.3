Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966044AbaLLGs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:48:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966000AbaLLGsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:48:21 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mark Brown" <broonie@kernel.org>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.117751536@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 025/164] spi: dw-mid: respect 8 bit mode
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit b41583e7299046abdc578c33f25ed83ee95b9b31 upstream.

In case of 8 bit mode and DMA usage we end up with every second byte written as
0. We have to respect bits_per_word settings what this patch actually does.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/spi/spi-dw-mid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -135,7 +135,7 @@ static int mid_spi_dma_transfer(struct d
 	txconf.dst_addr = dws->dma_addr;
 	txconf.dst_maxburst = LNW_DMA_MSIZE_16;
 	txconf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-	txconf.dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	txconf.dst_addr_width = dws->dma_width;
 
 	txchan->device->device_control(txchan, DMA_SLAVE_CONFIG,
 				       (unsigned long) &txconf);
@@ -157,7 +157,7 @@ static int mid_spi_dma_transfer(struct d
 	rxconf.src_addr = dws->dma_addr;
 	rxconf.src_maxburst = LNW_DMA_MSIZE_16;
 	rxconf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-	rxconf.src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	rxconf.src_addr_width = dws->dma_width;
 
 	rxchan->device->device_control(rxchan, DMA_SLAVE_CONFIG,
 				       (unsigned long) &rxconf);

