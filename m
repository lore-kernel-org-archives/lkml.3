Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab3APQKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:10:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36891 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988Ab3APQKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:10:48 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Dave Airlie <airlied@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 204/222] drm/nouveau: fix init with agpgart-uninorth
Date: Wed, 16 Jan 2013 13:56:44 -0200
Message-Id: <1358351822-7675-205-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit eda85d6ad490923152544fba0473798b6cc0edf6 upstream.

Check that the AGP aperture can be mapped. This follows a similar change
done for Radeon (commit 365048ff, drm/radeon: AGP memory is only I/O if
the aperture can be mapped by the CPU.).

The patch fixes the following error seen on G5 iMac:

	nouveau E[     DRM] failed to create kernel channel, -12

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=58806
Reviewed-by: Michel Dänzer <michel@daenzer.net>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 7f80ed5..994afd0 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -1179,7 +1179,7 @@ nouveau_ttm_io_mem_reserve(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem)
 		if (dev_priv->gart_info.type == NOUVEAU_GART_AGP) {
 			mem->bus.offset = mem->start << PAGE_SHIFT;
 			mem->bus.base = dev_priv->gart_info.aper_base;
-			mem->bus.is_iomem = true;
+			mem->bus.is_iomem = !dev->agp->cant_use_aperture;
 		}
 #endif
 		break;
-- 
1.7.9.5

