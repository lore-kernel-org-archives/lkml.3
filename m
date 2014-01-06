Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaAFQAC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:00:02 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35362 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaAFQAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:00:00 -0500
Date: Mon, 6 Jan 2014 21:29:55 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Dave Airlie <airlied@gmail.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 48/85] drivers: gpu: Move prototype declaration to header
 file radeon_asic.h from ci_dpm.c, cik_sdma.c, evergreen.c and kv_dpm.c
Message-ID: <b83efd5b22681fe88a487ff3af30b873574f8e5d.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declaration of functions cik_gpu_check_soft_reset(),
cik_enter_rlc_safe_mode(), cik_exit_rlc_safe_mode(), cik_update_cg(),
cik_init_cp_pg_table(), cik_get_csb_size() and cik_get_csb_buffer() to
header file drm/radeon/radeon_asic.h because they are used by more than
one file.

Also include the header file in drm/radeon/ci_dpm.c because it uses
functions declared in the file.

This eliminates the following warning in
drivers/gpu/drm/radeon/cik.c:4648:5: warning: no previous prototype for ‘cik_gpu_check_soft_reset’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/cik.c:5481:6: warning: no previous prototype for ‘cik_enter_rlc_safe_mode’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/cik.c:5502:6: warning: no previous prototype for ‘cik_exit_rlc_safe_mode’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/cik.c:5900:6: warning: no previous prototype for ‘cik_update_cg’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/cik.c:6028:6: warning: no previous prototype for ‘cik_init_cp_pg_table’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/cik.c:6239:5: warning: no previous prototype for ‘cik_get_csb_size’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/cik.c:6271:6: warning: no previous prototype for ‘cik_get_csb_buffer’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/ci_dpm.c      |    5 +----
 drivers/gpu/drm/radeon/cik_sdma.c    |    2 --
 drivers/gpu/drm/radeon/evergreen.c   |    4 ----
 drivers/gpu/drm/radeon/kv_dpm.c      |    5 -----
 drivers/gpu/drm/radeon/radeon_asic.h |    8 ++++++++
 5 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index 1ed4799..899c843 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -23,6 +23,7 @@
 
 #include "drmP.h"
 #include "radeon.h"
+#include "radeon_asic.h"
 #include "cikd.h"
 #include "r600_dpm.h"
 #include "ci_dpm.h"
@@ -169,10 +170,6 @@ extern u8 si_get_mclk_frequency_ratio(u32 memory_clock, bool strobe_mode);
 extern void si_trim_voltage_table_to_fit_state_table(struct radeon_device *rdev,
 						     u32 max_voltage_steps,
 						     struct atom_voltage_table *voltage_table);
-extern void cik_enter_rlc_safe_mode(struct radeon_device *rdev);
-extern void cik_exit_rlc_safe_mode(struct radeon_device *rdev);
-extern void cik_update_cg(struct radeon_device *rdev,
-			  u32 block, bool enable);
 
 static int ci_get_std_voltage_value_sidd(struct radeon_device *rdev,
 					 struct atom_voltage_table_entry *voltage_table,
diff --git a/drivers/gpu/drm/radeon/cik_sdma.c b/drivers/gpu/drm/radeon/cik_sdma.c
index 0300727..2fc7ede 100644
--- a/drivers/gpu/drm/radeon/cik_sdma.c
+++ b/drivers/gpu/drm/radeon/cik_sdma.c
@@ -32,8 +32,6 @@
 #define CIK_SDMA_UCODE_SIZE 1050
 #define CIK_SDMA_UCODE_VERSION 64
 
-u32 cik_gpu_check_soft_reset(struct radeon_device *rdev);
-
 /*
  * sDMA - System DMA
  * Starting with CIK, the GPU has new asynchronous
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 534a2fa..3b68229 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -136,10 +136,6 @@ static void evergreen_gpu_init(struct radeon_device *rdev);
 void evergreen_fini(struct radeon_device *rdev);
 void evergreen_pcie_gen2_enable(struct radeon_device *rdev);
 void evergreen_program_aspm(struct radeon_device *rdev);
-void cik_init_cp_pg_table(struct radeon_device *rdev);
-
-extern u32 cik_get_csb_size(struct radeon_device *rdev);
-extern void cik_get_csb_buffer(struct radeon_device *rdev, volatile u32 *buffer);
 
 static const u32 evergreen_golden_registers[] =
 {
diff --git a/drivers/gpu/drm/radeon/kv_dpm.c b/drivers/gpu/drm/radeon/kv_dpm.c
index b419055..7e58dfb 100644
--- a/drivers/gpu/drm/radeon/kv_dpm.c
+++ b/drivers/gpu/drm/radeon/kv_dpm.c
@@ -56,11 +56,6 @@ static void kv_dpm_powergate_vce(struct radeon_device *rdev, bool gate);
 static void kv_dpm_powergate_samu(struct radeon_device *rdev, bool gate);
 static void kv_dpm_powergate_acp(struct radeon_device *rdev, bool gate);
 
-extern void cik_enter_rlc_safe_mode(struct radeon_device *rdev);
-extern void cik_exit_rlc_safe_mode(struct radeon_device *rdev);
-extern void cik_update_cg(struct radeon_device *rdev,
-			  u32 block, bool enable);
-
 static const struct kv_lcac_config_values sx_local_cac_cfg_kv[] =
 {
 	{  0,       4,        1    },
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index 51ec129c..1d631cd 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -712,6 +712,14 @@ void dce8_bandwidth_update(struct radeon_device *rdev);
 /*
  * cik
  */
+u32 cik_gpu_check_soft_reset(struct radeon_device *rdev);
+void cik_enter_rlc_safe_mode(struct radeon_device *rdev);
+void cik_exit_rlc_safe_mode(struct radeon_device *rdev);
+void cik_update_cg(struct radeon_device *rdev,
+		   u32 block, bool enable);
+void cik_init_cp_pg_table(struct radeon_device *rdev);
+u32 cik_get_csb_size(struct radeon_device *rdev);
+void cik_get_csb_buffer(struct radeon_device *rdev, volatile u32 *buffer);
 uint64_t cik_get_gpu_clock_counter(struct radeon_device *rdev);
 u32 cik_get_xclk(struct radeon_device *rdev);
 uint32_t cik_pciep_rreg(struct radeon_device *rdev, uint32_t reg);
-- 
1.7.9.5

