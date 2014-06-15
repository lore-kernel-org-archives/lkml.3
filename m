Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173AbaFOALO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 20:11:14 -0400
Received: from mx02.posteo.de ([89.146.194.165]:58798 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750888AbaFOALN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 20:11:13 -0400
From: Martin Kepplinger <martink@posteo.de>
To: airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] ttm: use NULL instead of 0 for ttm_bo_reserve()'s pointer arg.
Date: Sun, 15 Jun 2014 02:10:39 +0200
Message-Id: <1402791039-16062-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a sparse warning: ttm_bo_reserve()'s last argument is a
pointer to a struct, so use NULL as nullpointer.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
this applies to next-20140613. Please ignore if annoyingly irrelevant.

 drivers/gpu/drm/ttm/ttm_bo.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 4ab9f71..cd0e15e 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -412,7 +412,7 @@ static void ttm_bo_cleanup_refs_or_queue(struct ttm_buffer_object *bo)
 	int ret;
 
 	spin_lock(&glob->lru_lock);
-	ret = __ttm_bo_reserve(bo, false, true, false, 0);
+	ret = __ttm_bo_reserve(bo, false, true, false, NULL);
 
 	spin_lock(&bdev->fence_lock);
 	(void) ttm_bo_wait(bo, false, false, true);
@@ -514,7 +514,7 @@ static int ttm_bo_cleanup_refs_and_unlock(struct ttm_buffer_object *bo,
 			return ret;
 
 		spin_lock(&glob->lru_lock);
-		ret = __ttm_bo_reserve(bo, false, true, false, 0);
+		ret = __ttm_bo_reserve(bo, false, true, false, NULL);
 
 		/*
 		 * We raced, and lost, someone else holds the reservation now,
@@ -577,11 +577,11 @@ static int ttm_bo_delayed_delete(struct ttm_bo_device *bdev, bool remove_all)
 			kref_get(&nentry->list_kref);
 		}
 
-		ret = __ttm_bo_reserve(entry, false, true, false, 0);
+		ret = __ttm_bo_reserve(entry, false, true, false, NULL);
 		if (remove_all && ret) {
 			spin_unlock(&glob->lru_lock);
 			ret = __ttm_bo_reserve(entry, false, false,
-					       false, 0);
+					       false, NULL);
 			spin_lock(&glob->lru_lock);
 		}
 
@@ -726,7 +726,7 @@ static int ttm_mem_evict_first(struct ttm_bo_device *bdev,
 
 	spin_lock(&glob->lru_lock);
 	list_for_each_entry(bo, &man->lru, lru) {
-		ret = __ttm_bo_reserve(bo, false, true, false, 0);
+		ret = __ttm_bo_reserve(bo, false, true, false, NULL);
 		if (!ret)
 			break;
 	}
@@ -1595,7 +1595,7 @@ int ttm_bo_synccpu_write_grab(struct ttm_buffer_object *bo, bool no_wait)
 	 * Using ttm_bo_reserve makes sure the lru lists are updated.
 	 */
 
-	ret = ttm_bo_reserve(bo, true, no_wait, false, 0);
+	ret = ttm_bo_reserve(bo, true, no_wait, false, NULL);
 	if (unlikely(ret != 0))
 		return ret;
 	spin_lock(&bdev->fence_lock);
@@ -1630,7 +1630,7 @@ static int ttm_bo_swapout(struct ttm_mem_shrink *shrink)
 
 	spin_lock(&glob->lru_lock);
 	list_for_each_entry(bo, &glob->swap_lru, swap) {
-		ret = __ttm_bo_reserve(bo, false, true, false, 0);
+		ret = __ttm_bo_reserve(bo, false, true, false, NULL);
 		if (!ret)
 			break;
 	}
-- 
1.7.10.4

