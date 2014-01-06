Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaAFQOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:14:42 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62305 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbaAFQOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:14:40 -0500
Date: Mon, 6 Jan 2014 21:44:36 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 58/85] drivers: gpu: Remove unused function in btc_dpm.c
Message-ID: <087627435870da9bce0188eaa29b1d25130dd5cb.1389018325.git.rashika.kheria@gmail.com>
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

Remove unused function btc_dpm_reset_asic()
from drm/radeon/btc_dpm.c.

This eliminates the following warnings in drm/radeon/btc_dpm.c:
drivers/gpu/drm/radeon/btc_dpm.c:2311:6: warning: no previous prototype for ‘btc_dpm_reset_asic’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/btc_dpm.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/gpu/drm/radeon/btc_dpm.c b/drivers/gpu/drm/radeon/btc_dpm.c
index 9b309ab9..7afd781 100644
--- a/drivers/gpu/drm/radeon/btc_dpm.c
+++ b/drivers/gpu/drm/radeon/btc_dpm.c
@@ -2305,14 +2305,6 @@ static void btc_update_requested_ps(struct radeon_device *rdev,
 	eg_pi->requested_rps.ps_priv = &eg_pi->requested_ps;
 }
 
-void btc_dpm_reset_asic(struct radeon_device *rdev)
-{
-	rv770_restrict_performance_levels_before_switch(rdev);
-	btc_disable_ulv(rdev);
-	btc_set_boot_state_timing(rdev);
-	rv770_set_boot_state(rdev);
-}
-
 int btc_dpm_pre_set_power_state(struct radeon_device *rdev)
 {
 	struct evergreen_power_info *eg_pi = evergreen_get_pi(rdev);
-- 
1.7.9.5

