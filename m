Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbbAKPpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 10:45:07 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:56353 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbbAKPpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 10:45:03 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm: radeon: trinity_dpm: Remove unused function
Date: Sun, 11 Jan 2015 16:48:08 +0100
Message-Id: <1420991288-20374-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function trinity_dpm_reset_asic() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/trinity_dpm.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/gpu/drm/radeon/trinity_dpm.c b/drivers/gpu/drm/radeon/trinity_dpm.c
index b4ec5c4..7428da0 100644
--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -1269,22 +1269,6 @@ void trinity_dpm_setup_asic(struct radeon_device *rdev)
 	trinity_release_mutex(rdev);
 }
 
-void trinity_dpm_reset_asic(struct radeon_device *rdev)
-{
-	struct trinity_power_info *pi = trinity_get_pi(rdev);
-
-	trinity_acquire_mutex(rdev);
-	if (pi->enable_dpm) {
-		trinity_enable_power_level_0(rdev);
-		trinity_force_level_0(rdev);
-		trinity_wait_for_level_0(rdev);
-		trinity_program_bootup_state(rdev);
-		trinity_force_level_0(rdev);
-		trinity_unforce_levels(rdev);
-	}
-	trinity_release_mutex(rdev);
-}
-
 static u16 trinity_convert_voltage_index_to_value(struct radeon_device *rdev,
 						  u32 vid_2bit)
 {
-- 
1.7.10.4

