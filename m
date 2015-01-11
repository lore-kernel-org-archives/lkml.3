Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbbAKW2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:28:34 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:56187 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbbAKW2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:28:31 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/nouveau/nouveau_bo: Remove unused function
Date: Sun, 11 Jan 2015 23:31:35 +0100
Message-Id: <1421015495-24744-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function nouveau_bo_rd16() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c |   12 ------------
 drivers/gpu/drm/nouveau/nouveau_bo.h |    1 -
 2 files changed, 13 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 3d474ac..7cde2e0 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -418,18 +418,6 @@ nouveau_bo_validate(struct nouveau_bo *nvbo, bool interruptible,
 	return 0;
 }
 
-u16
-nouveau_bo_rd16(struct nouveau_bo *nvbo, unsigned index)
-{
-	bool is_iomem;
-	u16 *mem = ttm_kmap_obj_virtual(&nvbo->kmap, &is_iomem);
-	mem = &mem[index];
-	if (is_iomem)
-		return ioread16_native((void __force __iomem *)mem);
-	else
-		return *mem;
-}
-
 void
 nouveau_bo_wr16(struct nouveau_bo *nvbo, unsigned index, u16 val)
 {
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.h b/drivers/gpu/drm/nouveau/nouveau_bo.h
index 22d2c76..82aaebd 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.h
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.h
@@ -77,7 +77,6 @@ int  nouveau_bo_unpin(struct nouveau_bo *);
 int  nouveau_bo_map(struct nouveau_bo *);
 void nouveau_bo_unmap(struct nouveau_bo *);
 void nouveau_bo_placement_set(struct nouveau_bo *, u32 type, u32 busy);
-u16  nouveau_bo_rd16(struct nouveau_bo *, unsigned index);
 void nouveau_bo_wr16(struct nouveau_bo *, unsigned index, u16 val);
 u32  nouveau_bo_rd32(struct nouveau_bo *, unsigned index);
 void nouveau_bo_wr32(struct nouveau_bo *, unsigned index, u32 val);
-- 
1.7.10.4

