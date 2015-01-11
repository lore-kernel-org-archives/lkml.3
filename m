Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbbAKQr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 11:47:26 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:43454 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbbAKQrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 11:47:25 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm: radeon: si_dpm: Remove unused function
Date: Sun, 11 Jan 2015 17:50:30 +0100
Message-Id: <1420995030-21195-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function si_dpm_reset_asic() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/si_dpm.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/gpu/drm/radeon/si_dpm.c b/drivers/gpu/drm/radeon/si_dpm.c
index 676e6c2..5e2fb9a 100644
--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -6154,13 +6154,6 @@ void si_dpm_post_set_power_state(struct radeon_device *rdev)
 }
 
 
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
1.7.10.4

