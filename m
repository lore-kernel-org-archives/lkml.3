Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaFOUil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:38:41 -0400
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:35997 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752465AbaFOUie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3865:3866:3867:4250:4321:5007:6261:10004:10026:10848:11026:11658:11914:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: kick44_6794763bfe34d
X-Filterd-Recvd-Size: 2043
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: [PATCH -next 09/26] mmc: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:38 -0700
Message-Id: <1bcfedf9f6f944be57f4076d8b248a9f248a3f5d.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mmc/host/msm_sdcc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 9405ecd..3035d84 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1146,15 +1146,13 @@ msmsdcc_init_dma(struct msmsdcc_host *host)
 	if (!host->dmares)
 		return -ENODEV;
 
-	host->dma.nc = dma_alloc_coherent(NULL,
-					  sizeof(struct msmsdcc_nc_dmadata),
-					  &host->dma.nc_busaddr,
-					  GFP_KERNEL);
+	host->dma.nc = dma_zalloc_coherent(NULL,
+					   sizeof(struct msmsdcc_nc_dmadata),
+					   &host->dma.nc_busaddr, GFP_KERNEL);
 	if (host->dma.nc == NULL) {
 		pr_err("Unable to allocate DMA buffer\n");
 		return -ENOMEM;
 	}
-	memset(host->dma.nc, 0x00, sizeof(struct msmsdcc_nc_dmadata));
 	host->dma.cmd_busaddr = host->dma.nc_busaddr;
 	host->dma.cmdptr_busaddr = host->dma.nc_busaddr +
 				offsetof(struct msmsdcc_nc_dmadata, cmdptr);
-- 
1.8.1.2.459.gbcd45b4.dirty

