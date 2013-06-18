Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3FRGYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 02:24:38 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:46633 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444Ab3FRGYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 02:24:37 -0400
From: Xiang Wang <wangxfdu@gmail.com>
To: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>
CC: <wangxfdu@gmail.com>, <cxie4@marvell.com>, Xiang Wang <wangx@marvell.com>
Subject: [PATCH v2] dma: mmp_pdma: fix a memory alloc error
Date: Tue, 18 Jun 2013 14:21:58 +0800
Message-ID: <1371536519-7837-1-git-send-email-wangxfdu@gmail.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiang Wang <wangx@marvell.com>

pdev->phy is of type "struct mmp_pdma_phy *". But when
allocating memory for it, "struct mmp_pdma_chan" is used
by mistake.

Signed-off-by: Xiang Wang <wangx@marvell.com>
---
 drivers/dma/mmp_pdma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index c26699f..18ac57f 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -801,7 +801,7 @@ static int mmp_pdma_probe(struct platform_device *op)
 	}
 
 	pdev->phy = devm_kzalloc(pdev->dev,
-		dma_channels * sizeof(struct mmp_pdma_chan), GFP_KERNEL);
+		dma_channels * sizeof(*pdev->phy), GFP_KERNEL);
 	if (pdev->phy == NULL)
 		return -ENOMEM;
 
-- 
1.7.5.4

