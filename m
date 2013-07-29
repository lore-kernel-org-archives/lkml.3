Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab3G2SyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:54:23 -0400
Received: from mout.gmx.net ([212.227.15.19]:55169 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab3G2SyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:54:22 -0400
From: Christian Eggers <ceggers@gmx.de>
To: spi-devel-general@lists.sourceforge.net, Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [resubmit2] [PATCH] spi: spi-davinci: Fix direction in dma_map_single()
Date: Mon, 29 Jul 2013 20:54:09 +0200
Message-ID: <1388690.s58sU4PUYE@p2400>
User-Agent: KMail/4.8.5 (Linux/3.9.4-1.g51bf0ff-desktop; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:NSbkt18i0a69IIiBjhYhnjPVjRxEYqxVJZFYePuzA/Vmz3JKEUu
 9gKx0a3Mn8K7pgMItzLYZm8xxT7u1fBhJDPgyTuCxb/vMsTwJ1L2fCQaqcCwcJh7oTG7l4z
 299ApfUNjvWIjPe443BuMojG5Q9Jw5QD9Su+Sci9gSnhCtO2+022K64xGbraOP45k/QN//p
 zAxKdco9FS+Sy34DO9+9w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch I already sent on 2013-04-18 and 2013-06-06. 
Unfortunately it hasn't been committed yet.

Commit 048177ce3b3962852fd34a7e04938959271c7e70 (spi: spi-davinci: 
convert to DMA engine API) introduced a regression: dma_map_single() 
is called with direction DMA_FROM_DEVICE for rx and for tx.

Signed-off-by: Christian Eggers <ceggers@gmx.de>
Cc: stable@vger.kernel.org # v3.7.x+
Acked-by: Matt Porter <mporter@ti.com>
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

