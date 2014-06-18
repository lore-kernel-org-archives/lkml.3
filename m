Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbaFRT6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:58:14 -0400
Received: from mout.gmx.net ([212.227.17.20]:56905 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbaFRT6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:58:13 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: David Airlie <airlied@linux.ie>
Cc: Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH] drm/nouveau: avoid memory leak
Date: Wed, 18 Jun 2014 21:57:47 +0200
Message-Id: <1403121467-27309-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.0.0
X-Provags-ID: V03:K0:Ou4Yacg9aG4yRiAVHsMWtzdXU7doC4bfyH7Y8dVBTHjo0QoyTNs
 GyzV/ruA0X6DjdGr6k5ny00/vjUOXT3p6J2TpO3JA2Jqm9y7NOtY+ePcwUqn9nPrJUBuVwM
 c2XZ716g2zmNpRG8K7QesRnzTdyEhUhdUrTdTUB4P7RqQRtl4mZku+Vxw8N+2DXQXwtMKkk
 X6nCzz3afuj52mMBVDVIQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ttm_dma_tt_init fails memory is leaked.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/gpu/drm/nouveau/nouveau_sgdma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
index a4d22e5..23d880b 100644
--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -109,7 +109,9 @@ nouveau_sgdma_create_ttm(struct ttm_bo_device *bdev,
 	else
 		nvbe->ttm.ttm.func = &nv50_sgdma_backend;
 
-	if (ttm_dma_tt_init(&nvbe->ttm, bdev, size, page_flags, dummy_read_page))
+	if (ttm_dma_tt_init(&nvbe->ttm, bdev, size, page_flags, dummy_read_page)) {
+		kfree(nvbe);
 		return NULL;
+	}
 	return &nvbe->ttm.ttm;
 }
-- 
2.0.0

