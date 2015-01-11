Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbbAKQAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 11:00:54 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47133 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbbAKQAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 11:00:51 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm: radeon: cypress_dpm: Remove unused function
Date: Sun, 11 Jan 2015 17:03:56 +0100
Message-Id: <1420992236-20647-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function cypress_dpm_reset_asic() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/radeon/cypress_dpm.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cypress_dpm.c b/drivers/gpu/drm/radeon/cypress_dpm.c
index 9aad032..d3f8208 100644
--- a/drivers/gpu/drm/radeon/cypress_dpm.c
+++ b/drivers/gpu/drm/radeon/cypress_dpm.c
@@ -2005,12 +2005,6 @@ int cypress_dpm_set_power_state(struct radeon_device *rdev)
 	return 0;
 }
 
-void cypress_dpm_reset_asic(struct radeon_device *rdev)
-{
-	rv770_restrict_performance_levels_before_switch(rdev);
-	rv770_set_boot_state(rdev);
-}
-
 void cypress_dpm_display_configuration_changed(struct radeon_device *rdev)
 {
 	cypress_program_display_gap(rdev);
-- 
1.7.10.4

