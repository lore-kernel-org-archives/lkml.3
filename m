Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbaHVHxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:53:41 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34658 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbaHVHxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:34 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-2e-53f6f6fdb7fe
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
Subject: [PATCH 05/15] drm/exynos/ipp: remove unused field in command node
Date: Fri, 22 Aug 2014 09:52:16 +0200
Message-id: <1408693946-15456-6-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xq7p/v30LNnjUJWtxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXRs/sCW8F6noqWVdNZGxh3cnUxcnJICJhIbJ/VxwZhi0lcuLce
	yObiEBJYyijxff1rVginj0liwZM5YFVsApoSfzffBLNFBJQlVu1rZwcpYhb4yCRxZekbZpCE
	sICXRMf3i2A2i4CqxNd1qxlBbF4BZ4k9LydDrZOTOHlsMiuIzSngInHh4DSweiGgmq7b05gm
	MPIuYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESWF92MC4+ZnWIUYCDUYmHN/H312Ah
	1sSy4srcQ4wSHMxKIryb5n0LFuJNSaysSi3Kjy8qzUktPsTIxMEp1cDo/PIuU+tuMZUVZox2
	i+7sjFM+/zBSrfdhzNmQef+NSzRnOUQySHorN1rfO2MkUJy3Y5arXJJTuszhf78b+Hc3C5cf
	nKG14fmrc/vnPpk4o/Vp5ZeKVb9OLnwYrPVeIHm3r3N6X3Kx+XbO4h1tywzvXuzYvMTpbeuu
	99/OJE27NvfUlCU/LZ1jlViKMxINtZiLihMBWfvqggoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since command node have file pointer dev field became useless.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 1 -
 drivers/gpu/drm/exynos/exynos_drm_ipp.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 81f780e..060a198 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -444,7 +444,6 @@ int exynos_drm_ipp_set_property(struct drm_device *drm_dev, void *data,
 		property->prop_id, property->cmd, (int)ippdrv);
 
 	/* stored property information and ippdrv in private data */
-	c_node->dev = dev;
 	c_node->property = *property;
 	c_node->state = IPP_STATE_IDLE;
 	c_node->filp = file;
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.h b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
index 0311035..2a61547 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
@@ -48,7 +48,6 @@ struct drm_exynos_ipp_cmd_work {
 /*
  * A structure of command node.
  *
- * @dev: IPP device.
  * @list: list head to command queue information.
  * @event_list: list head of event.
  * @mem_list: list head to source,destination memory queue information.
@@ -65,7 +64,6 @@ struct drm_exynos_ipp_cmd_work {
  * @filp: associated file pointer.
  */
 struct drm_exynos_ipp_cmd_node {
-	struct device		*dev;
 	struct list_head	list;
 	struct list_head	event_list;
 	struct list_head	mem_list[EXYNOS_DRM_OPS_MAX];
-- 
1.9.1

