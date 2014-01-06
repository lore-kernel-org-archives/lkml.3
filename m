Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbaAFQeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:34:24 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:63900 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387AbaAFQeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:34:22 -0500
Date: Mon, 6 Jan 2014 22:04:14 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 70/85] drivers: gpu: Remove unused function in kv_dpm.c
Message-ID: <ec51a801aa230687cec4c0dc9a738f674077ecb4.1389018325.git.rashika.kheria@gmail.com>
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

Remove unused function kv_dpm_reset_asic() from drm/radeon/kv_dpm.c.

This eliminates the following warnings in drm/radeon/kv_dpm.c:
drivers/gpu/drm/radeon/kv_dpm.c:1875:6: warning: no previous prototype for ‘kv_dpm_reset_asic’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/kv_dpm.c |   21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/gpu/drm/radeon/kv_dpm.c b/drivers/gpu/drm/radeon/kv_dpm.c
index 7e58dfb..8c0cb67 100644
--- a/drivers/gpu/drm/radeon/kv_dpm.c
+++ b/drivers/gpu/drm/radeon/kv_dpm.c
@@ -1867,27 +1867,6 @@ void kv_dpm_setup_asic(struct radeon_device *rdev)
 	kv_init_sclk_t(rdev);
 }
 
-void kv_dpm_reset_asic(struct radeon_device *rdev)
-{
-	struct kv_power_info *pi = kv_get_pi(rdev);
-
-	if (rdev->family == CHIP_KABINI) {
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
1.7.9.5

