Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab3LFOWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:22:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43592 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976Ab3LFM7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:59:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 017/272] drm/radeon: adjust TN dpm parameters for stability (v2)
Date: Fri,  6 Dec 2013 12:55:06 +0000
Message-Id: <1386334761-25517-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 958b84fb3bef193198538b5c5902fa687cc8363f upstream.

Adjust some of the TN dpm settings for stability.  Enabling
these features causes hangs and other stability problems
on certain boards.

v2: leave uvd dpm enabled

Bug:
https://bugzilla.kernel.org/show_bug.cgi?id=63101

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/trinity_dpm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/trinity_dpm.c b/drivers/gpu/drm/radeon/trinity_dpm.c
index 28f4380..ec99d86 100644
--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -1857,9 +1857,9 @@ int trinity_dpm_init(struct radeon_device *rdev)
 	pi->enable_sclk_ds = true;
 	pi->enable_gfx_power_gating = true;
 	pi->enable_gfx_clock_gating = true;
-	pi->enable_mg_clock_gating = true;
-	pi->enable_gfx_dynamic_mgpg = true; /* ??? */
-	pi->override_dynamic_mgpg = true;
+	pi->enable_mg_clock_gating = false;
+	pi->enable_gfx_dynamic_mgpg = false;
+	pi->override_dynamic_mgpg = false;
 	pi->enable_auto_thermal_throttling = true;
 	pi->voltage_drop_in_dce = false; /* need to restructure dpm/modeset interaction */
 	pi->uvd_dpm = true; /* ??? */
-- 
1.8.3.2

