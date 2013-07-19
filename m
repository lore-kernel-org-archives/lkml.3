Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934492Ab3GSQbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:31:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62668 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933381Ab3GSQ3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:29:44 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v2 06/15] DMA: shdma: make multiplexer platform data optional
Date: Fri, 19 Jul 2013 18:29:31 +0200
Message-Id: <1374251374-30186-7-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de>
References: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:sBfcUZF1o/dqe01JKnjr5ZFODEKX2aptaB01P+rbSeT
 Cf7A4KDxERspZS1fmkkeIojFeap6Di3YMMlWFRB0DdNbS18PAC
 d8Z3zQDSHp/lRrkqEF+l0fKezsCSHJ66biTbHq57RHA25TMUQK
 v8JDqN+hjpS3/0dZ8X1CMKVI0JAUouNYapEqus2anQs7xG0niL
 YYzzNg0VSLVEwk5nKvs6a+Ui+I7sc8GO55XAQ7mAjyfj/e8L1j
 wg2ATVQaMUV5CrPHs8SdKOwdx2euYNFYlb+xrYDAtN+bWc3Xuy
 hQS31Nnf1aqR1aEBT+cH2RiUhncwJtM97awTJmhB/J348DzjFs
 h4z1Bf7S/zORzpfI5+Mb1VgcGcUHENKY8awFDmqyPkk+HBByp+
 gRdiFvviCDtGA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of supplying platform data to the shdma dmaengine driver via
AUXDATA in the DT case, we now support platform data via an OF match table.
Make platform data optional.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/dma/sh/shdma-of.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/sh/shdma-of.c b/drivers/dma/sh/shdma-of.c
index 11bcb05..2acf7b6 100644
--- a/drivers/dma/sh/shdma-of.c
+++ b/drivers/dma/sh/shdma-of.c
@@ -45,9 +45,6 @@ static int shdma_of_probe(struct platform_device *pdev)
 	const struct of_dev_auxdata *lookup = pdev->dev.platform_data;
 	int ret;
 
-	if (!lookup)
-		return -EINVAL;
-
 	ret = of_dma_controller_register(pdev->dev.of_node,
 					 shdma_of_xlate, pdev);
 	if (ret < 0)
-- 
1.7.2.5

