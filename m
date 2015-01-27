Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbbA0MuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:50:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34873 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259AbbA0MRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 017/126] drm/radeon: adjust default bapm settings for KV
Date: Tue, 27 Jan 2015 12:15:22 +0000
Message-Id: <1422361031-19364-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 02ae7af53a451a1b0a51022c4693f5b339133e79 upstream.

Enabling bapm seems to cause clocking problems on some
KV configurations.  Disable it by default for now.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/kv_dpm.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/kv_dpm.c b/drivers/gpu/drm/radeon/kv_dpm.c
index e79b7ebf5894..d873f86a3045 100644
--- a/drivers/gpu/drm/radeon/kv_dpm.c
+++ b/drivers/gpu/drm/radeon/kv_dpm.c
@@ -2745,13 +2745,11 @@ int kv_dpm_init(struct radeon_device *rdev)
 	pi->enable_auto_thermal_throttling = true;
 	pi->disable_nb_ps3_in_battery = false;
 	if (radeon_bapm == -1) {
-		/* There are stability issues reported on with
-		 * bapm enabled on an asrock system.
-		 */
-		if (rdev->pdev->subsystem_vendor == 0x1849)
-			pi->bapm_enable = false;
-		else
+		/* only enable bapm on KB, ML by default */
+		if (rdev->family == CHIP_KABINI || rdev->family == CHIP_MULLINS)
 			pi->bapm_enable = true;
+		else
+			pi->bapm_enable = false;
 	} else if (radeon_bapm == 0) {
 		pi->bapm_enable = false;
 	} else {
-- 
2.1.4

