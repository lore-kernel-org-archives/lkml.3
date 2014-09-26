Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbaIZJzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:55:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbaIZJqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 135/142] drm/radeon/TN: only enable bapm on MSI systems
Date: Fri, 26 Sep 2014 11:45:46 +0200
Message-Id: <619f5c40406327a31e3a8b330bf82d0dcf1060df.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 730a336c33a3398d65896e8ee3ef9f5679fe30a9 upstream.

There still seem to be stability problems with other systems.

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=72921

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/trinity_dpm.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/radeon/trinity_dpm.c b/drivers/gpu/drm/radeon/trinity_dpm.c
index 37023884d102..bf980ea2b593 100644
--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -1868,15 +1868,16 @@ int trinity_dpm_init(struct radeon_device *rdev)
 	for (i = 0; i < SUMO_MAX_HARDWARE_POWERLEVELS; i++)
 		pi->at[i] = TRINITY_AT_DFLT;
 
-	/* There are stability issues reported on latops with
-	 * bapm installed when switching between AC and battery
-	 * power.  At the same time, some desktop boards hang
-	 * if it's not enabled and dpm is enabled.
+	/* There are stability issues reported on with
+	 * bapm enabled when switching between AC and battery
+	 * power.  At the same time, some MSI boards hang
+	 * if it's not enabled and dpm is enabled.  Just enable
+	 * it for MSI boards right now.
 	 */
-	if (rdev->flags & RADEON_IS_MOBILITY)
-		pi->enable_bapm = false;
-	else
+	if (rdev->pdev->subsystem_vendor == 0x1462)
 		pi->enable_bapm = true;
+	else
+		pi->enable_bapm = false;
 	pi->enable_nbps_policy = true;
 	pi->enable_sclk_ds = true;
 	pi->enable_gfx_power_gating = true;
-- 
2.1.0

