Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbbASNTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 08:19:04 -0500
Received: from www.osadl.org ([62.245.132.105]:44971 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbbASNTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:19:01 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian Koenig <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] drm/radeon: remove unreachable code
Date: Mon, 19 Jan 2015 14:10:40 +0100
Message-Id: <1421673040-12305-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

As the if (CISLAND_MINIMUM_ENGINE_CLOCK != CISLAND_MINIMUM_ENGINE_CLOCK) is never
satisfied - the entire else branch is never going to be executed and could be 
removed - provided this is not simply a bug and needs to be fixed...

Patch is against 3.19.0-rc5 -next-20150119

Patch was only compile tested with x86_64_defconfig + CONFIG_DRM=m,
CONFIG_DRM_RADEON=m

 drivers/gpu/drm/radeon/ci_dpm.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index f373a81..28db529 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -3805,13 +3805,8 @@ static void ci_find_dpm_states_clocks_in_dpm_table(struct radeon_device *rdev,
 			break;
 	}
 
-	if (i >= sclk_table->count) {
+	if (i >= sclk_table->count)
 		pi->need_update_smu7_dpm_table |= DPMTABLE_OD_UPDATE_SCLK;
-	} else {
-		/* XXX check display min clock requirements */
-		if (CISLAND_MINIMUM_ENGINE_CLOCK != CISLAND_MINIMUM_ENGINE_CLOCK)
-			pi->need_update_smu7_dpm_table |= DPMTABLE_UPDATE_SCLK;
-	}
 
 	for (i = 0; i < mclk_table->count; i++) {
 		if (mclk == mclk_table->dpm_levels[i].value)
-- 
1.7.10.4

