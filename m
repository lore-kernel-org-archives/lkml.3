Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaHVHx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:53:57 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34690 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbaHVHxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:54 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-fa-53f6f710f781
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
Subject: [PATCH 15/15] drm/exynos/fimc: fix source buffer registers
Date: Fri, 22 Aug 2014 09:52:26 +0200
Message-id: <1408693946-15456-16-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xq7oC378FG+y8bmZxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXxakorU8Eh3orbzyawNjAu5+5i5OCQEDCRuP+joIuRE8gUk7hw
	bz1bFyMXh5DAUkaJWd/WM0M4fUwS97ufsIBUsQloSvzdfJMNxBYRUJZYta+dHaSIWeAjk8SV
	pW+YQRLCAs4Sa3bOYAKxWQRUJY7MWwzWzCvgIjHt3mM2iHVyEiePTWYFsTmB4hcOTgPrFQLq
	7bo9jWkCI+8CRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCFh9XUH49JjVocYBTgYlXh4
	I798DRZiTSwrrsw9xCjBwawkwrtp3rdgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzT73gWRDh5
	mbrW6wqyx7y5d+LhVvH7eoa+vyaHNe8/zD9T3EO0Te9JItvVCSL8ZzuyGw71ttXeerAmdm9R
	8grP7aV3ut7d1zp+K+pmIteZXW5VO41yan8WP9MT8Jo4+5KTUAv77+nLN9kqLpD5tL9czFpt
	ae7NfLapIX+uL84V+jOlX+GYygklluKMREMt5qLiRACfBTE0CQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIMC in default mode of operation uses only one input buffer,
but the driver used also second buffer, as a result only the
first frame was processed correctly. The patch fixes it.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index b20078e..e985253 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -720,24 +720,24 @@ static int fimc_src_set_addr(struct device *dev,
 	case IPP_BUF_ENQUEUE:
 		config = &property->config[EXYNOS_DRM_OPS_SRC];
 		fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_Y],
-			EXYNOS_CIIYSA(buf_id));
+			EXYNOS_CIIYSA0);
 
 		if (config->fmt == DRM_FORMAT_YVU420) {
 			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CR],
-				EXYNOS_CIICBSA(buf_id));
+				EXYNOS_CIICBSA0);
 			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CB],
-				EXYNOS_CIICRSA(buf_id));
+				EXYNOS_CIICRSA0);
 		} else {
 			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CB],
-				EXYNOS_CIICBSA(buf_id));
+				EXYNOS_CIICBSA0);
 			fimc_write(ctx, buf_info->base[EXYNOS_DRM_PLANAR_CR],
-				EXYNOS_CIICRSA(buf_id));
+				EXYNOS_CIICRSA0);
 		}
 		break;
 	case IPP_BUF_DEQUEUE:
-		fimc_write(ctx, 0x0, EXYNOS_CIIYSA(buf_id));
-		fimc_write(ctx, 0x0, EXYNOS_CIICBSA(buf_id));
-		fimc_write(ctx, 0x0, EXYNOS_CIICRSA(buf_id));
+		fimc_write(ctx, 0x0, EXYNOS_CIIYSA0);
+		fimc_write(ctx, 0x0, EXYNOS_CIICBSA0);
+		fimc_write(ctx, 0x0, EXYNOS_CIICRSA0);
 		break;
 	default:
 		/* bypass */
-- 
1.9.1

