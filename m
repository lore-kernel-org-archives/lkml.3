Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab3ENL2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:28:10 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:52667 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3ENL2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:28:08 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: djbw@fb.com
Cc: vinod.koul@intel.com, kuninori.morimoto.gx@renesas.com,
        g.liakhovetski@gmx.de, yoshihiro.shimoda.uh@renesas.com,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] drivers: dma: sh: sudmac: use devm_ioremap_resource()
Date: Tue, 14 May 2013 13:35:30 +0200
Message-Id: <1368531330-32193-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.
Found with coccicheck and this semantic patch:
 scripts/coccinelle/api/devm_ioremap_resource.cocci

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/dma/sh/sudmac.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
index e7c94bb..0a81e30 100644
--- a/drivers/dma/sh/sudmac.c
+++ b/drivers/dma/sh/sudmac.c
@@ -360,9 +360,9 @@ static int sudmac_probe(struct platform_device *pdev)
 
 	dma_dev = &su_dev->shdma_dev.dma_dev;
 
-	su_dev->chan_reg = devm_request_and_ioremap(&pdev->dev, chan);
-	if (!su_dev->chan_reg)
-		return err;
+	su_dev->chan_reg = devm_ioremap_resource(&pdev->dev, chan);
+	if (IS_ERR(su_dev->chan_reg))
+		return PTR_ERR(su_dev->chan_reg);
 
 	dma_cap_set(DMA_SLAVE, dma_dev->cap_mask);
 
-- 
1.7.10.4

