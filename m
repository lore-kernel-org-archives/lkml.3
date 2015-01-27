Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbbA0Mum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:50:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34859 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221AbbA0MRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 014/126] drm/radeon: KV has three PPLLs (v2)
Date: Tue, 27 Jan 2015 12:15:19 +0000
Message-Id: <1422361031-19364-15-git-send-email-luis.henriques@canonical.com>
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

commit fbedf1c3fc3a1e9f249c2efe2f4553d8df9d86d3 upstream.

Enable all three in the driver.  Early documentation
indicated the 3rd one was used for something else, but
that is not the case.

v2: handle disable as well

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_crtc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index 30d242b25078..dce0d3918fa7 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1851,10 +1851,9 @@ static int radeon_atom_pick_pll(struct drm_crtc *crtc)
 				return pll;
 		}
 		/* otherwise, pick one of the plls */
-		if ((rdev->family == CHIP_KAVERI) ||
-		    (rdev->family == CHIP_KABINI) ||
+		if ((rdev->family == CHIP_KABINI) ||
 		    (rdev->family == CHIP_MULLINS)) {
-			/* KB/KV/ML has PPLL1 and PPLL2 */
+			/* KB/ML has PPLL1 and PPLL2 */
 			pll_in_use = radeon_get_pll_use_mask(crtc);
 			if (!(pll_in_use & (1 << ATOM_PPLL2)))
 				return ATOM_PPLL2;
@@ -1863,7 +1862,7 @@ static int radeon_atom_pick_pll(struct drm_crtc *crtc)
 			DRM_ERROR("unable to allocate a PPLL\n");
 			return ATOM_PPLL_INVALID;
 		} else {
-			/* CI has PPLL0, PPLL1, and PPLL2 */
+			/* CI/KV has PPLL0, PPLL1, and PPLL2 */
 			pll_in_use = radeon_get_pll_use_mask(crtc);
 			if (!(pll_in_use & (1 << ATOM_PPLL2)))
 				return ATOM_PPLL2;
@@ -2154,6 +2153,7 @@ static void atombios_crtc_disable(struct drm_crtc *crtc)
 	case ATOM_PPLL0:
 		/* disable the ppll */
 		if ((rdev->family == CHIP_ARUBA) ||
+		    (rdev->family == CHIP_KAVERI) ||
 		    (rdev->family == CHIP_BONAIRE) ||
 		    (rdev->family == CHIP_HAWAII))
 			atombios_crtc_program_pll(crtc, radeon_crtc->crtc_id, radeon_crtc->pll_id,
-- 
2.1.4

