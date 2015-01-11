Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbbAKNxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 08:53:24 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:52997 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbbAKNxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 08:53:21 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm: radeon: btc_dpm: Remove unused function
Date: Sun, 11 Jan 2015 14:56:26 +0100
Message-Id: <1420984586-17554-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function btc_dpm_reset_asic() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/btc_dpm.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/gpu/drm/radeon/btc_dpm.c b/drivers/gpu/drm/radeon/btc_dpm.c
index 0b2929d..fea7130 100644
--- a/drivers/gpu/drm/radeon/btc_dpm.c
+++ b/drivers/gpu/drm/radeon/btc_dpm.c
@@ -2277,14 +2277,6 @@ static void btc_update_requested_ps(struct radeon_device *rdev,
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
1.7.10.4

