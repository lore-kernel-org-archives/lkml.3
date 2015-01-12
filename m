Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbbALTMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:12:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57414 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbbALSFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 028/216] drm/radeon: fix typo in CI dpm disable
Date: Mon, 12 Jan 2015 18:02:25 +0000
Message-Id: <1421085933-32536-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 129acb7c0b682512e89c4f65c33593d50f2f49a9 upstream.

Need to disable DS, not enable it when disabling dpm.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/ci_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index d416bb2ff48d..c224eaef272e 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -4754,7 +4754,7 @@ void ci_dpm_disable(struct radeon_device *rdev)
 	ci_enable_spread_spectrum(rdev, false);
 	ci_enable_auto_throttle_source(rdev, RADEON_DPM_AUTO_THROTTLE_SRC_THERMAL, false);
 	ci_stop_dpm(rdev);
-	ci_enable_ds_master_switch(rdev, true);
+	ci_enable_ds_master_switch(rdev, false);
 	ci_enable_ulv(rdev, false);
 	ci_clear_vc(rdev);
 	ci_reset_to_default(rdev);
-- 
2.1.4

