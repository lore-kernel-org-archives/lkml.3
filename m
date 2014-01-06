Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaAFQHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:07:44 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59731 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaAFQHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:07:42 -0500
Date: Mon, 6 Jan 2014 21:37:33 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 53/85] drivers: gpu: Remove unused function in rv770_dpm.c
Message-ID: <64850508d2a00aba25761e99bb3dbe50e207e32a.1389018325.git.rashika.kheria@gmail.com>
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

Remove unused function rv770_dpm_reset_asic() from file
drm/radeon/rv770_dpm.c.

This eliminates the following warning in drm/radeon/rv770_dpm.c:
drivers/gpu/drm/radeon/rv770_dpm.c:2070:6: warning: no previous prototype for ‘rv770_dpm_reset_asic’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/rv770_dpm.c |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/gpu/drm/radeon/rv770_dpm.c b/drivers/gpu/drm/radeon/rv770_dpm.c
index cd22549..9c4cf11 100644
--- a/drivers/gpu/drm/radeon/rv770_dpm.c
+++ b/drivers/gpu/drm/radeon/rv770_dpm.c
@@ -2068,19 +2068,6 @@ int rv770_dpm_set_power_state(struct radeon_device *rdev)
 	return 0;
 }
 
-void rv770_dpm_reset_asic(struct radeon_device *rdev)
-{
-	struct rv7xx_power_info *pi = rv770_get_pi(rdev);
-	struct radeon_ps *boot_ps = rdev->pm.dpm.boot_ps;
-
-	rv770_restrict_performance_levels_before_switch(rdev);
-	if (pi->dcodt)
-		rv770_program_dcodt_before_state_switch(rdev, boot_ps, boot_ps);
-	rv770_set_boot_state(rdev);
-	if (pi->dcodt)
-		rv770_program_dcodt_after_state_switch(rdev, boot_ps, boot_ps);
-}
-
 void rv770_dpm_setup_asic(struct radeon_device *rdev)
 {
 	struct rv7xx_power_info *pi = rv770_get_pi(rdev);
-- 
1.7.9.5

