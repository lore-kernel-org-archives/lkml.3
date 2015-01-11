Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbbAKWSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:18:42 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62610 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbAKWSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:18:41 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/radeon/kv_dpm: Remove unused function
Date: Sun, 11 Jan 2015 23:21:46 +0100
Message-Id: <1421014906-24106-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function kv_dpm_reset_asic() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/kv_dpm.c |   21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/gpu/drm/radeon/kv_dpm.c b/drivers/gpu/drm/radeon/kv_dpm.c
index 9b42001..61a9b14 100644
--- a/drivers/gpu/drm/radeon/kv_dpm.c
+++ b/drivers/gpu/drm/radeon/kv_dpm.c
@@ -1925,27 +1925,6 @@ void kv_dpm_setup_asic(struct radeon_device *rdev)
 	kv_init_sclk_t(rdev);
 }
 
-void kv_dpm_reset_asic(struct radeon_device *rdev)
-{
-	struct kv_power_info *pi = kv_get_pi(rdev);
-
-	if (rdev->family == CHIP_KABINI || rdev->family == CHIP_MULLINS) {
-		kv_force_lowest_valid(rdev);
-		kv_init_graphics_levels(rdev);
-		kv_program_bootup_state(rdev);
-		kv_upload_dpm_settings(rdev);
-		kv_force_lowest_valid(rdev);
-		kv_unforce_levels(rdev);
-	} else {
-		kv_init_graphics_levels(rdev);
-		kv_program_bootup_state(rdev);
-		kv_freeze_sclk_dpm(rdev, true);
-		kv_upload_dpm_settings(rdev);
-		kv_freeze_sclk_dpm(rdev, false);
-		kv_set_enabled_level(rdev, pi->graphics_boot_level);
-	}
-}
-
 //XXX use sumo_dpm_display_configuration_changed
 
 static void kv_construct_max_power_limits_table(struct radeon_device *rdev,
-- 
1.7.10.4

