Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab3EGNnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:43:40 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:50758 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab3EGNnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:43:35 -0400
MIME-Version: 1.0
Date: Tue, 7 May 2013 21:43:33 +0800
Message-ID: <CAPgLHd9K0+A5dOOT2bj+fB1owkECMpSGBaqrq-Zs6b-t_G-_7A@mail.gmail.com>
Subject: [PATCH] drm/exynos: fix error return code in exynos_drm_load()
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

Fix to return -ENOMEM in the exynos_plane_init() error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/exynos/exynos_drm_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index ba6d995..3a10373 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -91,8 +91,10 @@ static int exynos_drm_load(struct drm_device *dev, unsigned long flags)
 		unsigned int possible_crtcs = (1 << MAX_CRTC) - 1;
 
 		plane = exynos_plane_init(dev, possible_crtcs, false);
-		if (!plane)
+		if (!plane) {
+			ret = -ENOMEM;
 			goto err_release_iommu_mapping;
+		}
 	}
 
 	ret = drm_vblank_init(dev, MAX_CRTC);

