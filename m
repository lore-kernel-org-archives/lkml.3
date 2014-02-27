Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaB0OmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:42:13 -0500
Received: from mout.gmx.net ([212.227.17.20]:52565 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbaB0OmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:42:12 -0500
From: xypron.glpk@gmx.de
To: airlied@linux.ie
Cc: bskeggs@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH] Memory leak in nouveau_sgdma_create_ttm
Date: Thu, 27 Feb 2014 15:41:37 +0100
Message-Id: <1393512097-10597-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V03:K0:n2I77I06f1zZsIuWz+EGhgetRX62/HBGW+ewDYBhsIfzzBy21uS
 OEPFh4Atb+fEnpGM0xoXZ8tJqUY5+O/i4k/34/rRyW0+ljfAMOMhFPH2iaNS/JcXHh0cliB
 F7SRaWd3DlZclutsevszs4acCMfXvCbJEqLAbqbPJj+QPbZ+f8kYMK3NqpTVtlgsQ+hZ+hi
 sXlGIt8QVk3KrsotAmRqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

In case of failure memory was not freed.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/gpu/drm/nouveau/nouveau_sgdma.c |    4 +++-
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
1.7.10.4

