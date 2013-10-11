Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab3JKICm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:02:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615Ab3JKIBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:01:35 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: Gerd Hoffmann <kraxel@redhat.com>, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 4/6] drm/qxl: add some surface memory logging
Date: Fri, 11 Oct 2013 10:01:11 +0200
Message-Id: <1381478473-18159-5-git-send-email-kraxel@redhat.com>
In-Reply-To: <1381478473-18159-1-git-send-email-kraxel@redhat.com>
References: <1381478473-18159-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/qxl/qxl_kms.c | 10 +++++++---
 drivers/gpu/drm/qxl/qxl_ttm.c |  2 ++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_kms.c b/drivers/gpu/drm/qxl/qxl_kms.c
index e0ddd5b..e5ca498 100644
--- a/drivers/gpu/drm/qxl/qxl_kms.c
+++ b/drivers/gpu/drm/qxl/qxl_kms.c
@@ -248,9 +248,13 @@ int qxl_device_init(struct qxl_device *qdev,
 	qdev->surfaces_mem_slot = setup_slot(qdev, 1,
 		(unsigned long)qdev->surfaceram_base,
 		(unsigned long)qdev->surfaceram_base + qdev->surfaceram_size);
-	DRM_INFO("main mem slot %d [%lx,%x)\n",
-		qdev->main_mem_slot,
-		(unsigned long)qdev->vram_base, qdev->rom->ram_header_offset);
+	DRM_INFO("main mem slot %d [%lx,%x]\n",
+		 qdev->main_mem_slot,
+		 (unsigned long)qdev->vram_base, qdev->rom->ram_header_offset);
+	DRM_INFO("surface mem slot %d [%lx,%lx]\n",
+		 qdev->surfaces_mem_slot,
+		 (unsigned long)qdev->surfaceram_base,
+		 (unsigned long)qdev->surfaceram_size);
 
 
 	qdev->gc_queue = create_singlethread_workqueue("qxl_gc");
diff --git a/drivers/gpu/drm/qxl/qxl_ttm.c b/drivers/gpu/drm/qxl/qxl_ttm.c
index 037786d..c7e7e65 100644
--- a/drivers/gpu/drm/qxl/qxl_ttm.c
+++ b/drivers/gpu/drm/qxl/qxl_ttm.c
@@ -516,6 +516,8 @@ int qxl_ttm_init(struct qxl_device *qdev)
 		 (unsigned)qdev->vram_size / (1024 * 1024));
 	DRM_INFO("qxl: %luM of IO pages memory ready (VRAM domain)\n",
 		 ((unsigned)num_io_pages * PAGE_SIZE) / (1024 * 1024));
+	DRM_INFO("qxl: %uM of Surface memory size\n",
+		 (unsigned)qdev->surfaceram_size / (1024 * 1024));
 	if (unlikely(qdev->mman.bdev.dev_mapping == NULL))
 		qdev->mman.bdev.dev_mapping = qdev->ddev->dev_mapping;
 	r = qxl_ttm_debugfs_init(qdev);
-- 
1.8.3.1

