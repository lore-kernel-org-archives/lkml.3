Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbbAMSnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:43:49 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39740 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbbAMSns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:43:48 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/radeon/rv770_dpm: Remove some unused functions
Date: Tue, 13 Jan 2015 19:46:54 +0100
Message-Id: <1421174814-5560-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
rv770_read_smc_soft_register() rv770_dpm_reset_asic()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/rv770_dpm.c |   23 -----------------------
 drivers/gpu/drm/radeon/rv770_dpm.h |    2 --
 2 files changed, 25 deletions(-)

diff --git a/drivers/gpu/drm/radeon/rv770_dpm.c b/drivers/gpu/drm/radeon/rv770_dpm.c
index 755a8f9..a5b537a 100644
--- a/drivers/gpu/drm/radeon/rv770_dpm.c
+++ b/drivers/gpu/drm/radeon/rv770_dpm.c
@@ -231,16 +231,6 @@ u8 rv770_get_seq_value(struct radeon_device *rdev,
 		MC_CG_SEQ_DRAMCONF_S0 : MC_CG_SEQ_DRAMCONF_S1;
 }
 
-int rv770_read_smc_soft_register(struct radeon_device *rdev,
-				 u16 reg_offset, u32 *value)
-{
-	struct rv7xx_power_info *pi = rv770_get_pi(rdev);
-
-	return rv770_read_smc_sram_dword(rdev,
-					 pi->soft_regs_start + reg_offset,
-					 value, pi->sram_end);
-}
-
 int rv770_write_smc_soft_register(struct radeon_device *rdev,
 				  u16 reg_offset, u32 value)
 {
@@ -2075,19 +2065,6 @@ int rv770_dpm_set_power_state(struct radeon_device *rdev)
 	return 0;
 }
 
-void rv770_dpm_reset_asic(struct radeon_device *rdev)
-{
-	struct rv7xx_power_info *pi = rv770_get_pi(rdev);
-	struct radeon_ps *boot_ps = rdev->pm.dpm.boot_ps;
-
-	rv770_restrict_performance_levels_before_switch(rdev);
-	if (pi->dcodt)
-		rv770_program_dcodt_before_state_switch(rdev, boot_ps, boot_ps);
-	rv770_set_boot_state(rdev);
-	if (pi->dcodt)
-		rv770_program_dcodt_after_state_switch(rdev, boot_ps, boot_ps);
-}
-
 void rv770_dpm_setup_asic(struct radeon_device *rdev)
 {
 	struct rv7xx_power_info *pi = rv770_get_pi(rdev);
diff --git a/drivers/gpu/drm/radeon/rv770_dpm.h b/drivers/gpu/drm/radeon/rv770_dpm.h
index f776634..d12beab 100644
--- a/drivers/gpu/drm/radeon/rv770_dpm.h
+++ b/drivers/gpu/drm/radeon/rv770_dpm.h
@@ -278,8 +278,6 @@ void rv770_set_uvd_clock_after_set_eng_clock(struct radeon_device *rdev,
 void rv770_get_engine_memory_ss(struct radeon_device *rdev);
 
 /* smc */
-int rv770_read_smc_soft_register(struct radeon_device *rdev,
-				 u16 reg_offset, u32 *value);
 int rv770_write_smc_soft_register(struct radeon_device *rdev,
 				  u16 reg_offset, u32 value);
 
-- 
1.7.10.4

