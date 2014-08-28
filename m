Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965795AbaH1JJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:09:55 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56444 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934800AbaH1JIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:32 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-ee-53fef18a3214
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
Subject: [PATCH v2 12/17] drm/exynos/fimc: avoid clearing overflow bits
Date: Thu, 28 Aug 2014 11:07:36 +0200
Message-id: <1409216861-12452-13-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xy7pdH/8FG1zYKGhxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJVxaVEja8Fk9opbLSdYGhgnsXUxcnJICJhI3D28jxHCFpO4cG89
	UJyLQ0hgKaPEqjfT2CGcPiaJeYeOMYNUsQloSvzdfBOsW0RAWWLVvnawImaBj0wSV5a+ASsS
	FnCXOPV2CZjNIqAqcft6G5jNK+Ai0dA4B2qdnMTJY5NZQWxOoPjG42/YQWwhAWeJ3ec/M01g
	5F3AyLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIySwvuxgXHzM6hCjAAejEg/vhtJ/wUKs
	iWXFlbmHGCU4mJVEeI8eBwrxpiRWVqUW5ccXleakFh9iZOLglGpg3GAXNe9J4KeDHvvDOn2n
	FCRaVuS8M3lrdP603oNzf7PSa9g17s99xJ529Npzj/i655VffwfOXBF/+M3pyx/1J9la2XOt
	meOsl1rTvPEM8xLeeue6ksya38bvOHWM7s+5ZBzpm/pwDs+8nUHd3b4J2tGH69b2NJZHPsqs
	FfjFqsR2UTXtnXmcEktxRqKhFnNRcSIAPVMBhAoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overflow bits shall be cleared by H/W.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 34367ff..6dc9c41 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -341,9 +341,6 @@ static bool fimc_check_ovf(struct fimc_context *ctx)
 		fimc_set_bits(ctx, EXYNOS_CIWDOFST,
 			EXYNOS_CIWDOFST_CLROVFIY | EXYNOS_CIWDOFST_CLROVFICB |
 			EXYNOS_CIWDOFST_CLROVFICR);
-		fimc_clear_bits(ctx, EXYNOS_CIWDOFST,
-			EXYNOS_CIWDOFST_CLROVFIY | EXYNOS_CIWDOFST_CLROVFICB |
-			EXYNOS_CIWDOFST_CLROVFICR);
 
 		dev_err(ippdrv->dev, "occurred overflow at %d, status 0x%x.\n",
 			ctx->id, status);
-- 
1.9.1

