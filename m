Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaEDP0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:26:43 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:49066 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaEDP0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:26:41 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanpaul@chromium.org, marcheu@chromium.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 2/4] drm/exynos/mixer: use MXR_GRP_SXY_SY
Date: Sun,  4 May 2014 23:26:19 +0800
Message-Id: <1399217181-26442-3-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1399217181-26442-1-git-send-email-djkurtz@chromium.org>
References: <1399217181-26442-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mixer hardware supports offsetting dma from start of source buffer using
the MXR_GRP_SXY register.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/exynos/exynos_mixer.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
index 475eb49..40cf39b 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -529,13 +529,11 @@ static void mixer_graph_buffer(struct mixer_context *ctx, int win)
 
 	dst_x_offset = win_data->crtc_x;
 	dst_y_offset = win_data->crtc_y;
+	src_x_offset = win_data->fb_x;
+	src_y_offset = win_data->fb_y;
 
 	/* converting dma address base and source offset */
-	dma_addr = win_data->dma_addr
-		+ (win_data->fb_x * win_data->bpp >> 3)
-		+ (win_data->fb_y * win_data->fb_width * win_data->bpp >> 3);
-	src_x_offset = 0;
-	src_y_offset = 0;
+	dma_addr = win_data->dma_addr;
 
 	if (win_data->scan_flags & DRM_MODE_FLAG_INTERLACE)
 		ctx->interlace = true;
-- 
1.9.1.423.g4596e3a

