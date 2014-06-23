Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbaFWNtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:49:32 -0400
Received: from smtprelay0096.hostedemail.com ([216.40.44.96]:45016 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755809AbaFWNmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3350:3865:4419:4605:5007:6261:10004:10026:10848:11026:11657:11658:11914:12043:12114:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stop67_892c038934a0b
X-Filterd-Recvd-Size: 1812
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 06/22] i810: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:34 -0700
Message-Id: <35ea0a682ee80b86e38172d4a5a7a2ad9ec7d274.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/i810/i810_dma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i810/i810_dma.c b/drivers/gpu/drm/i810/i810_dma.c
index e88bac1..bae897d 100644
--- a/drivers/gpu/drm/i810/i810_dma.c
+++ b/drivers/gpu/drm/i810/i810_dma.c
@@ -393,15 +393,14 @@ static int i810_dma_initialize(struct drm_device *dev,
 
 	/* Program Hardware Status Page */
 	dev_priv->hw_status_page =
-	    pci_alloc_consistent(dev->pdev, PAGE_SIZE,
-				 &dev_priv->dma_status_page);
+		pci_zalloc_consistent(dev->pdev, PAGE_SIZE,
+				      &dev_priv->dma_status_page);
 	if (!dev_priv->hw_status_page) {
 		dev->dev_private = (void *)dev_priv;
 		i810_dma_cleanup(dev);
 		DRM_ERROR("Can not allocate hardware status page\n");
 		return -ENOMEM;
 	}
-	memset(dev_priv->hw_status_page, 0, PAGE_SIZE);
 	DRM_DEBUG("hw status page @ %p\n", dev_priv->hw_status_page);
 
 	I810_WRITE(0x02080, dev_priv->dma_status_page);
-- 
1.8.1.2.459.gbcd45b4.dirty

