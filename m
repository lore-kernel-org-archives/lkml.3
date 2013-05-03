Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab3ECOqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:46:54 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:53221 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933437Ab3ECOeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:34:07 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 21/63] dmaengine: ste_dma40: Don't configure runtime configurable setup during allocate
Date: Fri,  3 May 2013 15:32:07 +0100
Message-Id: <1367591569-32197-22-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the dmaengine API, allocating and configuring a channel are two
separate actions. Here we're removing logical channel configuration from
the channel allocating routines.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 8bff463..34e0fb0 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2024,6 +2024,9 @@ static int d40_config_memcpy(struct d40_chan *d40c)
 		d40c->dma_cfg = dma40_memcpy_conf_log;
 		d40c->dma_cfg.dev_type = dma40_memcpy_channels[d40c->chan.chan_id];
 
+		d40_log_cfg(&d40c->dma_cfg,
+			    &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
+
 	} else if (dma_has_cap(DMA_MEMCPY, cap) &&
 		   dma_has_cap(DMA_SLAVE, cap)) {
 		d40c->dma_cfg = dma40_memcpy_conf_phy;
@@ -2448,9 +2451,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	d40_set_prio_realtime(d40c);
 
 	if (chan_is_logical(d40c)) {
-		d40_log_cfg(&d40c->dma_cfg,
-			    &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
-
 		if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
 			d40c->lcpa = d40c->base->lcpa_base +
 				d40c->dma_cfg.dev_type * D40_LCPA_CHAN_SIZE;
-- 
1.7.10.4

