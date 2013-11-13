Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab3KMGaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 01:30:13 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44832 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3KMGaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 01:30:07 -0500
From: Olof Johansson <olof@lixom.net>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH 2/2] dma: imx-sdma: Fix warnings for LPAE builds
Date: Tue, 12 Nov 2013 22:30:44 -0800
Message-Id: <1384324244-11330-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1384324244-11330-1-git-send-email-olof@lixom.net>
References: <1384324244-11330-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This resolves a number of warnings such as the below when building with
64-bit dma_addr_t on arm:

drivers/dma/imx-sdma.c:1092:3: warning: format '%x' expects argument of
  type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]

..by upcasting to u64 and using %llx.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/dma/imx-sdma.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index e43c040..4088ff8 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1089,8 +1089,8 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
 			param &= ~BD_CONT;
 		}
 
-		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",
-				i, count, sg->dma_address,
+		dev_dbg(sdma->dev, "entry %d: count: %d dma: %#llx %s%s\n",
+				i, count, (u64)sg->dma_address,
 				param & BD_WRAP ? "wrap" : "",
 				param & BD_INTR ? " intr" : "");
 
@@ -1163,8 +1163,8 @@ static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
 		if (i + 1 == num_periods)
 			param |= BD_WRAP;
 
-		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",
-				i, period_len, dma_addr,
+		dev_dbg(sdma->dev, "entry %d: count: %d dma: %#llx %s%s\n",
+				i, period_len, (u64)dma_addr,
 				param & BD_WRAP ? "wrap" : "",
 				param & BD_INTR ? " intr" : "");
 
-- 
1.7.10.4

