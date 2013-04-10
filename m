Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936465Ab3DJWT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:19:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56330 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3DJWTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:19:52 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 2/6] DMA: shdma: shdma_chan_filter() has to be in shdma-base.h
Date: Thu, 11 Apr 2013 00:19:45 +0200
Message-Id: <1365632389-2249-3-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:XSzhcfthTeE6l+RBTYqzqJF7O5TGXPfjZ+R8RMdITpR
 SIlKEfEq52TbZxnf/gwyWsCKHFisS3HI/ViGkmEJh/xlVCNCDM
 yfY2MQZJR058d8wRyDpe7igfwZZA++6CF7gmMzcjlJ1qEw4/R/
 kz6Oa68oN6AhUyPJs8Ov2avpByQaFBqGGUKVbOXKL1wA0lXRnZ
 65iQFUEUayVqdWAAc8mymPcJu1Yv6etWfxDhhInKZ7eVSM5wV8
 jyfTEMfqpr+Z+Kjekj/BZDY8VcagVdF0pEEtpDQGLdDfqSROGU
 dgIMjdk8nBTHiyh6Y2cbJTvD4BwfOUkO1Ys2vIyaoQ33WIFKqj
 x6X2M5UTMSwLqs3FEKdqV2jwoZuaHij8Bt5T0l+u+IRZxiRf4O
 p/0G47Y0S7lJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shdma_chan_filter() is a function, provided by the shdma-base.c module,
move its declaration to the appropriate header.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 include/linux/sh_dma.h     |    2 --
 include/linux/shdma-base.h |    1 +
 2 files changed, 1 insertions(+), 2 deletions(-)

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
1.7.2.5

