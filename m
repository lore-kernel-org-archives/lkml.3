Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965142Ab3GSQbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:31:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61053 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119Ab3GSQ3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:29:43 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v2 08/15] DMA: shdma: move two macros to a header
Date: Fri, 19 Jul 2013 18:29:33 +0200
Message-Id: <1374251374-30186-9-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de>
References: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:OuYQofZk3Xa7y2GABiWoffH3v/eHcxHCmDBH2i6hUdn
 AWzgHwbgq2w9lm3Mc/H0FYbSXC0IhJGsDW/4vDDmUzxiCL3liA
 PY5Nr1n4aCGWgrTJu9L6vF34X56WU1CxNwm+O3A85XKm0I7TqH
 Ni/FisIL4AIpSj6PNr1nt+oTAiqJTC7iRcmt/qgy5FtmH2K1+J
 jbzzxbuEtPVBi399FrE03HDxc5t8Dtw8VSdGeX2eWKoaISu5bq
 tdE9T/4rz+T85t8zMyoaIxVDmmjxpnAkp4M2/kc6wELFHytNCY
 A6+/k2EAqpaYmUI31qzbKWJk0MJ7U72+TKepl7qgGpieF13AtD
 KBIuBI8ViRvZF0RFIJ+o4Mj29js1dfH2FETQlcHrC/IDJ8uJY0
 9/vSBFj+ptDfQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move two generic pointer-conversion macros to a header for common shdma use.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/dma/sh/shdma-base.c |    3 ---
 drivers/dma/sh/shdma-of.c   |    2 --
 include/linux/shdma-base.h  |    3 +++
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index c5ea256..5b92e72 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -36,9 +36,6 @@ enum shdma_desc_status {
 
 #define NR_DESCS_PER_CHANNEL 32
 
-#define to_shdma_chan(c) container_of(c, struct shdma_chan, dma_chan)
-#define to_shdma_dev(d) container_of(d, struct shdma_dev, dma_dev)
-
 /*
  * For slave DMA we assume, that there is a finite number of DMA slaves in the
  * system, and that each such slave can only use a finite number of channels.
diff --git a/drivers/dma/sh/shdma-of.c b/drivers/dma/sh/shdma-of.c
index 2acf7b6..80d07b5 100644
--- a/drivers/dma/sh/shdma-of.c
+++ b/drivers/dma/sh/shdma-of.c
@@ -17,8 +17,6 @@
 #include <linux/platform_device.h>
 #include <linux/shdma-base.h>
 
-#define to_shdma_chan(c) container_of(c, struct shdma_chan, dma_chan)
-
 static struct dma_chan *shdma_of_xlate(struct of_phandle_args *dma_spec,
 				       struct of_dma *ofdma)
 {
diff --git a/include/linux/shdma-base.h b/include/linux/shdma-base.h
index 31cf89f..45191d7 100644
--- a/include/linux/shdma-base.h
+++ b/include/linux/shdma-base.h
@@ -114,6 +114,9 @@ struct shdma_dev {
 #define shdma_for_each_chan(c, d, i) for (i = 0, c = (d)->schan[0]; \
 				i < (d)->dma_dev.chancnt; c = (d)->schan[++i])
 
+#define to_shdma_chan(c) container_of(c, struct shdma_chan, dma_chan)
+#define to_shdma_dev(d) container_of(d, struct shdma_dev, dma_dev)
+
 int shdma_request_irq(struct shdma_chan *, int,
 			   unsigned long, const char *);
 bool shdma_reset(struct shdma_dev *sdev);
-- 
1.7.2.5

