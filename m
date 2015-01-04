Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbbADOom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 09:44:42 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:35140 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbbADOok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 09:44:40 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: radeon: ci_smc: Remove unused function
Date: Sun,  4 Jan 2015 15:47:39 +0100
Message-Id: <1420382860-9141-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function ci_wait_for_smc_inactive() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/ci_dpm.h |    1 -
 drivers/gpu/drm/radeon/ci_smc.c |   18 ------------------
 2 files changed, 19 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.h b/drivers/gpu/drm/radeon/ci_dpm.h
index 93bbed9..596d17e 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.h
+++ b/drivers/gpu/drm/radeon/ci_dpm.h
@@ -322,7 +322,6 @@ void ci_stop_smc_clock(struct radeon_device *rdev);
 void ci_start_smc_clock(struct radeon_device *rdev);
 bool ci_is_smc_running(struct radeon_device *rdev);
 PPSMC_Result ci_send_msg_to_smc(struct radeon_device *rdev, PPSMC_Msg msg);
-PPSMC_Result ci_wait_for_smc_inactive(struct radeon_device *rdev);
 int ci_load_smc_ucode(struct radeon_device *rdev, u32 limit);
 int ci_read_smc_sram_dword(struct radeon_device *rdev,
 			   u32 smc_address, u32 *value, u32 limit);
diff --git a/drivers/gpu/drm/radeon/ci_smc.c b/drivers/gpu/drm/radeon/ci_smc.c
index b630edc..4f78b8c 100644
--- a/drivers/gpu/drm/radeon/ci_smc.c
+++ b/drivers/gpu/drm/radeon/ci_smc.c
@@ -184,24 +184,6 @@ PPSMC_Result ci_send_msg_to_smc(struct radeon_device *rdev, PPSMC_Msg msg)
 	return (PPSMC_Result)tmp;
 }
 
-PPSMC_Result ci_wait_for_smc_inactive(struct radeon_device *rdev)
-{
-	u32 tmp;
-	int i;
-
-	if (!ci_is_smc_running(rdev))
-		return PPSMC_Result_OK;
-
-	for (i = 0; i < rdev->usec_timeout; i++) {
-                tmp = RREG32_SMC(SMC_SYSCON_CLOCK_CNTL_0);
-                if ((tmp & CKEN) == 0)
-			break;
-                udelay(1);
-        }
-
-	return PPSMC_Result_OK;
-}
-
 int ci_load_smc_ucode(struct radeon_device *rdev, u32 limit)
 {
 	unsigned long flags;
-- 
1.7.10.4

