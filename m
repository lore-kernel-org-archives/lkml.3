Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbbAMS66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:58:58 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:42262 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbbAMS65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:58:57 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/radeon/radeon_fb: Remove unused function
Date: Tue, 13 Jan 2015 20:02:03 +0100
Message-Id: <1421175723-6893-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function radeon_fbdev_total_size() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/radeon_fb.c   |   10 ----------
 drivers/gpu/drm/radeon/radeon_mode.h |    1 -
 2 files changed, 11 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index 0ea1db8..76adbdb 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -389,16 +389,6 @@ void radeon_fbdev_set_suspend(struct radeon_device *rdev, int state)
 	fb_set_suspend(rdev->mode_info.rfbdev->helper.fbdev, state);
 }
 
-int radeon_fbdev_total_size(struct radeon_device *rdev)
-{
-	struct radeon_bo *robj;
-	int size = 0;
-
-	robj = gem_to_radeon_bo(rdev->mode_info.rfbdev->rfb.obj);
-	size += radeon_bo_size(robj);
-	return size;
-}
-
 bool radeon_fbdev_robj_is_fb(struct radeon_device *rdev, struct radeon_bo *robj)
 {
 	if (robj == gem_to_radeon_bo(rdev->mode_info.rfbdev->rfb.obj))
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 04db2fd..ec2014a 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -915,7 +915,6 @@ void dce8_program_fmt(struct drm_encoder *encoder);
 int radeon_fbdev_init(struct radeon_device *rdev);
 void radeon_fbdev_fini(struct radeon_device *rdev);
 void radeon_fbdev_set_suspend(struct radeon_device *rdev, int state);
-int radeon_fbdev_total_size(struct radeon_device *rdev);
 bool radeon_fbdev_robj_is_fb(struct radeon_device *rdev, struct radeon_bo *robj);
 
 void radeon_fb_output_poll_changed(struct radeon_device *rdev);
-- 
1.7.10.4

