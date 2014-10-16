Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaJPJFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:05:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36402 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429AbaJPJFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:05:04 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-rpi-kernel@lists.infradead.org
Subject: [PATCH 02/11] dmaengine: bcm2835: Remove chancnt affectations
Date: Thu, 16 Oct 2014 11:00:54 +0200
Message-Id: <1413450063-23829-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413450063-23829-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413450063-23829-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

chanctnt is already filled by dma_async_device_register, which uses the channel
list to know how much channels there is.

Since it's already filled, we can safely remove it from the drivers' probe
function.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/bcm2835-dma.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
index 68007974961a..def66fbbb7f3 100644
--- a/drivers/dma/bcm2835-dma.c
+++ b/drivers/dma/bcm2835-dma.c
@@ -525,8 +525,6 @@ static int bcm2835_dma_chan_init(struct bcm2835_dmadev *d, int chan_id, int irq)
 	vchan_init(&c->vc, &d->ddev);
 	INIT_LIST_HEAD(&c->node);
 
-	d->ddev.chancnt++;
-
 	c->chan_base = BCM2835_DMA_CHANIO(d->base, chan_id);
 	c->ch = chan_id;
 	c->irq_number = irq;
-- 
2.1.1

