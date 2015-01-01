Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbbAAQuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 11:50:12 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:54084 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbAAQuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 11:50:10 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: qxl: qxl_gem.c:  Remove some unused functions
Date: Thu,  1 Jan 2015 17:53:10 +0100
Message-Id: <1420131190-30078-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
qxl_gem_fini() qxl_gem_init()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/qxl/qxl_drv.h |    2 --
 drivers/gpu/drm/qxl/qxl_gem.c |   11 -----------
 2 files changed, 13 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_drv.h b/drivers/gpu/drm/qxl/qxl_drv.h
index 7c6cafe..32b7743 100644
--- a/drivers/gpu/drm/qxl/qxl_drv.h
+++ b/drivers/gpu/drm/qxl/qxl_drv.h
@@ -400,8 +400,6 @@ void qxl_crtc_set_from_monitors_config(struct qxl_device *qdev);
 void qxl_alloc_client_monitors_config(struct qxl_device *qdev, unsigned count);
 
 /* qxl_gem.c */
-int qxl_gem_init(struct qxl_device *qdev);
-void qxl_gem_fini(struct qxl_device *qdev);
 int qxl_gem_object_create(struct qxl_device *qdev, int size,
 			  int alignment, int initial_domain,
 			  bool discardable, bool kernel,
diff --git a/drivers/gpu/drm/qxl/qxl_gem.c b/drivers/gpu/drm/qxl/qxl_gem.c
index b96f0c9..fd6ef25 100644
--- a/drivers/gpu/drm/qxl/qxl_gem.c
+++ b/drivers/gpu/drm/qxl/qxl_gem.c
@@ -104,14 +104,3 @@ void qxl_gem_object_close(struct drm_gem_object *obj,
 			  struct drm_file *file_priv)
 {
 }
-
-int qxl_gem_init(struct qxl_device *qdev)
-{
-	INIT_LIST_HEAD(&qdev->gem.objects);
-	return 0;
-}
-
-void qxl_gem_fini(struct qxl_device *qdev)
-{
-	qxl_bo_force_delete(qdev);
-}
-- 
1.7.10.4

