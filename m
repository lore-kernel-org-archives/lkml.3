Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936535Ab3DRTob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 15:44:31 -0400
Received: from mout.gmx.net ([212.227.17.22]:50600 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936351Ab3DRToa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 15:44:30 -0400
X-Authenticated: #181789
X-Provags-ID: V01U2FsdGVkX19CZI8xIo1C2Fxni+/h8cFKmeDvhR1lr9ncK1YLh+
	qfC5EuuPaUA4+5
From: Christian Eggers <ceggers@gmx.de>
To: Matt Porter <mporter@ti.com>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: spi: spi-davinci: Fix direction in dma_map_single()
Date: Thu, 18 Apr 2013 21:44:21 +0200
Message-ID: <8339377.qGdTICXBF1@p2400>
User-Agent: KMail/4.8.5 (Linux/3.8.6-2-desktop; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 048177ce3b3962852fd34a7e04938959271c7e70 (spi: spi-davinci: 
convert to DMA engine API) introduced a regression: dma_map_single() 
is called with direction DMA_FROM_DEVICE for rx and for tx.

Signed-off-by: Christian Eggers <ceggers@gmx.de>
Cc: stable@vger.kernel.org
---
--- drivers/spi/spi-davinci.c.orig	2013-04-18 20:54:02.728719412 +0200
+++ drivers/spi/spi-davinci.c	2013-04-18 20:54:51.900623956 +0200
@@ -608,7 +608,7 @@ static int davinci_spi_bufs(struct spi_d
 		else
 			buf = (void *)t->tx_buf;
 		t->tx_dma = dma_map_single(&spi->dev, buf,
-				t->len, DMA_FROM_DEVICE);
+				t->len, DMA_TO_DEVICE);
 		if (!t->tx_dma) {
 			ret = -EFAULT;
 			goto err_tx_map;



