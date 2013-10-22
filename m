Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3JVPMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:12:08 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:34777 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3JVPLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:11:09 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>, Merav Sicron <meravs@broadcom.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the arm tree
Date: Tue, 22 Oct 2013 17:08:35 +0200
Message-Id: <1382454517-4074-2-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382454517-4074-1-git-send-email-treding@nvidia.com>
References: <1382454517-4074-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the arm tree got a conflict in

	drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c

caused by commits 1bfa2c4 (DMA-API: net: broadcom/bnx2x: replace
dma_set_mask()+dma_set_coherent_mask() with new helper) and edd3147
(bnx2x: Set NETIF_F_HIGHDMA unconditionally).

I fixed it up (see below). Please verify that the resolution looks good.

Thanks,
Thierry
---
diff --cc drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index b42f89c,38bf998..767aafb
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@@ -12117,12 -12079,9 +12117,8 @@@ static int bnx2x_set_coherency_mask(str
  {
  	struct device *dev = &bp->pdev->dev;
  
- 	if (dma_set_mask(dev, DMA_BIT_MASK(64)) == 0) {
- 		if (dma_set_coherent_mask(dev, DMA_BIT_MASK(64)) != 0) {
- 			dev_err(dev, "dma_set_coherent_mask failed, aborting\n");
- 			return -EIO;
- 		}
- 	} else if (dma_set_mask(dev, DMA_BIT_MASK(32)) != 0) {
 -	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) == 0) {
 -		bp->flags |= USING_DAC_FLAG;
 -	} else if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32)) != 0) {
++	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) != 0 &&
++	    dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32)) != 0) {
  		dev_err(dev, "System does not support DMA, aborting\n");
  		return -EIO;
  	}
