Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbaAFQWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:22:01 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39135 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbaAFQV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:21:59 -0500
Date: Mon, 6 Jan 2014 21:51:54 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 62/85] drivers: gpu: Mark functions as static and remove
 unused function in trinity_dpm.c
Message-ID: <25591711af682e7c6814b1ce9df76009f0fb5f8f.1389018325.git.rashika.kheria@gmail.com>
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

Mark function trinity_get_ps() and trinity_get_pi() as static because
they are not used outside this file and remove unused function
trinity_dpm_reset_asic() from file drm/radeon/trinity_dpm.c.

Also remove prototype declarations of functions trinity_get_ps() and
trinity_get_pi() from drm/radeon/trinity_smc.c because they are not used
in this file.

This eliminates the following warnings in drm/radeon/trinity_dpm.c:
drivers/gpu/drm/radeon/trinity_dpm.c:345:20: warning: no previous prototype for ‘trinity_get_ps’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:352:28: warning: no previous prototype for ‘trinity_get_pi’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/trinity_dpm.c:1262:6: warning: no previous prototype for ‘trinity_dpm_reset_asic’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/trinity_dpm.c |   20 ++------------------
 drivers/gpu/drm/radeon/trinity_smc.c |    3 ---
 2 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/radeon/trinity_dpm.c b/drivers/gpu/drm/radeon/trinity_dpm.c
index d700698..83778b6 100644
--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -342,14 +342,14 @@ static void trinity_apply_state_adjust_rules(struct radeon_device *rdev,
 					     struct radeon_ps *new_rps,
 					     struct radeon_ps *old_rps);
 
-struct trinity_ps *trinity_get_ps(struct radeon_ps *rps)
+static struct trinity_ps *trinity_get_ps(struct radeon_ps *rps)
 {
 	struct trinity_ps *ps = rps->ps_priv;
 
 	return ps;
 }
 
-struct trinity_power_info *trinity_get_pi(struct radeon_device *rdev)
+static struct trinity_power_info *trinity_get_pi(struct radeon_device *rdev)
 {
 	struct trinity_power_info *pi = rdev->pm.dpm.priv;
 
@@ -1259,22 +1259,6 @@ void trinity_dpm_setup_asic(struct radeon_device *rdev)
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
diff --git a/drivers/gpu/drm/radeon/trinity_smc.c b/drivers/gpu/drm/radeon/trinity_smc.c
index 9672bcb..99dd045 100644
--- a/drivers/gpu/drm/radeon/trinity_smc.c
+++ b/drivers/gpu/drm/radeon/trinity_smc.c
@@ -27,9 +27,6 @@
 #include "trinity_dpm.h"
 #include "ppsmc.h"
 
-struct trinity_ps *trinity_get_ps(struct radeon_ps *rps);
-struct trinity_power_info *trinity_get_pi(struct radeon_device *rdev);
-
 static int trinity_notify_message_to_smu(struct radeon_device *rdev, u32 id)
 {
 	int i;
-- 
1.7.9.5

