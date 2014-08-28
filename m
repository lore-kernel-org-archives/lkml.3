Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965779AbaH1JJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:09:37 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54144 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936338AbaH1JIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:36 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-ee-53fef18e021e
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
Subject: [PATCH v2 15/17] drm/exynos/fimc: fix source buffer registers
Date: Thu, 28 Aug 2014 11:07:39 +0200
Message-id: <1409216861-12452-16-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xy7p9H/8FGyw5xGxxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJWx4tEr9oKfvBXXX7A3MN7k7mLk5JAQMJFY/XE2C4QtJnHh3nq2
	LkYuDiGBpYwS51c1QTl9TBId0y6yg1SxCWhK/N18kw3EFhFQlli1r50dpIhZ4COTxJWlb5hB
	EsICbhLHDyxnArFZBFQl+k80gsV5BVwkDr/bDLVOTuLkscmsIDYnUHzj8TdgC4QEnCV2n//M
	NIGRdwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkLD6uoNx6TGrQ4wCHIxKPLwKp/8E
	C7EmlhVX5h5ilOBgVhLhPXr8X7AQb0piZVVqUX58UWlOavEhRiYOTqkGRrO2v9denpHfkeQY
	Mb39Y6tMaB/j+h9HPnrZ3Z1ZuI751P37Fockmszs2qdt+DrdqCFlCdusWhejxbmehlpF8kdb
	j3rf+Gfw+tfZHS7qcTbrGURz0ituXrp6acHP6wkRBbVMVW8rP8TeOpbZeWn/uioH1f7p8ndC
	yv9u4PZ5EVrK+C07VWS5hhJLcUaioRZzUXEiAD3ffd0JAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIMC in default mode of operation uses only one input buffer,
but the driver used also second buffer, as a result only the
first frame was processed correctly. The patch fixes it.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 59ba8bb..e2c43b4 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -722,24 +722,24 @@ static int fimc_src_set_addr(struct device *dev,
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

