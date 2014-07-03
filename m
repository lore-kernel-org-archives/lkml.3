Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964871AbaGCNLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:11:16 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40901 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347AbaGCNLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:11:12 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-9d-53b5566e9c37
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
Subject: [PATCH 10/12] drm/exynos/ipp: remove redundant messages
Date: Thu, 03 Jul 2014 15:10:35 +0200
Message-id: <1404393037-17299-11-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
References: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xK7p5YVuDDc78M7S4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4MroXrCHteAFd8WC+1+ZGxh7ObsYOTkkBEwkPt9+zgZhi0lcuLce
	yObiEBJYyiixvbWXBcLpY5JoXnCYBaSKTUBT4u/mm2AdIgLKEqv2tbODFDELfGSSuLL0DTNI
	QljAQeLOi7eMIDaLgKrErB8drCA2r4CLxKxrL6DWyUmcPDYZLM4JFD80cylYvZCAs8TaJXPZ
	JjDyLmBkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kRElhfdjAuPmZ1iFGAg1GJh7dxxYZg
	IdbEsuLK3EOMEhzMSiK8FcFbg4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUwNvQGfNwQ2iJ0O9+w
	Jmi1q3lSi2VK6/OJpnahp+dzvmv05rzaJ6UXaKM7wWGzXQVvzs3EFRIHJfkmb9c/GJj47tyb
	2VVus2/lHPCf7ZX8XWjDkXQey/WvBf1ld+05/ES9XCHpxYSO/FDTd9vfmxtHHG+25XnGGOW0
	gV3lHtvJM1fXz9raVZKoxFKckWioxVxUnAgAHsRAJQoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of error callback prints already corresponding message.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index c7ea047..0552f62 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -1152,7 +1152,6 @@ static int ipp_set_property(struct exynos_drm_ippdrv *ippdrv,
 	/* reset h/w block */
 	if (ippdrv->reset &&
 	    ippdrv->reset(ippdrv->dev)) {
-		DRM_ERROR("failed to reset.\n");
 		return -EINVAL;
 	}
 
@@ -1170,30 +1169,24 @@ static int ipp_set_property(struct exynos_drm_ippdrv *ippdrv,
 		/* set format */
 		if (ops->set_fmt) {
 			ret = ops->set_fmt(ippdrv->dev, config->fmt);
-			if (ret) {
-				DRM_ERROR("not support format.\n");
+			if (ret)
 				return ret;
-			}
 		}
 
 		/* set transform for rotation, flip */
 		if (ops->set_transf) {
 			ret = ops->set_transf(ippdrv->dev, config->degree,
 				config->flip, &swap);
-			if (ret) {
-				DRM_ERROR("not support tranf.\n");
-				return -EINVAL;
-			}
+			if (ret)
+				return ret;
 		}
 
 		/* set size */
 		if (ops->set_size) {
 			ret = ops->set_size(ippdrv->dev, swap, &config->pos,
 				&config->sz);
-			if (ret) {
-				DRM_ERROR("not support size.\n");
+			if (ret)
 				return ret;
-			}
 		}
 	}
 
-- 
1.9.1

