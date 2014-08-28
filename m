Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965747AbaH1JI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:08:56 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54144 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965709AbaH1JIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:38 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-fb-53fef191d218
From: Andrzej Hajda <a.hajda@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org (open list),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...)
Subject: [PATCH v2 16/17] drm/exynos/ipp: remove file argument from node
 related functions
Date: Thu, 28 Aug 2014 11:07:40 +0200
Message-id: <1409216861-12452-17-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t/xy7oTP/4LNjh1x9Li1rpzrBZXvr5n
	s5h0fwKLxYt7F1kszja9Ybe4vGsOm8WM8/uYLNYeuctuMWPySzYHTo/73ceZPPq2rGL0+LxJ
	LoA5issmJTUnsyy1SN8ugStj56zIgl7JipcdC5gbGB+IdDFycEgImEjsOOjdxcgJZIpJXLi3
	nq2LkYtDSGApo8T1r6+YIJw+Jomza26zglSxCWhK/N18kw3EFhFQlli1r50dpIhZ4COTxJWl
	b5hBEsICMRIvNs5kBNnAIqAqcWdPBkiYV8BFovf1HHaIbXISJ49NBpvJCRTfePwNWFxIwFli
	9/nPTBMYeRcwMqxiFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECAmprzsYlx6zOsQowMGoxMOr
	cPpPsBBrYllxZe4hRgkOZiUR3qPH/wUL8aYkVlalFuXHF5XmpBYfYmTi4JRqYPRzcPXnq+1i
	VXx6fC+znHPTws16ZmFFf09LyfHc4GasylpT3CwuLrpC9lXX2jy5iukvl05gKvjsMm8vN9OZ
	Be3MMa8PCridTv6avvhSUdn6HOmHwrMusWh2aeR62TyfrtndElvUMP3TlCvXA1gV9uWlzHLZ
	Yaa+WEQ+/qeB4qz0ux+WNyaaK7EUZyQaajEXFScCAG4zpqcHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since file pointer is preserved in c_node passing it
as argument in node functions is redundant.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 05f0f4e..fc8bb67 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -529,7 +529,6 @@ static int ipp_put_mem_node(struct drm_device *drm_dev,
 
 static struct drm_exynos_ipp_mem_node
 		*ipp_get_mem_node(struct drm_device *drm_dev,
-		struct drm_file *file,
 		struct drm_exynos_ipp_cmd_node *c_node,
 		struct drm_exynos_ipp_queue_buf *qbuf)
 {
@@ -560,7 +559,7 @@ static struct drm_exynos_ipp_mem_node
 			dma_addr_t *addr;
 
 			addr = exynos_drm_gem_get_dma_addr(drm_dev,
-					qbuf->handle[i], file);
+					qbuf->handle[i], c_node->filp);
 			if (IS_ERR(addr)) {
 				DRM_ERROR("failed to get addr.\n");
 				ipp_put_mem_node(drm_dev, c_node, m_node);
@@ -606,7 +605,6 @@ static void ipp_free_event(struct drm_pending_event *event)
 }
 
 static int ipp_get_event(struct drm_device *drm_dev,
-		struct drm_file *file,
 		struct drm_exynos_ipp_cmd_node *c_node,
 		struct drm_exynos_ipp_queue_buf *qbuf)
 {
@@ -618,7 +616,7 @@ static int ipp_get_event(struct drm_device *drm_dev,
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
 	if (!e) {
 		spin_lock_irqsave(&drm_dev->event_lock, flags);
-		file->event_space += sizeof(e->event);
+		c_node->filp->event_space += sizeof(e->event);
 		spin_unlock_irqrestore(&drm_dev->event_lock, flags);
 		return -ENOMEM;
 	}
@@ -630,7 +628,7 @@ static int ipp_get_event(struct drm_device *drm_dev,
 	e->event.prop_id = qbuf->prop_id;
 	e->event.buf_id[EXYNOS_DRM_OPS_DST] = qbuf->buf_id;
 	e->base.event = &e->event.base;
-	e->base.file_priv = file;
+	e->base.file_priv = c_node->filp;
 	e->base.destroy = ipp_free_event;
 	mutex_lock(&c_node->event_lock);
 	list_add_tail(&e->base.link, &c_node->event_list);
@@ -899,7 +897,7 @@ int exynos_drm_ipp_queue_buf(struct drm_device *drm_dev, void *data,
 	/* find command node */
 	c_node = ipp_find_obj(&ctx->prop_idr, &ctx->prop_lock,
 		qbuf->prop_id);
-	if (!c_node) {
+	if (!c_node || c_node->filp != file) {
 		DRM_ERROR("failed to get command node.\n");
 		return -ENODEV;
 	}
@@ -908,7 +906,7 @@ int exynos_drm_ipp_queue_buf(struct drm_device *drm_dev, void *data,
 	switch (qbuf->buf_type) {
 	case IPP_BUF_ENQUEUE:
 		/* get memory node */
-		m_node = ipp_get_mem_node(drm_dev, file, c_node, qbuf);
+		m_node = ipp_get_mem_node(drm_dev, c_node, qbuf);
 		if (IS_ERR(m_node)) {
 			DRM_ERROR("failed to get m_node.\n");
 			return PTR_ERR(m_node);
@@ -921,7 +919,7 @@ int exynos_drm_ipp_queue_buf(struct drm_device *drm_dev, void *data,
 		 */
 		if (qbuf->ops_id == EXYNOS_DRM_OPS_DST) {
 			/* get event for destination buffer */
-			ret = ipp_get_event(drm_dev, file, c_node, qbuf);
+			ret = ipp_get_event(drm_dev, c_node, qbuf);
 			if (ret) {
 				DRM_ERROR("failed to get event.\n");
 				goto err_clean_node;
-- 
1.9.1

