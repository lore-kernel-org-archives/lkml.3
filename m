Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3EITrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:47:11 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:40283 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab3EITrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:47:04 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC/PATCH v2 6/8] radeon: Switch to arch_phys_wc_add and add a missing ..._del
Date: Thu,  9 May 2013 12:46:25 -0700
Message-Id: <4823aeff17c92461b40f1e3be03dbd13df78481a.1368128020.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <cover.1368128020.git.luto@amacapital.net>
References: <cover.1368128020.git.luto@amacapital.net>
In-Reply-To: <cover.1368128020.git.luto@amacapital.net>
References: <cover.1368128020.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/gpu/drm/radeon/radeon_object.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index d3aface..15cd34b 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -321,8 +321,8 @@ void radeon_bo_force_delete(struct radeon_device *rdev)
 int radeon_bo_init(struct radeon_device *rdev)
 {
 	/* Add an MTRR for the VRAM */
-	rdev->mc.vram_mtrr = mtrr_add(rdev->mc.aper_base, rdev->mc.aper_size,
-			MTRR_TYPE_WRCOMB, 1);
+	rdev->mc.vram_mtrr = arch_phys_wc_add(rdev->mc.aper_base,
+					      rdev->mc.aper_size);
 	DRM_INFO("Detected VRAM RAM=%lluM, BAR=%lluM\n",
 		rdev->mc.mc_vram_size >> 20,
 		(unsigned long long)rdev->mc.aper_size >> 20);
@@ -334,6 +334,7 @@ int radeon_bo_init(struct radeon_device *rdev)
 void radeon_bo_fini(struct radeon_device *rdev)
 {
 	radeon_ttm_fini(rdev);
+	arch_phys_wc_del(rdev->mc.vram_mtrr);
 }
 
 void radeon_bo_list_add_object(struct radeon_bo_list *lobj,
-- 
1.8.1.4

