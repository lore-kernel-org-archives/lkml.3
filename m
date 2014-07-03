Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbaGCNLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:11:02 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32942 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbaGCNK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:10:58 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-51-53b5565f32fc
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
Subject: [PATCH 03/12] drm/exynos/ipp: remove struct exynos_drm_ipp_private
Date: Thu, 03 Jul 2014 15:10:28 +0200
Message-id: <1404393037-17299-4-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
References: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xK7rxYVuDDVYv1rW4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4MqYfb+FpWCOfsXeU/OYGxgvqHcxcnJICJhIfOm6yARhi0lcuLee
	rYuRi0NIYCmjxKTrZ1kgnD4miftfz4BVsQloSvzdfJMNxBYRUJZYta+dHaSIWeAjk8SVpW+Y
	QRLCAt4Sr56fYQexWQRUJW6eXA5m8wo4S/S+nsMMsU5O4uSxyawgNqeAi8ShmUsZQWwhoJq1
	S+ayTWDkXcDIsIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJLC+7mBceszqEKMAB6MSD+8L
	/U3BQqyJZcWVuYcYJTiYlUR4K4K3BgvxpiRWVqUW5ccXleakFh9iZOLglGpgdHNnDtkXeGBG
	cMq7uYtmXT5+12mliPT/DYkL4uXSym+sFPH56b3cKLpVvue2ytHQQCdzJZbj6ptWss7py1y6
	Yie7Yv1dHdXtLxabqe28L/bhRd8+3i+cvCyHfzNZLj4Z8eRlQPnlZ4Wy23baBp6KT398VWtr
	3ZbMA2suv5a8e9zX4uI/lk92lkosxRmJhlrMRcWJADf4RvsKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct exynos_drm_ipp_private contains only one pointer so all occurrences
of the struct can be replaced by the pointer itself.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_drv.h |  6 +-----
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 30 +++++++++---------------------
 drivers/gpu/drm/exynos/exynos_drm_ipp.h |  4 ++--
 3 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.h b/drivers/gpu/drm/exynos/exynos_drm_drv.h
index 651f37a..5f027f2 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.h
@@ -236,13 +236,9 @@ struct exynos_drm_g2d_private {
 	struct list_head	userptr_list;
 };
 
-struct exynos_drm_ipp_private {
-	struct device	*dev;
-};
-
 struct drm_exynos_file_private {
 	struct exynos_drm_g2d_private	*g2d_priv;
-	struct exynos_drm_ipp_private	*ipp_priv;
+	struct device			*ipp_dev;
 	struct file			*anon_filp;
 };
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 5fb89c02..34d185c 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -308,8 +308,7 @@ int exynos_drm_ipp_get_property(struct drm_device *drm_dev, void *data,
 		struct drm_file *file)
 {
 	struct drm_exynos_file_private *file_priv = file->driver_priv;
-	struct exynos_drm_ipp_private *priv = file_priv->ipp_priv;
-	struct device *dev = priv->dev;
+	struct device *dev = file_priv->ipp_dev;
 	struct ipp_context *ctx = get_ipp_context(dev);
 	struct drm_exynos_ipp_prop_list *prop_list = data;
 	struct exynos_drm_ippdrv *ippdrv;
@@ -441,8 +440,7 @@ int exynos_drm_ipp_set_property(struct drm_device *drm_dev, void *data,
 		struct drm_file *file)
 {
 	struct drm_exynos_file_private *file_priv = file->driver_priv;
-	struct exynos_drm_ipp_private *priv = file_priv->ipp_priv;
-	struct device *dev = priv->dev;
+	struct device *dev = file_priv->ipp_dev;
 	struct ipp_context *ctx = get_ipp_context(dev);
 	struct drm_exynos_ipp_property *property = data;
 	struct exynos_drm_ippdrv *ippdrv;
@@ -501,7 +499,7 @@ int exynos_drm_ipp_set_property(struct drm_device *drm_dev, void *data,
 		property->prop_id, property->cmd, (int)ippdrv);
 
 	/* stored property information and ippdrv in private data */
-	c_node->priv = priv;
+	c_node->dev = dev;
 	c_node->property = *property;
 	c_node->state = IPP_STATE_IDLE;
 
@@ -929,8 +927,7 @@ int exynos_drm_ipp_queue_buf(struct drm_device *drm_dev, void *data,
 		struct drm_file *file)
 {
 	struct drm_exynos_file_private *file_priv = file->driver_priv;
-	struct exynos_drm_ipp_private *priv = file_priv->ipp_priv;
-	struct device *dev = priv->dev;
+	struct device *dev = file_priv->ipp_dev;
 	struct ipp_context *ctx = get_ipp_context(dev);
 	struct drm_exynos_ipp_queue_buf *qbuf = data;
 	struct drm_exynos_ipp_cmd_node *c_node;
@@ -1061,9 +1058,8 @@ int exynos_drm_ipp_cmd_ctrl(struct drm_device *drm_dev, void *data,
 		struct drm_file *file)
 {
 	struct drm_exynos_file_private *file_priv = file->driver_priv;
-	struct exynos_drm_ipp_private *priv = file_priv->ipp_priv;
 	struct exynos_drm_ippdrv *ippdrv = NULL;
-	struct device *dev = priv->dev;
+	struct device *dev = file_priv->ipp_dev;
 	struct ipp_context *ctx = get_ipp_context(dev);
 	struct drm_exynos_ipp_cmd_ctrl *cmd_ctrl = data;
 	struct drm_exynos_ipp_cmd_work *cmd_work;
@@ -1775,16 +1771,10 @@ static int ipp_subdrv_open(struct drm_device *drm_dev, struct device *dev,
 		struct drm_file *file)
 {
 	struct drm_exynos_file_private *file_priv = file->driver_priv;
-	struct exynos_drm_ipp_private *priv;
-
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-	priv->dev = dev;
-	file_priv->ipp_priv = priv;
 
+	file_priv->ipp_dev = dev;
 
-	DRM_DEBUG_KMS("done priv[0x%x]\n", (int)priv);
+	DRM_DEBUG_KMS("done priv[0x%x]\n", (int)dev);
 
 	return 0;
 }
@@ -1793,13 +1783,12 @@ static void ipp_subdrv_close(struct drm_device *drm_dev, struct device *dev,
 		struct drm_file *file)
 {
 	struct drm_exynos_file_private *file_priv = file->driver_priv;
-	struct exynos_drm_ipp_private *priv = file_priv->ipp_priv;
 	struct exynos_drm_ippdrv *ippdrv = NULL;
 	struct ipp_context *ctx = get_ipp_context(dev);
 	struct drm_exynos_ipp_cmd_node *c_node, *tc_node;
 	int count = 0;
 
-	DRM_DEBUG_KMS("for priv[0x%x]\n", (int)priv);
+	DRM_DEBUG_KMS("for priv[0x%x]\n", (int)file_priv->ipp_dev);
 
 	list_for_each_entry(ippdrv, &exynos_drm_ippdrv_list, drv_list) {
 		mutex_lock(&ippdrv->cmd_lock);
@@ -1808,7 +1797,7 @@ static void ipp_subdrv_close(struct drm_device *drm_dev, struct device *dev,
 			DRM_DEBUG_KMS("count[%d]ippdrv[0x%x]\n",
 				count++, (int)ippdrv);
 
-			if (c_node->priv == priv) {
+			if (c_node->dev == file_priv->ipp_dev) {
 				/*
 				 * userland goto unnormal state. process killed.
 				 * and close the file.
@@ -1830,7 +1819,6 @@ static void ipp_subdrv_close(struct drm_device *drm_dev, struct device *dev,
 		mutex_unlock(&ippdrv->cmd_lock);
 	}
 
-	kfree(priv);
 	return;
 }
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.h b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
index 7aaeaae..6f48d62 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
@@ -48,7 +48,7 @@ struct drm_exynos_ipp_cmd_work {
 /*
  * A structure of command node.
  *
- * @priv: IPP private information.
+ * @dev: IPP device.
  * @list: list head to command queue information.
  * @event_list: list head of event.
  * @mem_list: list head to source,destination memory queue information.
@@ -64,7 +64,7 @@ struct drm_exynos_ipp_cmd_work {
  * @state: state of command node.
  */
 struct drm_exynos_ipp_cmd_node {
-	struct exynos_drm_ipp_private *priv;
+	struct device		*dev;
 	struct list_head	list;
 	struct list_head	event_list;
 	struct list_head	mem_list[EXYNOS_DRM_OPS_MAX];
-- 
1.9.1

