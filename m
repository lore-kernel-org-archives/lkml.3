Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbbAKPYy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 10:24:54 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:54732 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbbAKPYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 10:24:53 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm: radeon: ni_dpm: Remove unused function
Date: Sun, 11 Jan 2015 16:27:58 +0100
Message-Id: <1420990078-19473-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function ni_dpm_reset_asic() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/ni_dpm.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ni_dpm.c b/drivers/gpu/drm/radeon/ni_dpm.c
index 6d2f16c..dcd5568 100644
--- a/drivers/gpu/drm/radeon/ni_dpm.c
+++ b/drivers/gpu/drm/radeon/ni_dpm.c
@@ -3862,12 +3862,6 @@ void ni_dpm_post_set_power_state(struct radeon_device *rdev)
 	ni_update_current_ps(rdev, new_ps);
 }
 
-void ni_dpm_reset_asic(struct radeon_device *rdev)
-{
-	ni_restrict_performance_levels_before_switch(rdev);
-	rv770_set_boot_state(rdev);
-}
-
 union power_info {
 	struct _ATOM_POWERPLAY_INFO info;
 	struct _ATOM_POWERPLAY_INFO_V2 info_2;
-- 
1.7.10.4

