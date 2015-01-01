Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbbAARuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:50:50 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47908 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbbAARut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:50:49 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Thierry Reding <treding@nvidia.com>, Dave Airlie <airlied@redhat.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabian Frederick <fabf@skynet.be>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: qxl: qxl_fb:  Remove some unused functions
Date: Thu,  1 Jan 2015 18:53:49 +0100
Message-Id: <1420134829-1445-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
qxl_fbdev_qobj_is_fb() qxl_get_handle_for_primary_fb()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/qxl/qxl_drv.h |    4 ----
 drivers/gpu/drm/qxl/qxl_fb.c  |   22 ----------------------
 2 files changed, 26 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_drv.h b/drivers/gpu/drm/qxl/qxl_drv.h
index 7c6cafe..090b9e0 100644
--- a/drivers/gpu/drm/qxl/qxl_drv.h
+++ b/drivers/gpu/drm/qxl/qxl_drv.h
@@ -379,9 +379,6 @@ qxl_bo_physical_address(struct qxl_device *qdev, struct qxl_bo *bo,
 
 int qxl_fbdev_init(struct qxl_device *qdev);
 void qxl_fbdev_fini(struct qxl_device *qdev);
-int qxl_get_handle_for_primary_fb(struct qxl_device *qdev,
-				  struct drm_file *file_priv,
-				  uint32_t *handle);
 void qxl_fbdev_set_suspend(struct qxl_device *qdev, int state);
 
 /* qxl_display.c */
@@ -550,7 +547,6 @@ irqreturn_t qxl_irq_handler(int irq, void *arg);
 
 /* qxl_fb.c */
 int qxl_fb_init(struct qxl_device *qdev);
-bool qxl_fbdev_qobj_is_fb(struct qxl_device *qdev, struct qxl_bo *qobj);
 
 int qxl_debugfs_add_files(struct qxl_device *qdev,
 			  struct drm_info_list *files,
diff --git a/drivers/gpu/drm/qxl/qxl_fb.c b/drivers/gpu/drm/qxl/qxl_fb.c
index 3d7c1d0..4242577 100644
--- a/drivers/gpu/drm/qxl/qxl_fb.c
+++ b/drivers/gpu/drm/qxl/qxl_fb.c
@@ -426,21 +426,6 @@ static void qxlfb_destroy_pinned_object(struct drm_gem_object *gobj)
 	drm_gem_object_unreference_unlocked(gobj);
 }
 
-int qxl_get_handle_for_primary_fb(struct qxl_device *qdev,
-				  struct drm_file *file_priv,
-				  uint32_t *handle)
-{
-	int r;
-	struct drm_gem_object *gobj = qdev->fbdev_qfb->obj;
-
-	BUG_ON(!gobj);
-	/* drm_get_handle_create adds a reference - good */
-	r = drm_gem_handle_create(file_priv, gobj, handle);
-	if (r)
-		return r;
-	return 0;
-}
-
 static int qxlfb_create_pinned_object(struct qxl_fbdev *qfbdev,
 				      struct drm_mode_fb_cmd2 *mode_cmd,
 				      struct drm_gem_object **gobj_p)
@@ -710,10 +695,3 @@ void qxl_fbdev_set_suspend(struct qxl_device *qdev, int state)
 {
 	fb_set_suspend(qdev->mode_info.qfbdev->helper.fbdev, state);
 }
-
-bool qxl_fbdev_qobj_is_fb(struct qxl_device *qdev, struct qxl_bo *qobj)
-{
-	if (qobj == gem_to_qxl_bo(qdev->mode_info.qfbdev->qfb.obj))
-		return true;
-	return false;
-}
-- 
1.7.10.4

