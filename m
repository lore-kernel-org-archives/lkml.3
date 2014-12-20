Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaLTOxH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 09:53:07 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44315 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaLTOxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 09:53:04 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: radeon: radeon_atombios.c:  Remove unused function
Date: Sat, 20 Dec 2014 15:55:49 +0100
Message-Id: <1419087349-4493-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function radeon_atom_update_memory_dll() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/radeon.h          |    2 --
 drivers/gpu/drm/radeon/radeon_atombios.c |   11 -----------
 2 files changed, 13 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index a9717b3..c5a8c53 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -328,8 +328,6 @@ bool radeon_atom_is_voltage_gpio(struct radeon_device *rdev,
 int radeon_atom_get_svi2_info(struct radeon_device *rdev,
 			      u8 voltage_type,
 			      u8 *svd_gpio_id, u8 *svc_gpio_id);
-void radeon_atom_update_memory_dll(struct radeon_device *rdev,
-				   u32 mem_clock);
 void radeon_atom_set_ac_timing(struct radeon_device *rdev,
 			       u32 mem_clock);
 int radeon_atom_init_mc_reg_table(struct radeon_device *rdev,
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index df69b92..74017da 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -3027,17 +3027,6 @@ void radeon_atom_set_engine_dram_timings(struct radeon_device *rdev,
 	atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
 }
 
-void radeon_atom_update_memory_dll(struct radeon_device *rdev,
-				   u32 mem_clock)
-{
-	u32 args;
-	int index = GetIndexIntoMasterTable(COMMAND, DynamicMemorySettings);
-
-	args = cpu_to_le32(mem_clock);	/* 10 khz */
-
-	atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
-}
-
 void radeon_atom_set_ac_timing(struct radeon_device *rdev,
 			       u32 mem_clock)
 {
-- 
1.7.10.4

