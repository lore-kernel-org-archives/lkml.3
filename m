Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbbAARGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:06:30 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:42116 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbbAARG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:06:29 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: qxl: qxl_cmd.c:  Remove some unused functions
Date: Thu,  1 Jan 2015 18:09:29 +0100
Message-Id: <1420132169-31802-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
qxl_io_flush_surfaces() qxl_io_flush_release()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/qxl/qxl_cmd.c |   10 ----------
 drivers/gpu/drm/qxl/qxl_drv.h |    2 --
 2 files changed, 12 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_cmd.c b/drivers/gpu/drm/qxl/qxl_cmd.c
index 9782364..f62d857 100644
--- a/drivers/gpu/drm/qxl/qxl_cmd.c
+++ b/drivers/gpu/drm/qxl/qxl_cmd.c
@@ -360,16 +360,6 @@ void qxl_io_notify_oom(struct qxl_device *qdev)
 	outb(0, qdev->io_base + QXL_IO_NOTIFY_OOM);
 }
 
-void qxl_io_flush_release(struct qxl_device *qdev)
-{
-	outb(0, qdev->io_base + QXL_IO_FLUSH_RELEASE);
-}
-
-void qxl_io_flush_surfaces(struct qxl_device *qdev)
-{
-	wait_for_io_cmd(qdev, 0, QXL_IO_FLUSH_SURFACES_ASYNC);
-}
-
 
 void qxl_io_destroy_primary(struct qxl_device *qdev)
 {
diff --git a/drivers/gpu/drm/qxl/qxl_drv.h b/drivers/gpu/drm/qxl/qxl_drv.h
index 7c6cafe..c84cd95 100644
--- a/drivers/gpu/drm/qxl/qxl_drv.h
+++ b/drivers/gpu/drm/qxl/qxl_drv.h
@@ -467,8 +467,6 @@ int qxl_io_update_area(struct qxl_device *qdev, struct qxl_bo *surf,
 void qxl_io_reset(struct qxl_device *qdev);
 void qxl_io_monitors_config(struct qxl_device *qdev);
 int qxl_ring_push(struct qxl_ring *ring, const void *new_elt, bool interruptible);
-void qxl_io_flush_release(struct qxl_device *qdev);
-void qxl_io_flush_surfaces(struct qxl_device *qdev);
 
 union qxl_release_info *qxl_release_map(struct qxl_device *qdev,
 					struct qxl_release *release);
-- 
1.7.10.4

