Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab3EGNYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:24:32 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:59842 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab3EGNYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:24:31 -0400
MIME-Version: 1.0
Date: Tue, 7 May 2013 21:24:30 +0800
Message-ID: <CAPgLHd8Xu8+d7fxtnC0sdQnTDtrZo8jhB8JJ4b2Lp4SYqcjG4A@mail.gmail.com>
Subject: [PATCH] drm/exynos: fix error return code in exynos_drm_ipp_set_property()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: inki.dae@samsung.com, jy0922.shim@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, airlied@linux.ie
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.
ipp_create_cmd_work() return ERR_PTR() on error and never return
NULL, so use IS_ERR() instead of IS_ERR_OR_NULL().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 29d2ad3..b0d6431 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -521,20 +521,23 @@ int exynos_drm_ipp_set_property(struct drm_device *drm_dev, void *data,
 	c_node->state = IPP_STATE_IDLE;
 
 	c_node->start_work = ipp_create_cmd_work();
-	if (IS_ERR_OR_NULL(c_node->start_work)) {
+	if (IS_ERR(c_node->start_work)) {
 		DRM_ERROR("failed to create start work.\n");
+		ret = PTR_ERR(c_node->start_work);
 		goto err_clear;
 	}
 
 	c_node->stop_work = ipp_create_cmd_work();
-	if (IS_ERR_OR_NULL(c_node->stop_work)) {
+	if (IS_ERR(c_node->stop_work)) {
 		DRM_ERROR("failed to create stop work.\n");
+		ret = PTR_ERR(c_node->stop_work);
 		goto err_free_start;
 	}
 
 	c_node->event_work = ipp_create_event_work();
-	if (IS_ERR_OR_NULL(c_node->event_work)) {
+	if (IS_ERR(c_node->event_work)) {
 		DRM_ERROR("failed to create event work.\n");
+		ret = PTR_ERR(c_node->event_work);
 		goto err_free_stop;
 	}
 

