Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab3IFMER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:04:17 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34381 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3IFMEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:04:15 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, swarren@wwwdotorg.org, vinod.koul@intel.com,
        sachin.kamat@linaro.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/1] dma: tegra20-apb-dma: Staticize tegra_dma_prep_dma_cyclic
Date: Fri,  6 Sep 2013 17:16:22 +0530
Message-Id: <1378467982-30327-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tegra_dma_prep_dma_cyclic is referenced only in this file.
Make it static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/dma/tegra20-apb-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 5d4986e..67a6752 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1018,7 +1018,7 @@ static struct dma_async_tx_descriptor *tegra_dma_prep_slave_sg(
 	return &dma_desc->txd;
 }
 
-struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
+static struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
 	struct dma_chan *dc, dma_addr_t buf_addr, size_t buf_len,
 	size_t period_len, enum dma_transfer_direction direction,
 	unsigned long flags, void *context)
-- 
1.7.9.5

