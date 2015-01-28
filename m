Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964999AbbA2CgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:36:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46946 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964969AbbA2Cf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:56 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 034/139] drm/radeon: fix typo in CI dpm disable
Date: Wed, 28 Jan 2015 14:19:37 -0800
Message-Id: <1422483682-15393-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 129acb7c0b682512e89c4f65c33593d50f2f49a9 upstream.

Need to disable DS, not enable it when disabling dpm.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/ci_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index 9c769f7..7db3876 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -4741,7 +4741,7 @@ void ci_dpm_disable(struct radeon_device *rdev)
 	ci_enable_spread_spectrum(rdev, false);
 	ci_enable_auto_throttle_source(rdev, RADEON_DPM_AUTO_THROTTLE_SRC_THERMAL, false);
 	ci_stop_dpm(rdev);
-	ci_enable_ds_master_switch(rdev, true);
+	ci_enable_ds_master_switch(rdev, false);
 	ci_enable_ulv(rdev, false);
 	ci_clear_vc(rdev);
 	ci_reset_to_default(rdev);
-- 
1.9.1

