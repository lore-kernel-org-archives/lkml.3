Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbbAMSs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:48:56 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43162 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbbAMSsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:48:54 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/radeon/sumo_dpm: Remove some unused functions
Date: Tue, 13 Jan 2015 19:52:00 +0100
Message-Id: <1421175120-6214-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
sumo_convert_vid7_to_vid2() sumo_dpm_reset_asic()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/sumo_dpm.c |   26 --------------------------
 drivers/gpu/drm/radeon/sumo_dpm.h |    3 ---
 2 files changed, 29 deletions(-)

diff --git a/drivers/gpu/drm/radeon/sumo_dpm.c b/drivers/gpu/drm/radeon/sumo_dpm.c
index 1f8a883..e5d66a2 100644
--- a/drivers/gpu/drm/radeon/sumo_dpm.c
+++ b/drivers/gpu/drm/radeon/sumo_dpm.c
@@ -1338,18 +1338,6 @@ void sumo_dpm_post_set_power_state(struct radeon_device *rdev)
 	sumo_update_current_ps(rdev, new_ps);
 }
 
-void sumo_dpm_reset_asic(struct radeon_device *rdev)
-{
-	sumo_program_bootup_state(rdev);
-	sumo_enable_power_level_0(rdev);
-	sumo_set_forced_level_0(rdev);
-	sumo_set_forced_mode_enabled(rdev);
-	sumo_wait_for_level_0(rdev);
-	sumo_set_forced_mode_disabled(rdev);
-	sumo_set_forced_mode_enabled(rdev);
-	sumo_set_forced_mode_disabled(rdev);
-}
-
 void sumo_dpm_setup_asic(struct radeon_device *rdev)
 {
 	struct sumo_power_info *pi = sumo_get_pi(rdev);
@@ -1537,20 +1525,6 @@ u32 sumo_convert_vid2_to_vid7(struct radeon_device *rdev,
 	return vid_mapping_table->entries[vid_mapping_table->num_entries - 1].vid_7bit;
 }
 
-u32 sumo_convert_vid7_to_vid2(struct radeon_device *rdev,
-			      struct sumo_vid_mapping_table *vid_mapping_table,
-			      u32 vid_7bit)
-{
-	u32 i;
-
-	for (i = 0; i < vid_mapping_table->num_entries; i++) {
-		if (vid_mapping_table->entries[i].vid_7bit == vid_7bit)
-			return vid_mapping_table->entries[i].vid_2bit;
-	}
-
-	return vid_mapping_table->entries[vid_mapping_table->num_entries - 1].vid_2bit;
-}
-
 static u16 sumo_convert_voltage_index_to_value(struct radeon_device *rdev,
 					       u32 vid_2bit)
 {
diff --git a/drivers/gpu/drm/radeon/sumo_dpm.h b/drivers/gpu/drm/radeon/sumo_dpm.h
index db1ea32..07dda29 100644
--- a/drivers/gpu/drm/radeon/sumo_dpm.h
+++ b/drivers/gpu/drm/radeon/sumo_dpm.h
@@ -202,9 +202,6 @@ void sumo_construct_vid_mapping_table(struct radeon_device *rdev,
 u32 sumo_convert_vid2_to_vid7(struct radeon_device *rdev,
 			      struct sumo_vid_mapping_table *vid_mapping_table,
 			      u32 vid_2bit);
-u32 sumo_convert_vid7_to_vid2(struct radeon_device *rdev,
-			      struct sumo_vid_mapping_table *vid_mapping_table,
-			      u32 vid_7bit);
 u32 sumo_get_sleep_divider_from_id(u32 id);
 u32 sumo_get_sleep_divider_id_from_clock(struct radeon_device *rdev,
 					 u32 sclk,
-- 
1.7.10.4

