Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab3EVWS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:18:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757681Ab3EVWSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:18:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 4/5] drm/radeon: Fix VRAM size calculation for VRAM >= 4GB
Date: Wed, 22 May 2013 15:18:10 -0700
Message-Id: <20130522221331.704470226@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130522221330.720801923@linuxfoundation.org>
References: <20130522221330.720801923@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niels Ole Salscheider <niels_ole@salscheider-online.de>

commit fc986034540102cd090237bf3f70262e1ae80d9c upstream.

Add ULL prefix to avoid overflow.

Signed-off-by: Niels Ole Salscheider <niels_ole@salscheider-online.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c  |    4 ++--
 drivers/gpu/drm/radeon/radeon_ttm.c |    2 +-
 drivers/gpu/drm/radeon/si.c         |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2443,8 +2443,8 @@ int evergreen_mc_init(struct radeon_devi
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
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -744,7 +744,7 @@ int radeon_ttm_init(struct radeon_device
 		return r;
 	}
 	DRM_INFO("radeon: %uM of VRAM memory ready\n",
-		 (unsigned)rdev->mc.real_vram_size / (1024 * 1024));
+		 (unsigned) (rdev->mc.real_vram_size / (1024 * 1024)));
 	r = ttm_bo_init_mm(&rdev->mman.bdev, TTM_PL_TT,
 				rdev->mc.gtt_size >> PAGE_SHIFT);
 	if (r) {
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -2464,8 +2464,8 @@ static int si_mc_init(struct radeon_devi
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


