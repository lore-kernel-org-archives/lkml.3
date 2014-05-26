Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaEZISc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:18:32 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29466 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaEZIS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:18:29 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-05-5382f8c6576b
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: YoungJun Cho <yj44.cho@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/9] drm/exynos: ipp: remove usless list_empty() functions
Date: Mon, 26 May 2014 10:17:15 +0200
Message-id: <1401092243-25568-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
References: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xa7rHfjQFGxzaK25x5et7NotJ9yew
	WLy4d5HF4mzTG3aLy7vmsFnMOL+PyWLtkbvsFjMmv2Sz2LtzMqMDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJVxYu8mtoJZ6hXNjedYGxinKXQxcnJICJhIdMy9wQhhi0lcuLee
	rYuRi0NIYCmjRPv1NcwQTh+TRFdzGwtIFZuApsTfzTfZQGwRAWWJvxNXMYIUMQt8ZJJo+f6B
	HSQhLOAl8e/8N7AGFgFViXcffzCB2LwCzhLtpx6xQKyTkzh5bDIriM0p4CLx+uNKoBoOoG3O
	Er+/809g5F3AyLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIySsvuxgXHzM6hCjAAejEg/v
	iaCmYCHWxLLiytxDjBIczEoivM0fgEK8KYmVValF+fFFpTmpxYcYmTg4pRoYa/5OVTaxzlqc
	q7z3y6zZMc8abka/7jO7IPBC/O2LB48fiRocvWXFw65/4ePW81xKWpGiph2lHH2JPWacr3lq
	Txi/WzznAHO2u2rZjLNp8+a2xTvq6rxxfs8lNpH7aEfwkT9/Ajv/iRz1ZXQX2NJX5W3zJcgj
	5O5tw5//5+SHyoo0yDycuTRfiaU4I9FQi7moOBEAqt/ppwkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: YoungJun Cho <yj44.cho@samsung.com>

list_for_each_entry() handles empty lists, so there is no
need to check whether the list is empty first.

Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
Acked-by: Seong-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Tested-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 61 +++++----------------------------
 1 file changed, 9 insertions(+), 52 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index bf71d97..c8cfa24 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -276,11 +276,6 @@ static struct exynos_drm_ippdrv *ipp_find_drv_by_handle(u32 prop_id)
 
 	DRM_DEBUG_KMS("prop_id[%d]\n", prop_id);
 
-	if (list_empty(&exynos_drm_ippdrv_list)) {
-		DRM_DEBUG_KMS("ippdrv_list is empty.\n");
-		return ERR_PTR(-ENODEV);
-	}
-
 	/*
 	 * This case is search ipp driver by prop_id handle.
 	 * sometimes, ipp subsystem find driver by prop_id.
@@ -289,11 +284,9 @@ static struct exynos_drm_ippdrv *ipp_find_drv_by_handle(u32 prop_id)
 	list_for_each_entry(ippdrv, &exynos_drm_ippdrv_list, drv_list) {
 		DRM_DEBUG_KMS("count[%d]ippdrv[0x%x]\n", count++, (int)ippdrv);
 
-		if (!list_empty(&ippdrv->cmd_list)) {
-			list_for_each_entry(c_node, &ippdrv->cmd_list, list)
-				if (c_node->property.prop_id == prop_id)
-					return ippdrv;
-		}
+		list_for_each_entry(c_node, &ippdrv->cmd_list, list)
+			if (c_node->property.prop_id == prop_id)
+				return ippdrv;
 	}
 
 	return ERR_PTR(-ENODEV);
@@ -573,11 +566,6 @@ static int ipp_check_mem_list(struct drm_exynos_ipp_cmd_node *c_node)
 		/* source/destination memory list */
 		head = &c_node->mem_list[i];
 
-		if (list_empty(head)) {
-			DRM_DEBUG_KMS("%s memory empty.\n", i ? "dst" : "src");
-			continue;
-		}
-
 		/* find memory node entry */
 		list_for_each_entry(m_node, head, list) {
 			DRM_DEBUG_KMS("%s,count[%d]m_node[0x%x]\n",
@@ -816,11 +804,6 @@ static void ipp_put_event(struct drm_exynos_ipp_cmd_node *c_node,
 	struct drm_exynos_ipp_send_event *e, *te;
 	int count = 0;
 
-	if (list_empty(&c_node->event_list)) {
-		DRM_DEBUG_KMS("event_list is empty.\n");
-		return;
-	}
-
 	list_for_each_entry_safe(e, te, &c_node->event_list, base.link) {
 		DRM_DEBUG_KMS("count[%d]e[0x%x]\n", count++, (int)e);
 
@@ -918,14 +901,12 @@ static void ipp_clean_queue_buf(struct drm_device *drm_dev,
 {
 	struct drm_exynos_ipp_mem_node *m_node, *tm_node;
 
-	if (!list_empty(&c_node->mem_list[qbuf->ops_id])) {
-		/* delete list */
-		list_for_each_entry_safe(m_node, tm_node,
-			&c_node->mem_list[qbuf->ops_id], list) {
-			if (m_node->buf_id == qbuf->buf_id &&
-			    m_node->ops_id == qbuf->ops_id)
-				ipp_put_mem_node(drm_dev, c_node, m_node);
-		}
+	/* delete list */
+	list_for_each_entry_safe(m_node, tm_node,
+		&c_node->mem_list[qbuf->ops_id], list) {
+		if (m_node->buf_id == qbuf->buf_id &&
+		    m_node->ops_id == qbuf->ops_id)
+			ipp_put_mem_node(drm_dev, c_node, m_node);
 	}
 }
 
@@ -1361,11 +1342,6 @@ static int ipp_stop_property(struct drm_device *drm_dev,
 			/* source/destination memory list */
 			head = &c_node->mem_list[i];
 
-			if (list_empty(head)) {
-				DRM_DEBUG_KMS("mem_list is empty.\n");
-				break;
-			}
-
 			list_for_each_entry_safe(m_node, tm_node,
 				head, list) {
 				ret = ipp_put_mem_node(drm_dev, c_node,
@@ -1381,11 +1357,6 @@ static int ipp_stop_property(struct drm_device *drm_dev,
 		/* destination memory list */
 		head = &c_node->mem_list[EXYNOS_DRM_OPS_DST];
 
-		if (list_empty(head)) {
-			DRM_DEBUG_KMS("mem_list is empty.\n");
-			break;
-		}
-
 		list_for_each_entry_safe(m_node, tm_node, head, list) {
 			ret = ipp_put_mem_node(drm_dev, c_node, m_node);
 			if (ret) {
@@ -1398,11 +1369,6 @@ static int ipp_stop_property(struct drm_device *drm_dev,
 		/* source memory list */
 		head = &c_node->mem_list[EXYNOS_DRM_OPS_SRC];
 
-		if (list_empty(head)) {
-			DRM_DEBUG_KMS("mem_list is empty.\n");
-			break;
-		}
-
 		list_for_each_entry_safe(m_node, tm_node, head, list) {
 			ret = ipp_put_mem_node(drm_dev, c_node, m_node);
 			if (ret) {
@@ -1790,15 +1756,7 @@ static void ipp_subdrv_close(struct drm_device *drm_dev, struct device *dev,
 
 	DRM_DEBUG_KMS("for priv[0x%x]\n", (int)priv);
 
-	if (list_empty(&exynos_drm_ippdrv_list)) {
-		DRM_DEBUG_KMS("ippdrv_list is empty.\n");
-		goto err_clear;
-	}
-
 	list_for_each_entry(ippdrv, &exynos_drm_ippdrv_list, drv_list) {
-		if (list_empty(&ippdrv->cmd_list))
-			continue;
-
 		list_for_each_entry_safe(c_node, tc_node,
 			&ippdrv->cmd_list, list) {
 			DRM_DEBUG_KMS("count[%d]ippdrv[0x%x]\n",
@@ -1825,7 +1783,6 @@ static void ipp_subdrv_close(struct drm_device *drm_dev, struct device *dev,
 		}
 	}
 
-err_clear:
 	kfree(priv);
 	return;
 }
-- 
1.9.1

