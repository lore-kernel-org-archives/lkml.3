Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967879Ab3DRKNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:13:13 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:52996 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967796Ab3DRKNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:13:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 18/32] dmaengine: ste_dma40: Don't configure runtime configurable setup during allocate
Date: Thu, 18 Apr 2013 11:12:00 +0100
Message-Id: <1366279934-30761-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
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
 drivers/dma/ste_dma40.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ff41972..04cc75f 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2441,9 +2441,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
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

