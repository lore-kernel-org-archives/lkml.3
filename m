Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaLTQNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 11:13:13 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53776 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbaLTQNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 11:13:12 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Herrmann <dh.herrmann@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rashika <rashika.kheria@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: ast: ast_ttm.c:  Remove unused function
Date: Sat, 20 Dec 2014 17:15:58 +0100
Message-Id: <1419092158-6896-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function ast_bo_unpin() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/ast/ast_drv.h |    1 -
 drivers/gpu/drm/ast/ast_ttm.c |   20 --------------------
 2 files changed, 21 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index 86205a2..1f8db90 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -361,7 +361,6 @@ int ast_gem_create(struct drm_device *dev,
 		   struct drm_gem_object **obj);
 
 int ast_bo_pin(struct ast_bo *bo, u32 pl_flag, u64 *gpu_addr);
-int ast_bo_unpin(struct ast_bo *bo);
 
 static inline int ast_bo_reserve(struct ast_bo *bo, bool no_wait)
 {
diff --git a/drivers/gpu/drm/ast/ast_ttm.c b/drivers/gpu/drm/ast/ast_ttm.c
index 08f82ea..f7c183a 100644
--- a/drivers/gpu/drm/ast/ast_ttm.c
+++ b/drivers/gpu/drm/ast/ast_ttm.c
@@ -375,26 +375,6 @@ int ast_bo_pin(struct ast_bo *bo, u32 pl_flag, u64 *gpu_addr)
 	return 0;
 }
 
-int ast_bo_unpin(struct ast_bo *bo)
-{
-	int i, ret;
-	if (!bo->pin_count) {
-		DRM_ERROR("unpin bad %p\n", bo);
-		return 0;
-	}
-	bo->pin_count--;
-	if (bo->pin_count)
-		return 0;
-
-	for (i = 0; i < bo->placement.num_placement ; i++)
-		bo->placements[i].flags &= ~TTM_PL_FLAG_NO_EVICT;
-	ret = ttm_bo_validate(&bo->bo, &bo->placement, false, false);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
 int ast_bo_push_sysram(struct ast_bo *bo)
 {
 	int i, ret;
-- 
1.7.10.4

