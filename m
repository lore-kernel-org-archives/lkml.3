Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaFOUit (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:38:49 -0400
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:37044 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752465AbaFOUio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3350:3865:3866:4321:4385:5007:6261:8603:9592:10004:10026:10848:11026:11657:11658:11914:12043:12296:12438:12517:12519:12555:13311:
X-HE-Tag: waves96_68e0d9b13df5a
X-Filterd-Recvd-Size: 2197
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: [PATCH -next 12/26] intel: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:41 -0700
Message-Id: <98cd6b066087e10da2dbf2a92080197a40a5e4ec.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/intel/ixgb/ixgb_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 6080127..b02cc72 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -795,14 +795,12 @@ ixgb_setup_rx_resources(struct ixgb_adapter *adapter)
 	rxdr->size = rxdr->count * sizeof(struct ixgb_rx_desc);
 	rxdr->size = ALIGN(rxdr->size, 4096);
 
-	rxdr->desc = dma_alloc_coherent(&pdev->dev, rxdr->size, &rxdr->dma,
-					GFP_KERNEL);
-
+	rxdr->desc = dma_zalloc_coherent(&pdev->dev, rxdr->size, &rxdr->dma,
+					 GFP_KERNEL);
 	if (!rxdr->desc) {
 		vfree(rxdr->buffer_info);
 		return -ENOMEM;
 	}
-	memset(rxdr->desc, 0, rxdr->size);
 
 	rxdr->next_to_clean = 0;
 	rxdr->next_to_use = 0;
-- 
1.8.1.2.459.gbcd45b4.dirty

