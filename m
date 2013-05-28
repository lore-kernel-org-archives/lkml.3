Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569Ab3E1MGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 08:06:24 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:49984 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933061Ab3E1MGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 08:06:23 -0400
From: Xiang Wang <wangxfdu@gmail.com>
To: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>
CC: <cxie4@marvell.com>, Xiang Wang <wangx@marvell.com>
Subject: [PATCH] dma: mmp_pdma: fix a memory alloc error
Date: Tue, 28 May 2013 20:05:13 +0800
Message-ID: <1369742713-13528-1-git-send-email-wangxfdu@gmail.com>
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
index c26699f..76a8dcf 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -801,7 +801,7 @@ static int mmp_pdma_probe(struct platform_device *op)
 	}
 
 	pdev->phy = devm_kzalloc(pdev->dev,
-		dma_channels * sizeof(struct mmp_pdma_chan), GFP_KERNEL);
+		dma_channels * sizeof(struct mmp_pdma_phy), GFP_KERNEL);
 	if (pdev->phy == NULL)
 		return -ENOMEM;
 
-- 
1.7.5.4

