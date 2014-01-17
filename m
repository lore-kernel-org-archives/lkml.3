Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaAQRGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:06:36 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:54283 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaAQRGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:06:32 -0500
Message-ID: <52D96315.9090604@koalo.de>
Date: Fri, 17 Jan 2014 18:06:29 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
CC: linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH] dmaengine: Add DMA_PRIVATE to BCM2835 driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without DMA_PRIVATE the driver is not able to allocate more than one channel.
Since it uses dma_get_any_slave_channel that calls private_candidate,
the second allocation fails at
/* some channels are already publicly allocated */
Maybe it should be fixed in the core, but at least this fixes the bug.

Signed-off-by: Florian Meier <florian.meier@koalo.de>
---
 drivers/dma/bcm2835-dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
index 6ae0708..a036021 100644
--- a/drivers/dma/bcm2835-dma.c
+++ b/drivers/dma/bcm2835-dma.c
@@ -611,6 +611,7 @@ static int bcm2835_dma_probe(struct platform_device *pdev)
 	od->base = base;
 
 	dma_cap_set(DMA_SLAVE, od->ddev.cap_mask);
+	dma_cap_set(DMA_PRIVATE, od->ddev.cap_mask);
 	dma_cap_set(DMA_CYCLIC, od->ddev.cap_mask);
 	od->ddev.device_alloc_chan_resources = bcm2835_dma_alloc_chan_resources;
 	od->ddev.device_free_chan_resources = bcm2835_dma_free_chan_resources;
-- 
1.8.3.2
