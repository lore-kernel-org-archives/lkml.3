Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaDDJWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:22:40 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53015 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaDDJWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:22:20 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Inki Dae <inki.dae@samsung.com>, dri-devel@lists.freedesktop.org
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 2/2] drm/exynos/fbdev: don't set mode_config.fb_base
Date: Fri,  4 Apr 2014 17:22:02 +0800
Message-Id: <1396603322-13585-2-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1396603322-13585-1-git-send-email-djkurtz@chromium.org>
References: <1396603322-13585-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AFAICT, the fb_base of a drm_device's mode_config is never used.  It isn't
accessed by core drm, it isn't used by fbmem, and it isn't exposed to user
space.

Furthermore, it is probably supposed to be a physical address, not the
dma address mapped to the display controller, so this is just wrong.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
index 2dcc589..3270a36 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
@@ -121,7 +121,6 @@ static int exynos_drm_fbdev_update(struct drm_fb_helper *helper,
 	offset = fbi->var.xoffset * (fb->bits_per_pixel >> 3);
 	offset += fbi->var.yoffset * fb->pitches[0];
 
-	dev->mode_config.fb_base = (resource_size_t)buffer->dma_addr;
 	fbi->screen_base = buffer->kvaddr + offset;
 	fbi->screen_size = size;
 
-- 
1.9.1.423.g4596e3a

