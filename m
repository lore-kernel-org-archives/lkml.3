Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967894Ab3DRKNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:13:15 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40870 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967838Ab3DRKNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:13:02 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 16/32] dmaengine: ste_dma40: Remove unnecessary call to d40_phy_cfg()
Date: Thu, 18 Apr 2013 11:11:58 +0100
Message-Id: <1366279934-30761-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All configuration left in d40_phy_cfg() is runtime configurable and
there is already a call into it from d40_runtime_config(), so let's
rely on that.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 178a03c..1c570b6 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2437,9 +2437,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	}
 
 	pm_runtime_get_sync(d40c->base->dev);
-	/* Fill in basic CFG register values */
-	d40_phy_cfg(&d40c->dma_cfg, &d40c->src_def_cfg,
-		    &d40c->dst_def_cfg, chan_is_logical(d40c));
 
 	d40_set_prio_realtime(d40c);
 
-- 
1.7.10.4

