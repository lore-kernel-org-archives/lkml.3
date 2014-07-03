Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935AbaGCNNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:13:47 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32934 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbaGCNK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:10:56 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-62-53b5565e5abf
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
Subject: [PATCH 02/12] drm/exynos/ipp: remove unused field from
 exynos_drm_ipp_private
Date: Thu, 03 Jul 2014 15:10:27 +0200
Message-id: <1404393037-17299-3-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
References: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xK7pxYVuDDRavYbG4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4MqYdmweS8Fn7oqHd6waGNdydTFyckgImEi0N8xgh7DFJC7cW8/W
	xcjFISSwlFGiZeo/Zginj0ni98nTrCBVbAKaEn8332QDsUUElCVW7WtnByliFvjIJHFl6Rtm
	kISwQITEuaXfGEFsFgFViW8XNoHZvALOEs23uhgh1slJnDw2GWwop4CLxKGZS8HiQkA1a5fM
	ZZvAyLuAkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkhYfdnBuPiY1SFGAQ5GJR7exhUb
	goVYE8uKK3MPMUpwMCuJ8FYEbw0W4k1JrKxKLcqPLyrNSS0+xMjEwSnVwLh88dpnEcVGay7r
	szDO5ZhoE6F+Zf09iwCG5HPyR67urNWqrdk7u+4m92HNLdclhC6//7Z1xQL2ix5Hp1VX+XxY
	EORtcTBUh9V2e+0J/oXPwr3s9GrKd//p+7VzP3fj72+fFPRYX3WktryXP2Ee0NPvOKV1zcEP
	WSZVuxens6xevWFHTF9AuY4SS3FGoqEWc1FxIgCjJ1UtCQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch removes unused event_list field from struct exynos_drm_ipp_private.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_drv.h | 1 -
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.h b/drivers/gpu/drm/exynos/exynos_drm_drv.h
index 06cde45..651f37a 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.h
@@ -238,7 +238,6 @@ struct exynos_drm_g2d_private {
 
 struct exynos_drm_ipp_private {
 	struct device	*dev;
-	struct list_head	event_list;
 };
 
 struct drm_exynos_file_private {
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index f3f114c..5fb89c02 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -534,7 +534,6 @@ int exynos_drm_ipp_set_property(struct drm_device *drm_dev, void *data,
 		INIT_LIST_HEAD(&c_node->mem_list[i]);
 
 	INIT_LIST_HEAD(&c_node->event_list);
-	list_splice_init(&priv->event_list, &c_node->event_list);
 	mutex_lock(&ippdrv->cmd_lock);
 	list_add_tail(&c_node->list, &ippdrv->cmd_list);
 	mutex_unlock(&ippdrv->cmd_lock);
@@ -1784,7 +1783,6 @@ static int ipp_subdrv_open(struct drm_device *drm_dev, struct device *dev,
 	priv->dev = dev;
 	file_priv->ipp_priv = priv;
 
-	INIT_LIST_HEAD(&priv->event_list);
 
 	DRM_DEBUG_KMS("done priv[0x%x]\n", (int)priv);
 
-- 
1.9.1

