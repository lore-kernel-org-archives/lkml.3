Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab3CKT0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:26:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45613 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3CKT0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:26:07 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: gpu: drm: exynos: Replaced kzalloc & memcpy with kmemdup
Date: Mon, 11 Mar 2013 21:25:22 +0200
Message-Id: <1363029923-22122-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced calls to kzalloc followed by memcpy with call to kmemdup.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/gpu/drm/exynos/exynos_drm_vidi.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_vidi.c b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
index 13ccbd4..9504b0c 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
@@ -117,13 +117,12 @@ static struct edid *vidi_get_edid(struct device *dev,
 	}
 
 	edid_len = (1 + ctx->raw_edid->extensions) * EDID_LENGTH;
-	edid = kzalloc(edid_len, GFP_KERNEL);
+	edid = kmemdup(ctx->raw_edid, edid_len, GFP_KERNEL);
 	if (!edid) {
 		DRM_DEBUG_KMS("failed to allocate edid\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
-	memcpy(edid, ctx->raw_edid, edid_len);
 	return edid;
 }
 
@@ -563,12 +562,11 @@ int vidi_connection_ioctl(struct drm_device *drm_dev, void *data,
 			return -EINVAL;
 		}
 		edid_len = (1 + raw_edid->extensions) * EDID_LENGTH;
-		ctx->raw_edid = kzalloc(edid_len, GFP_KERNEL);
+		ctx->raw_edid = kmemdup(raw_edid, edid_len, GFP_KERNEL);
 		if (!ctx->raw_edid) {
 			DRM_DEBUG_KMS("failed to allocate raw_edid.\n");
 			return -ENOMEM;
 		}
-		memcpy(ctx->raw_edid, raw_edid, edid_len);
 	} else {
 		/*
 		 * with connection = 0, free raw_edid
-- 
1.7.9.5

