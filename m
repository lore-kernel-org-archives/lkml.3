Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbaAFQu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:50:29 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64348 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717AbaAFQu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:50:27 -0500
Date: Mon, 6 Jan 2014 22:20:21 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Jakob Bornecrantz <jakob@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 84/85] drivers: gpu: Mark functions as static in
 vmwgfx_buffer.c
Message-ID: <4802e571f4c4d3f3b82b3ba7ec40b690ee62ea23.1389018325.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static because they are not used outside the file
drm/vmwgfx/vmwgfx_buffer.c.

This eliminates the following warnings in drm/vmwgfx/vmwgfx_buffer.c:
drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c:520:16: warning: no previous prototype for ‘vmw_ttm_tt_create’ [-Wmissing-prototypes]
drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c:549:5: warning: no previous prototype for ‘vmw_invalidate_caches’ [-Wmissing-prototypes]
drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c:554:5: warning: no previous prototype for ‘vmw_init_mem_type’ [-Wmissing-prototypes]
drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c:592:6: warning: no previous prototype for ‘vmw_evict_flags’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c b/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
index 0489c61..2d61a2d 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
@@ -517,7 +517,7 @@ static struct ttm_backend_func vmw_ttm_func = {
 	.destroy = vmw_ttm_destroy,
 };
 
-struct ttm_tt *vmw_ttm_tt_create(struct ttm_bo_device *bdev,
+static struct ttm_tt *vmw_ttm_tt_create(struct ttm_bo_device *bdev,
 				 unsigned long size, uint32_t page_flags,
 				 struct page *dummy_read_page)
 {
@@ -546,12 +546,12 @@ out_no_init:
 	return NULL;
 }
 
-int vmw_invalidate_caches(struct ttm_bo_device *bdev, uint32_t flags)
+static int vmw_invalidate_caches(struct ttm_bo_device *bdev, uint32_t flags)
 {
 	return 0;
 }
 
-int vmw_init_mem_type(struct ttm_bo_device *bdev, uint32_t type,
+static int vmw_init_mem_type(struct ttm_bo_device *bdev, uint32_t type,
 		      struct ttm_mem_type_manager *man)
 {
 	switch (type) {
@@ -589,7 +589,7 @@ int vmw_init_mem_type(struct ttm_bo_device *bdev, uint32_t type,
 	return 0;
 }
 
-void vmw_evict_flags(struct ttm_buffer_object *bo,
+static void vmw_evict_flags(struct ttm_buffer_object *bo,
 		     struct ttm_placement *placement)
 {
 	*placement = vmw_sys_placement;
-- 
1.7.9.5

