Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab3FDO17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:27:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46634 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab3FDOHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 05/70] drm/radeon: Fix VRAM size calculation for VRAM >= 4GB
Date: Tue,  4 Jun 2013 15:06:21 +0100
Message-Id: <1370354846-14213-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niels Ole Salscheider <niels_ole@salscheider-online.de>

commit fc986034540102cd090237bf3f70262e1ae80d9c upstream.

Add ULL prefix to avoid overflow.

Signed-off-by: Niels Ole Salscheider <niels_ole@salscheider-online.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c  | 4 ++--
 drivers/gpu/drm/radeon/radeon_ttm.c | 2 +-
 drivers/gpu/drm/radeon/si.c         | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index dd708a3..d18b343 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2176,8 +2176,8 @@ int evergreen_mc_init(struct radeon_device *rdev)
 		rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE);
 	} else {
 		/* size in MB on evergreen/cayman/tn */
-		rdev->mc.mc_vram_size = RREG32(CONFIG_MEMSIZE) * 1024 * 1024;
-		rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE) * 1024 * 1024;
+		rdev->mc.mc_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
+		rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
 	}
 	rdev->mc.visible_vram_size = rdev->mc.aper_size;
 	r700_vram_gtt_location(rdev, &rdev->mc);
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index c94a225..7296b56 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -753,7 +753,7 @@ int radeon_ttm_init(struct radeon_device *rdev)
 		return r;
 	}
 	DRM_INFO("radeon: %uM of VRAM memory ready\n",
-		 (unsigned)rdev->mc.real_vram_size / (1024 * 1024));
+		 (unsigned) (rdev->mc.real_vram_size / (1024 * 1024)));
 	r = ttm_bo_init_mm(&rdev->mman.bdev, TTM_PL_TT,
 				rdev->mc.gtt_size >> PAGE_SHIFT);
 	if (r) {
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index c43a544..e1b21ea 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2310,8 +2310,8 @@ static int si_mc_init(struct radeon_device *rdev)
 	rdev->mc.aper_base = pci_resource_start(rdev->pdev, 0);
 	rdev->mc.aper_size = pci_resource_len(rdev->pdev, 0);
 	/* size in MB on si */
-	rdev->mc.mc_vram_size = RREG32(CONFIG_MEMSIZE) * 1024 * 1024;
-	rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE) * 1024 * 1024;
+	rdev->mc.mc_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
+	rdev->mc.real_vram_size = RREG32(CONFIG_MEMSIZE) * 1024ULL * 1024ULL;
 	rdev->mc.visible_vram_size = rdev->mc.aper_size;
 	si_vram_gtt_location(rdev, &rdev->mc);
 	radeon_update_bandwidth_info(rdev);
-- 
1.8.1.2

