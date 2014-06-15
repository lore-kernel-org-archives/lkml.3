Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaFOUjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:39:22 -0400
Received: from smtprelay0076.hostedemail.com ([216.40.44.76]:49882 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752858AbaFOUjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:39:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:857:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:4321:4605:5007:6261:10004:10026:10848:11026:11233:11658:11914:12043:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ship06_6e0e2d6856a2d
X-Filterd-Recvd-Size: 1988
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH -next 25/26] fbdev: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:54 -0700
Message-Id: <881b8f8d85c96b6e9d8735aa10bbf18468688b9d.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/fbdev/da8xx-fb.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/da8xx-fb.c b/drivers/video/fbdev/da8xx-fb.c
index a8484f7..788f6b3 100644
--- a/drivers/video/fbdev/da8xx-fb.c
+++ b/drivers/video/fbdev/da8xx-fb.c
@@ -1447,18 +1447,15 @@ static int fb_probe(struct platform_device *device)
 		da8xx_fb_fix.line_length - 1;
 
 	/* allocate palette buffer */
-	par->v_palette_base = dma_alloc_coherent(NULL,
-					       PALETTE_SIZE,
-					       (resource_size_t *)
-					       &par->p_palette_base,
-					       GFP_KERNEL | GFP_DMA);
+	par->v_palette_base = dma_zalloc_coherent(NULL, PALETTE_SIZE,
+						  (resource_size_t *)&par->p_palette_base,
+						  GFP_KERNEL | GFP_DMA);
 	if (!par->v_palette_base) {
 		dev_err(&device->dev,
 			"GLCD: kmalloc for palette buffer failed\n");
 		ret = -EINVAL;
 		goto err_release_fb_mem;
 	}
-	memset(par->v_palette_base, 0, PALETTE_SIZE);
 
 	par->irq = platform_get_irq(device, 0);
 	if (par->irq < 0) {
-- 
1.8.1.2.459.gbcd45b4.dirty

