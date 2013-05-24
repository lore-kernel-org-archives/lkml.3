Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab3EXUBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 16:01:20 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:53428 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab3EXUBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 16:01:18 -0400
From: Fabio Estevam <festevam@gmail.com>
To: vinod.koul@intel.com
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] dma: mxs-dma: Staticize mxs_dma_xlate
Date: Fri, 24 May 2013 16:37:27 -0300
Message-Id: <1369424247-12439-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Fix the following sparse warning:

drivers/dma/mxs-dma.c:696:17: warning: symbol 'mxs_dma_xlate' was not declared. Should it be static?

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/mxs-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index b48a79c..7195930 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -693,7 +693,7 @@ static bool mxs_dma_filter_fn(struct dma_chan *chan, void *fn_param)
 	return true;
 }
 
-struct dma_chan *mxs_dma_xlate(struct of_phandle_args *dma_spec,
+static struct dma_chan *mxs_dma_xlate(struct of_phandle_args *dma_spec,
 			       struct of_dma *ofdma)
 {
 	struct mxs_dma_engine *mxs_dma = ofdma->of_dma_data;
-- 
1.8.1.2

