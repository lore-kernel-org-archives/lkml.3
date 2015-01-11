Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbbAKNOP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 08:14:15 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:45296 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbbAKNOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 08:14:14 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: radeon: radeon_object: Remove unused function
Date: Sun, 11 Jan 2015 14:17:19 +0100
Message-Id: <1420982239-16892-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function radeon_bo_fbdev_mmap() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/radeon_object.c |    6 ------
 drivers/gpu/drm/radeon/radeon_object.h |    2 --
 2 files changed, 8 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index 99a960a..4f2515f 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -542,12 +542,6 @@ int radeon_bo_list_validate(struct radeon_device *rdev,
 	return 0;
 }
 
-int radeon_bo_fbdev_mmap(struct radeon_bo *bo,
-			     struct vm_area_struct *vma)
-{
-	return ttm_fbdev_mmap(vma, &bo->tbo);
-}
-
 int radeon_bo_get_surface_reg(struct radeon_bo *bo)
 {
 	struct radeon_device *rdev = bo->rdev;
diff --git a/drivers/gpu/drm/radeon/radeon_object.h b/drivers/gpu/drm/radeon/radeon_object.h
index 1b8ec79..1cf3cd9 100644
--- a/drivers/gpu/drm/radeon/radeon_object.h
+++ b/drivers/gpu/drm/radeon/radeon_object.h
@@ -143,8 +143,6 @@ extern void radeon_bo_fini(struct radeon_device *rdev);
 extern int radeon_bo_list_validate(struct radeon_device *rdev,
 				   struct ww_acquire_ctx *ticket,
 				   struct list_head *head, int ring);
-extern int radeon_bo_fbdev_mmap(struct radeon_bo *bo,
-				struct vm_area_struct *vma);
 extern int radeon_bo_set_tiling_flags(struct radeon_bo *bo,
 				u32 tiling_flags, u32 pitch);
 extern void radeon_bo_get_tiling_flags(struct radeon_bo *bo,
-- 
1.7.10.4

