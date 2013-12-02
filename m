Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab3LBTtC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:49:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab3LBTSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 139/212] drm/radeon: adjust TN dpm parameters for stability (v2)
Date: Mon,  2 Dec 2013 11:15:30 -0800
Message-Id: <20131202191302.587322685@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/trinity_dpm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -1873,9 +1873,9 @@ int trinity_dpm_init(struct radeon_devic
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


