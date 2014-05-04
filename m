Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaEDP0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:26:40 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40297 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaEDP0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:26:36 -0400
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
Subject: [PATCH 1/4] drm/exynos/mixer: move format definitions to regs-mixer
Date: Sun,  4 May 2014 23:26:18 +0800
Message-Id: <1399217181-26442-2-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1399217181-26442-1-git-send-email-djkurtz@chromium.org>
References: <1399217181-26442-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These constants directly define register values, so move them to the
register definition header.

Also, the logic used for setting fmt from bpp is either/or, so just use
if/else.

** No functional change

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/exynos/exynos_mixer.c | 19 ++++---------------
 drivers/gpu/drm/exynos/regs-mixer.h   |  4 ++++
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
index ce28881..475eb49 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -518,21 +518,10 @@ static void mixer_graph_buffer(struct mixer_context *ctx, int win)
 
 	win_data = &ctx->win_data[win];
 
-	#define RGB565 4
-	#define ARGB1555 5
-	#define ARGB4444 6
-	#define ARGB8888 7
-
-	switch (win_data->bpp) {
-	case 16:
-		fmt = ARGB4444;
-		break;
-	case 32:
-		fmt = ARGB8888;
-		break;
-	default:
-		fmt = ARGB8888;
-	}
+	if (win_data->bpp == 16)
+		fmt = MXR_GRP_CFG_FORMAT_ARGB4444;
+	else
+		fmt = MXR_GRP_CFG_FORMAT_ARGB8888;
 
 	/* 2x scaling feature */
 	x_ratio = 0;
diff --git a/drivers/gpu/drm/exynos/regs-mixer.h b/drivers/gpu/drm/exynos/regs-mixer.h
index 4537026..785a97a 100644
--- a/drivers/gpu/drm/exynos/regs-mixer.h
+++ b/drivers/gpu/drm/exynos/regs-mixer.h
@@ -114,6 +114,10 @@
 #define MXR_GRP_CFG_PIXEL_BLEND_EN	(1 << 16)
 #define MXR_GRP_CFG_FORMAT_VAL(x)	MXR_MASK_VAL(x, 11, 8)
 #define MXR_GRP_CFG_FORMAT_MASK		MXR_GRP_CFG_FORMAT_VAL(~0)
+#define MXR_GRP_CFG_FORMAT_RGB565	4
+#define MXR_GRP_CFG_FORMAT_ARGB1555	5
+#define MXR_GRP_CFG_FORMAT_ARGB4444	6
+#define MXR_GRP_CFG_FORMAT_ARGB8888	7
 #define MXR_GRP_CFG_ALPHA_VAL(x)	MXR_MASK_VAL(x, 7, 0)
 
 /* bits for MXR_GRAPHICn_WH */
-- 
1.9.1.423.g4596e3a

