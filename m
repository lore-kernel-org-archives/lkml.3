Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbaAFPb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:31:28 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33510 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaAFPbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:31:25 -0500
Date: Mon, 6 Jan 2014 21:01:20 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Jerome Glisse <jglisse@redhat.com>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 30/85] drivers: gpu: Move prototype declarations to
 appropriate header file  radeon.h
Message-ID: <578c7cfa386f228b49de13a2de9e64c64ab45e47.1389018325.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration to the header file drm/radeon/radeon.h from
files drm/radeon/cik.c, drm/radeon/r600_dma.c and drm/radeon/si.c
because they are used by more than one file.

This eliminates the following warnings in drm/radeon/r600.c:
drivers/gpu/drm/radeon/r600.c:1442:5: warning: no previous prototype for ‘r600_gpu_check_soft_reset’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/r600.c:3133:5: warning: no previous prototype for ‘r600_ih_ring_alloc’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/r600.c:3169:6: warning: no previous prototype for ‘r600_ih_ring_fini’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/cik.c      |    2 --
 drivers/gpu/drm/radeon/r600_dma.c |    2 --
 drivers/gpu/drm/radeon/radeon.h   |    5 +++++
 drivers/gpu/drm/radeon/si.c       |    2 --
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index b43a3a3..fb5943c 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -62,8 +62,6 @@ MODULE_FIRMWARE("radeon/KABINI_mec.bin");
 MODULE_FIRMWARE("radeon/KABINI_rlc.bin");
 MODULE_FIRMWARE("radeon/KABINI_sdma.bin");
 
-extern int r600_ih_ring_alloc(struct radeon_device *rdev);
-extern void r600_ih_ring_fini(struct radeon_device *rdev);
 extern void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *save);
 extern void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *save);
 extern bool evergreen_is_display_hung(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/r600_dma.c b/drivers/gpu/drm/radeon/r600_dma.c
index 7844d15..3e4b6d2 100644
--- a/drivers/gpu/drm/radeon/r600_dma.c
+++ b/drivers/gpu/drm/radeon/r600_dma.c
@@ -26,8 +26,6 @@
 #include "radeon_asic.h"
 #include "r600d.h"
 
-u32 r600_gpu_check_soft_reset(struct radeon_device *rdev);
-
 /*
  * DMA
  * Starting with R600, the GPU has an asynchronous
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index e874392..28414f2 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -100,6 +100,11 @@ extern int radeon_dpm;
 extern int radeon_aspm;
 extern int radeon_runtime_pm;
 
+u32 r600_gpu_check_soft_reset(struct radeon_device *rdev);
+
+void r600_ih_ring_fini(struct radeon_device *rdev);
+int r600_ih_ring_alloc(struct radeon_device *rdev);
+
 /*
  * Copy from radeon_drv.h so we don't have to include both and have conflicting
  * symbol;
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index a36736d..762c5f6 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -70,8 +70,6 @@ static void si_pcie_gen3_enable(struct radeon_device *rdev);
 static void si_program_aspm(struct radeon_device *rdev);
 extern void sumo_rlc_fini(struct radeon_device *rdev);
 extern int sumo_rlc_init(struct radeon_device *rdev);
-extern int r600_ih_ring_alloc(struct radeon_device *rdev);
-extern void r600_ih_ring_fini(struct radeon_device *rdev);
 extern void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev);
 extern void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *save);
 extern void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *save);
-- 
1.7.9.5

