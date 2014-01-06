Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbaAFQcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:32:03 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:62983 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaAFQb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:31:58 -0500
Date: Mon, 6 Jan 2014 22:01:52 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 68/85] drivers: gpu: Remove unused function in si_dpm.c
Message-ID: <1fdbe2c2d257d5b2585f29008c635c960521cf7b.1389018325.git.rashika.kheria@gmail.com>
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

Remove unused function si_dpm_reset_asic() from drm/radeon/si_dpm.c.

This elimiantes the following warnings in drm/radeon/si_dpm.c:
drivers/gpu/drm/radeon/si_dpm.c:6126:6: warning: no previous prototype for ‘si_dpm_reset_asic’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/si_dpm.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/gpu/drm/radeon/si_dpm.c b/drivers/gpu/drm/radeon/si_dpm.c
index 8ce849e..aec98ff 100644
--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -6115,14 +6115,6 @@ void si_dpm_post_set_power_state(struct radeon_device *rdev)
 	ni_update_current_ps(rdev, new_ps);
 }
 
-
-void si_dpm_reset_asic(struct radeon_device *rdev)
-{
-	si_restrict_performance_levels_before_switch(rdev);
-	si_disable_ulv(rdev);
-	si_set_boot_state(rdev);
-}
-
 void si_dpm_display_configuration_changed(struct radeon_device *rdev)
 {
 	si_program_display_gap(rdev);
-- 
1.7.9.5

