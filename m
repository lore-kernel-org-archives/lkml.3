Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965860AbaH1JMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:12:03 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54124 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965648AbaH1JIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:21 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-c7-53fef182a65d
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
Subject: [PATCH v2 05/17] drm/exynos/ipp: remove unused field in command node
Date: Thu, 28 Aug 2014 11:07:29 +0200
Message-id: <1409216861-12452-6-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xy7pNH/8FG3ycJWxxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJWxonsZU8Eznoo1E5cyNjC+5upi5OSQEDCRmNTxlwXCFpO4cG89
	WxcjF4eQwFJGiXOzZ7JAOH1MEpP/z2cEqWIT0JT4u/kmG4gtIqAssWpfOztIEbPARyaJK0vf
	MIMkhAV8JXa2TmQCsVkEVCVerG8Hi/MKOEvMmbmAFWKdnMTJY5PBbE4BF4mNx9+wg9hCQDW7
	z39mmsDIu4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSGB92cG4+JjVIUYBDkYlHt4N
	pf+ChVgTy4orcw8xSnAwK4nwHj0OFOJNSaysSi3Kjy8qzUktPsTIxMEp1cBo0p316NOz5U9+
	p2RcjjXN3rUmJ+J9aXRMnt05ky8cKyPNi9YfW7J12239Vd9lnr783+OWZfVrh6BGfgnP5BBp
	/6svbsTXiH9//KJ1q/6GKXdVMxd2ydydeEzl5XTe1fcL2D2mnnqmvltpR0LsRz2rnSFzP3mx
	F/6sP2nmlCGmrKQZVFKleuGoEktxRqKhFnNRcSIAuEK5ygoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since command node have file pointer dev field became useless.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
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

