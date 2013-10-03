Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab3JCEVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:21:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab3JCEVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:21:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 51/57] drm/radeon: dont set default clocks for SI when DPM is disabled
Date: Wed,  2 Oct 2013 21:09:17 -0700
Message-Id: <20131003040640.084589996@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 360991867d83e10827d907ef67206986a98953b3 upstream.

This is a partial revert of c6cf7777a32da874fabec4fd1c2a579f0ba4e4dd.

We need to take into account the clk voltage dependencies of the
board.  Not doing so can lead to stability issues on certain
boards if the clks exceed the levels in the dep tables.

DPM already takes that into account, so for optimal performance,
use DPM.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_pm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -919,7 +919,7 @@ static void radeon_pm_resume_old(struct
 {
 	/* set up the default clocks if the MC ucode is loaded */
 	if ((rdev->family >= CHIP_BARTS) &&
-	    (rdev->family <= CHIP_HAINAN) &&
+	    (rdev->family <= CHIP_CAYMAN) &&
 	    rdev->mc_fw) {
 		if (rdev->pm.default_vddc)
 			radeon_atom_set_voltage(rdev, rdev->pm.default_vddc,
@@ -963,7 +963,7 @@ static void radeon_pm_resume_dpm(struct
 	if (ret) {
 		DRM_ERROR("radeon: dpm resume failed\n");
 		if ((rdev->family >= CHIP_BARTS) &&
-		    (rdev->family <= CHIP_HAINAN) &&
+		    (rdev->family <= CHIP_CAYMAN) &&
 		    rdev->mc_fw) {
 			if (rdev->pm.default_vddc)
 				radeon_atom_set_voltage(rdev, rdev->pm.default_vddc,
@@ -1014,7 +1014,7 @@ static int radeon_pm_init_old(struct rad
 		radeon_pm_init_profile(rdev);
 		/* set up the default clocks if the MC ucode is loaded */
 		if ((rdev->family >= CHIP_BARTS) &&
-		    (rdev->family <= CHIP_HAINAN) &&
+		    (rdev->family <= CHIP_CAYMAN) &&
 		    rdev->mc_fw) {
 			if (rdev->pm.default_vddc)
 				radeon_atom_set_voltage(rdev, rdev->pm.default_vddc,
@@ -1099,7 +1099,7 @@ static int radeon_pm_init_dpm(struct rad
 	if (ret) {
 		rdev->pm.dpm_enabled = false;
 		if ((rdev->family >= CHIP_BARTS) &&
-		    (rdev->family <= CHIP_HAINAN) &&
+		    (rdev->family <= CHIP_CAYMAN) &&
 		    rdev->mc_fw) {
 			if (rdev->pm.default_vddc)
 				radeon_atom_set_voltage(rdev, rdev->pm.default_vddc,


