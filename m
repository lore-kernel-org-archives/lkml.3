Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab3GIOiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:38:12 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37672 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab3GIOiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:38:07 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, hi@hello.com,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 2/3] DMA: shdma: shdma_chan_filter() has to be in shdma-base.h
Date: Tue,  9 Jul 2013 15:37:55 +0100
Message-Id: <1373380677-450-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373380677-450-1-git-send-email-lee.jones@linaro.org>
References: <1373380677-450-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

shdma_chan_filter() is a function, provided by the shdma-base.c module,
move its declaration to the appropriate header.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 include/linux/sh_dma.h     |    2 --
 include/linux/shdma-base.h |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
index b64d6be..4e83f3e 100644
--- a/include/linux/sh_dma.h
+++ b/include/linux/sh_dma.h
@@ -99,6 +99,4 @@ struct sh_dmae_pdata {
 #define CHCR_TE	0x00000002
 #define CHCR_IE	0x00000004
 
-bool shdma_chan_filter(struct dma_chan *chan, void *arg);
-
 #endif
diff --git a/include/linux/shdma-base.h b/include/linux/shdma-base.h
index a3728bf..9a93897 100644
--- a/include/linux/shdma-base.h
+++ b/include/linux/shdma-base.h
@@ -122,5 +122,6 @@ void shdma_chan_remove(struct shdma_chan *schan);
 int shdma_init(struct device *dev, struct shdma_dev *sdev,
 		    int chan_num);
 void shdma_cleanup(struct shdma_dev *sdev);
+bool shdma_chan_filter(struct dma_chan *chan, void *arg);
 
 #endif
-- 
1.7.10.4

