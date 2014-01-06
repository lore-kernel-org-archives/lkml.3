Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbaAFQgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:36:53 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37037 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaAFQgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:36:52 -0500
Date: Mon, 6 Jan 2014 22:06:47 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 72/85] drivers: gpu: Mark functions as static and remove
 unused function in ci_dpm.c
Message-ID: <6b252b31394cd67ec2ebb4531ee58416522c2269.1389018325.git.rashika.kheria@gmail.com>
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

Mark functions as static because they are not used outside this file
and remove unused function ci_dpm_power_control_set_level() and
ci_dpm_reset_asic() from file drm/radeon/ci_dpm.c.

This eliminates the following warnings in drm/radeon/ci_dpm.c:
drivers/gpu/drm/radeon/ci_dpm.c:4506:6: warning: no previous prototype for ‘ci_update_current_ps’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ci_dpm.c:4517:6: warning: no previous prototype for ‘ci_update_requested_ps’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ci_dpm.c:4817:5: warning: no previous prototype for ‘ci_dpm_power_control_set_level’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ci_dpm.c:4822:6: warning: no previous prototype for ‘ci_dpm_reset_asic’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/ci_dpm.c:5026:5: warning: no previous prototype for ‘ci_get_vbios_boot_values’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/ci_dpm.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index 7b3c412..23d26f2 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -4496,7 +4496,7 @@ static void ci_get_memory_type(struct radeon_device *rdev)
 
 }
 
-void ci_update_current_ps(struct radeon_device *rdev,
+static void ci_update_current_ps(struct radeon_device *rdev,
 			  struct radeon_ps *rps)
 {
 	struct ci_ps *new_ps = ci_get_ps(rps);
@@ -4507,7 +4507,7 @@ void ci_update_current_ps(struct radeon_device *rdev,
 	pi->current_rps.ps_priv = &pi->current_ps;
 }
 
-void ci_update_requested_ps(struct radeon_device *rdev,
+static void ci_update_requested_ps(struct radeon_device *rdev,
 			    struct radeon_ps *rps)
 {
 	struct ci_ps *new_ps = ci_get_ps(rps);
@@ -4807,16 +4807,6 @@ int ci_dpm_set_power_state(struct radeon_device *rdev)
 	return 0;
 }
 
-int ci_dpm_power_control_set_level(struct radeon_device *rdev)
-{
-	return ci_power_control_set_level(rdev);
-}
-
-void ci_dpm_reset_asic(struct radeon_device *rdev)
-{
-	ci_set_boot_state(rdev);
-}
-
 void ci_dpm_display_configuration_changed(struct radeon_device *rdev)
 {
 	ci_program_display_gap(rdev);
@@ -5016,7 +5006,7 @@ static int ci_parse_power_table(struct radeon_device *rdev)
 	return 0;
 }
 
-int ci_get_vbios_boot_values(struct radeon_device *rdev,
+static int ci_get_vbios_boot_values(struct radeon_device *rdev,
 			     struct ci_vbios_boot_state *boot_state)
 {
 	struct radeon_mode_info *mode_info = &rdev->mode_info;
-- 
1.7.9.5

