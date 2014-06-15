Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaFOUov (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:44:51 -0400
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:40110 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752425AbaFOUi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3308:3352:3865:3866:3871:4321:4385:5007:6119:6261:7903:8603:9592:10004:10026:10848:11026:11658:11914:12043:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sleep94_66cb5f0ca1d44
X-Filterd-Recvd-Size: 1732
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH -next 07/26] gpu: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:36 -0700
Message-Id: <2f6c99d3d0944dd2fb17805fdb76728e4bcf3071.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/drm_pci.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index 020cfd9..6b3ca60 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -55,15 +55,13 @@ drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t ali
 		return NULL;
 
 	dmah->size = size;
-	dmah->vaddr = dma_alloc_coherent(&dev->pdev->dev, size, &dmah->busaddr, GFP_KERNEL | __GFP_COMP);
-
+	dmah->vaddr = dma_zalloc_coherent(&dev->pdev->dev, size, &dmah->busaddr,
+					  GFP_KERNEL | __GFP_COMP);
 	if (dmah->vaddr == NULL) {
 		kfree(dmah);
 		return NULL;
 	}
 
-	memset(dmah->vaddr, 0, size);
-
 	/* XXX - Is virt_to_page() legal for consistent mem? */
 	/* Reserve */
 	for (addr = (unsigned long)dmah->vaddr, sz = size;
-- 
1.8.1.2.459.gbcd45b4.dirty

