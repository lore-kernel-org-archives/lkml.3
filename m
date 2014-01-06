Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaAFQQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:16:34 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:46950 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbaAFQQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:16:33 -0500
Date: Mon, 6 Jan 2014 21:46:28 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Jerome Glisse <jglisse@redhat.com>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 59/85] drivers: gpu: Mark function as static and remove
 unused function in sumo_dpm.c
Message-ID: <45db79d2e129f11a510755d06b29c419e7b4fde8.1389018325.git.rashika.kheria@gmail.com>
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

Mark function sumo_get_ps() as static and remove unused function
sumo_dpm_reset_asic() from file drm/radeon/sumo_dpm.c.

This eliminates the following warnings in drm/radeon/sumo_dpm.c:
drivers/gpu/drm/radeon/sumo_dpm.c:74:17: warning: no previous prototype for ‘sumo_get_ps’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/sumo_dpm.c:1333:6: warning: no previous prototype for ‘sumo_dpm_reset_asic’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/sumo_dpm.c |   14 +-------------
 drivers/gpu/drm/radeon/sumo_smc.c |    1 -
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/radeon/sumo_dpm.c b/drivers/gpu/drm/radeon/sumo_dpm.c
index 96ea6db8..eb2e8e6 100644
--- a/drivers/gpu/drm/radeon/sumo_dpm.c
+++ b/drivers/gpu/drm/radeon/sumo_dpm.c
@@ -71,7 +71,7 @@ static const u32 sumo_dtc[SUMO_PM_NUMBER_OF_TC] =
 	SUMO_DTC_DFLT_14,
 };
 
-struct sumo_ps *sumo_get_ps(struct radeon_ps *rps)
+static struct sumo_ps *sumo_get_ps(struct radeon_ps *rps)
 {
 	struct sumo_ps *ps = rps->ps_priv;
 
@@ -1330,18 +1330,6 @@ void sumo_dpm_post_set_power_state(struct radeon_device *rdev)
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
diff --git a/drivers/gpu/drm/radeon/sumo_smc.c b/drivers/gpu/drm/radeon/sumo_smc.c
index 18abba5..fb081d2 100644
--- a/drivers/gpu/drm/radeon/sumo_smc.c
+++ b/drivers/gpu/drm/radeon/sumo_smc.c
@@ -31,7 +31,6 @@
 #define SUMO_SMU_SERVICE_ROUTINE_ALTVDDNB_NOTIFY  27
 #define SUMO_SMU_SERVICE_ROUTINE_GFX_SRV_ID_20  20
 
-struct sumo_ps *sumo_get_ps(struct radeon_ps *rps);
 struct sumo_power_info *sumo_get_pi(struct radeon_device *rdev);
 
 static void sumo_send_msg_to_smu(struct radeon_device *rdev, u32 id)
-- 
1.7.9.5

