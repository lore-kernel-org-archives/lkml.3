Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaAFP5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:57:18 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64361 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbaAFP5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:57:16 -0500
Date: Mon, 6 Jan 2014 21:27:09 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 47/85] drivers: gpu: Move prototype declarations to
 appropriate header file radeon_asic.h
Message-ID: <98067785396b84ed3b6f0c5832fc74d4b27cd63c.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declarations of functions si_vram_gtt_location(),
si_rlc_reset(), si_init_uvd_internal_cg(), si_get_csb_size(),
si_get_csb_buffer(), si_gpu_check_soft_reset() and si_update_cg() to
header file drm/radeon/radeon_asic.h because they are used by more than
one file.

Also, include the header file in drm/radeon/si_dpm.c because it uses the
functions declared in the header file.

This eliminates the following warnings in drm/radeon/si.c:
drivers/gpu/drm/radeon/si.c:3510:5: warning: no previous prototype for ‘si_gpu_check_soft_reset’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si.c:3818:6: warning: no previous prototype for ‘si_vram_gtt_location’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si.c:4786:6: warning: no previous prototype for ‘si_init_uvd_internal_cg’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si.c:5211:6: warning: no previous prototype for ‘si_update_cg’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si.c:5277:5: warning: no previous prototype for ‘si_get_csb_size’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si.c:5309:6: warning: no previous prototype for ‘si_get_csb_buffer’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/si.c:5398:6: warning: no previous prototype for ‘si_rlc_reset’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/cik.c         |    3 ---
 drivers/gpu/drm/radeon/evergreen.c   |    2 --
 drivers/gpu/drm/radeon/radeon_asic.h |    8 ++++++++
 drivers/gpu/drm/radeon/si_dma.c      |    2 --
 drivers/gpu/drm/radeon/si_dpm.c      |    4 +---
 5 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index bc21542..76902ca 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -62,9 +62,6 @@ MODULE_FIRMWARE("radeon/KABINI_mec.bin");
 MODULE_FIRMWARE("radeon/KABINI_rlc.bin");
 MODULE_FIRMWARE("radeon/KABINI_sdma.bin");
 
-extern void si_vram_gtt_location(struct radeon_device *rdev, struct radeon_mc *mc);
-extern void si_rlc_reset(struct radeon_device *rdev);
-extern void si_init_uvd_internal_cg(struct radeon_device *rdev);
 extern int cik_sdma_resume(struct radeon_device *rdev);
 extern void cik_sdma_enable(struct radeon_device *rdev, bool enable);
 extern void cik_sdma_fini(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index f4806ed..534a2fa 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -138,8 +138,6 @@ void evergreen_pcie_gen2_enable(struct radeon_device *rdev);
 void evergreen_program_aspm(struct radeon_device *rdev);
 void cik_init_cp_pg_table(struct radeon_device *rdev);
 
-extern u32 si_get_csb_size(struct radeon_device *rdev);
-extern void si_get_csb_buffer(struct radeon_device *rdev, volatile u32 *buffer);
 extern u32 cik_get_csb_size(struct radeon_device *rdev);
 extern void cik_get_csb_buffer(struct radeon_device *rdev, volatile u32 *buffer);
 
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index 732fb6c..51ec129c 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -697,6 +697,14 @@ void si_dpm_debugfs_print_current_performance_level(struct radeon_device *rdev,
 						    struct seq_file *m);
 int si_dpm_force_performance_level(struct radeon_device *rdev,
 				   enum radeon_dpm_forced_level level);
+u32 si_gpu_check_soft_reset(struct radeon_device *rdev);
+void si_vram_gtt_location(struct radeon_device *rdev, struct radeon_mc *mc);
+void si_rlc_reset(struct radeon_device *rdev);
+void si_init_uvd_internal_cg(struct radeon_device *rdev);
+void si_update_cg(struct radeon_device *rdev,
+		  u32 block, bool enable);
+u32 si_get_csb_size(struct radeon_device *rdev);
+void si_get_csb_buffer(struct radeon_device *rdev, volatile u32 *buffer);
 
 /* DCE8 - CIK */
 void dce8_bandwidth_update(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/si_dma.c b/drivers/gpu/drm/radeon/si_dma.c
index 59be2cf..cc15f59 100644
--- a/drivers/gpu/drm/radeon/si_dma.c
+++ b/drivers/gpu/drm/radeon/si_dma.c
@@ -27,8 +27,6 @@
 #include "radeon_trace.h"
 #include "sid.h"
 
-u32 si_gpu_check_soft_reset(struct radeon_device *rdev);
-
 /**
  * si_dma_is_lockup - Check if the DMA engine is locked up
  *
diff --git a/drivers/gpu/drm/radeon/si_dpm.c b/drivers/gpu/drm/radeon/si_dpm.c
index 0b00c79..a3a5866 100644
--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -23,6 +23,7 @@
 
 #include "drmP.h"
 #include "radeon.h"
+#include "radeon_asic.h"
 #include "sid.h"
 #include "r600_dpm.h"
 #include "si_dpm.h"
@@ -1753,9 +1754,6 @@ static int si_calculate_sclk_params(struct radeon_device *rdev,
 				    u32 engine_clock,
 				    SISLANDS_SMC_SCLK_VALUE *sclk);
 
-extern void si_update_cg(struct radeon_device *rdev,
-			 u32 block, bool enable);
-
 static struct si_power_info *si_get_pi(struct radeon_device *rdev)
 {
         struct si_power_info *pi = rdev->pm.dpm.priv;
-- 
1.7.9.5

