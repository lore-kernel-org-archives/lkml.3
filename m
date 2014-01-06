Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaAFPve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:51:34 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:56575 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaAFPvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:51:32 -0500
Date: Mon, 6 Jan 2014 21:21:27 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Jerome Glisse <jglisse@redhat.com>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 42/85] drivers: gpu: Move prototype declarations to header
 file radeon_asic.h
Message-ID: <775097e94f4c897f68990de99aa10e59ab62c64a.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declaration of functions evergreen_mc_stop(),
evergreen_mc_resume(), evergreen_is_display_hung(), sumo_rlc_fini(),
sumo_rlc_init(), evergreen_fix_pci_max_read_req_size(),
evergreen_get_number_of_dram_channels(), evergreen_mc_program(),
evergreen_mc_init(), evergreen_gpu_check_soft_reset(),
evergreen_rlc_resume() and evergreen_irq_suspend() to header file
drm/radeon/radeon_asic.h because they are used by more than one file.

This eliminates the following warnings in drm/radeon/evergreen.c:
drivers/gpu/drm/radeon/evergreen.c:1175:6: warning: no previous prototype for ‘evergreen_fix_pci_max_read_req_size’ [-Wmissing-prototypes] 
drivers/gpu/drm/radeon/evergreen.c:1950:5: warning: no previous prototype for ‘evergreen_get_number_of_dram_channels’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/evergreen.c:2548:6: warning: no previous prototype for ‘evergreen_mc_stop’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/evergreen.c:2634:6: warning: no previous prototype for ‘evergreen_mc_resume’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/evergreen.c:2722:6: warning: no previous prototype for ‘evergreen_mc_program’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/evergreen.c:3571:5: warning: no previous prototype for ‘evergreen_mc_init’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/evergreen.c:3630:6: warning: no previous prototype for ‘evergreen_print_gpu_status_regs’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/evergreen.c:3658:6: warning: no previous prototype for ‘evergreen_is_display_hung’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/evergreen.c:3687:5: warning: no previous prototype for ‘evergreen_gpu_check_soft_reset’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/evergreen.c:3919:6: warning: no previous prototype for ‘sumo_rlc_fini’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/evergreen.c:3962:5: warning: no previous prototype for ‘sumo_rlc_init’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/evergreen.c:4186:5: warning: no previous prototype for ‘evergreen_rlc_resume’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/evergreen.c:4685:6: warning: no previous prototype for ‘evergreen_irq_suspend’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/cik.c           |    5 -----
 drivers/gpu/drm/radeon/evergreen_dma.c |    2 --
 drivers/gpu/drm/radeon/ni.c            |   10 ----------
 drivers/gpu/drm/radeon/r600.c          |    1 -
 drivers/gpu/drm/radeon/radeon_asic.h   |   13 +++++++++++++
 drivers/gpu/drm/radeon/si.c            |    8 --------
 6 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index fb5943c..bc21542 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -62,11 +62,6 @@ MODULE_FIRMWARE("radeon/KABINI_mec.bin");
 MODULE_FIRMWARE("radeon/KABINI_rlc.bin");
 MODULE_FIRMWARE("radeon/KABINI_sdma.bin");
 
-extern void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *save);
-extern void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *save);
-extern bool evergreen_is_display_hung(struct radeon_device *rdev);
-extern void sumo_rlc_fini(struct radeon_device *rdev);
-extern int sumo_rlc_init(struct radeon_device *rdev);
 extern void si_vram_gtt_location(struct radeon_device *rdev, struct radeon_mc *mc);
 extern void si_rlc_reset(struct radeon_device *rdev);
 extern void si_init_uvd_internal_cg(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/evergreen_dma.c b/drivers/gpu/drm/radeon/evergreen_dma.c
index a37b544..b4230bf 100644
--- a/drivers/gpu/drm/radeon/evergreen_dma.c
+++ b/drivers/gpu/drm/radeon/evergreen_dma.c
@@ -26,8 +26,6 @@
 #include "radeon_asic.h"
 #include "evergreend.h"
 
-u32 evergreen_gpu_check_soft_reset(struct radeon_device *rdev);
-
 /**
  * evergreen_dma_fence_ring_emit - emit a fence on the DMA ring
  *
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 11aab2a..2817382 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -161,19 +161,9 @@ static const u32 tn_rlc_save_restore_register_list[] =
 	0x802c,
 };
 
-extern bool evergreen_is_display_hung(struct radeon_device *rdev);
-extern void evergreen_print_gpu_status_regs(struct radeon_device *rdev);
-extern void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *save);
-extern void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *save);
 extern int evergreen_mc_wait_for_idle(struct radeon_device *rdev);
-extern void evergreen_mc_program(struct radeon_device *rdev);
-extern void evergreen_irq_suspend(struct radeon_device *rdev);
-extern int evergreen_mc_init(struct radeon_device *rdev);
-extern void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev);
 extern void evergreen_pcie_gen2_enable(struct radeon_device *rdev);
 extern void evergreen_program_aspm(struct radeon_device *rdev);
-extern void sumo_rlc_fini(struct radeon_device *rdev);
-extern int sumo_rlc_init(struct radeon_device *rdev);
 
 /* Firmware Names */
 MODULE_FIRMWARE("radeon/BARTS_pfp.bin");
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 9ad0673..6a517f3 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -104,7 +104,6 @@ static void r600_gpu_init(struct radeon_device *rdev);
 void r600_fini(struct radeon_device *rdev);
 void r600_irq_disable(struct radeon_device *rdev);
 static void r600_pcie_gen2_enable(struct radeon_device *rdev);
-extern int evergreen_rlc_resume(struct radeon_device *rdev);
 
 /**
  * r600_get_xclk - get the xclk
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index c9fd97b..5e1f169 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -560,6 +560,19 @@ void sumo_dpm_debugfs_print_current_performance_level(struct radeon_device *rdev
 						      struct seq_file *m);
 int sumo_dpm_force_performance_level(struct radeon_device *rdev,
 				     enum radeon_dpm_forced_level level);
+bool evergreen_is_display_hung(struct radeon_device *rdev);
+void evergreen_print_gpu_status_regs(struct radeon_device *rdev);
+void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *save);
+void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *save);
+void evergreen_mc_program(struct radeon_device *rdev);
+void evergreen_irq_suspend(struct radeon_device *rdev);
+int evergreen_mc_init(struct radeon_device *rdev);
+void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev);
+void sumo_rlc_fini(struct radeon_device *rdev);
+int sumo_rlc_init(struct radeon_device *rdev);
+u32 evergreen_get_number_of_dram_channels(struct radeon_device *rdev);
+u32 evergreen_gpu_check_soft_reset(struct radeon_device *rdev);
+int evergreen_rlc_resume(struct radeon_device *rdev);
 
 /*
  * cayman
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 762c5f6..b3047a7 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -68,14 +68,6 @@ MODULE_FIRMWARE("radeon/HAINAN_smc.bin");
 
 static void si_pcie_gen3_enable(struct radeon_device *rdev);
 static void si_program_aspm(struct radeon_device *rdev);
-extern void sumo_rlc_fini(struct radeon_device *rdev);
-extern int sumo_rlc_init(struct radeon_device *rdev);
-extern void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev);
-extern void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *save);
-extern void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *save);
-extern u32 evergreen_get_number_of_dram_channels(struct radeon_device *rdev);
-extern void evergreen_print_gpu_status_regs(struct radeon_device *rdev);
-extern bool evergreen_is_display_hung(struct radeon_device *rdev);
 static void si_enable_gui_idle_interrupt(struct radeon_device *rdev,
 					 bool enable);
 static void si_fini_pg(struct radeon_device *rdev);
-- 
1.7.9.5

