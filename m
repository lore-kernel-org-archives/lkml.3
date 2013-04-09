Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936536Ab3DIHMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:12:00 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:61448 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934744Ab3DIHL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:11:59 -0400
Date: Tue, 9 Apr 2013 08:11:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>
Subject: [PATCH 4/5] dmaengine: ste_dma40: Do not configure channels during
 an channel allocation
Message-ID: <20130409071154.GH3084@gmail.com>
References: <1365434591-21569-1-git-send-email-lee.jones@linaro.org>
 <1365434591-21569-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365434591-21569-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the DMA documentation allocating a channel and configuring
it are two separate actions. By removing the configuration code from the
channel allocation path we lighten the burden on the information required to
successfully allocate a channel.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ecca492..3543ea4 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2471,16 +2471,10 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	}
 
 	pm_runtime_get_sync(d40c->base->dev);
-	/* Fill in basic CFG register values */
-	d40_phy_cfg(&d40c->dma_cfg, &d40c->src_def_cfg,
-		    &d40c->dst_def_cfg, chan_is_logical(d40c));
 
 	d40_set_prio_realtime(d40c);
 
 	if (chan_is_logical(d40c)) {
-		d40_log_cfg(&d40c->dma_cfg,
-			    &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
-
 		if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
 			d40c->lcpa = d40c->base->lcpa_base +
 				d40c->dma_cfg.src_dev_type * D40_LCPA_CHAN_SIZE;
-- 
1.7.10.4
