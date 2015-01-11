Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbbAKPVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 10:21:43 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49043 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbbAKPVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 10:21:42 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm: radeon: ci_dpm: Remove some unused functions
Date: Sun, 11 Jan 2015 16:24:47 +0100
Message-Id: <1420989887-19291-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
ci_dpm_reset_asic() ci_dpm_power_control_set_level()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/ci_dpm.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index 11a55e9..06060a5 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -4804,16 +4804,6 @@ int ci_dpm_set_power_state(struct radeon_device *rdev)
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
-- 
1.7.10.4

