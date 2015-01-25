Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbbAYS7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:59:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbbAYSJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.18 036/183] drm/radeon: KV has three PPLLs (v2)
Date: Sun, 25 Jan 2015 10:05:58 -0800
Message-Id: <20150125180811.756054595@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit fbedf1c3fc3a1e9f249c2efe2f4553d8df9d86d3 upstream.

Enable all three in the driver.  Early documentation
indicated the 3rd one was used for something else, but
that is not the case.

v2: handle disable as well

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1851,10 +1851,9 @@ static int radeon_atom_pick_pll(struct d
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
@@ -1863,7 +1862,7 @@ static int radeon_atom_pick_pll(struct d
 			DRM_ERROR("unable to allocate a PPLL\n");
 			return ATOM_PPLL_INVALID;
 		} else {
-			/* CI has PPLL0, PPLL1, and PPLL2 */
+			/* CI/KV has PPLL0, PPLL1, and PPLL2 */
 			pll_in_use = radeon_get_pll_use_mask(crtc);
 			if (!(pll_in_use & (1 << ATOM_PPLL2)))
 				return ATOM_PPLL2;
@@ -2154,6 +2153,7 @@ static void atombios_crtc_disable(struct
 	case ATOM_PPLL0:
 		/* disable the ppll */
 		if ((rdev->family == CHIP_ARUBA) ||
+		    (rdev->family == CHIP_KAVERI) ||
 		    (rdev->family == CHIP_BONAIRE) ||
 		    (rdev->family == CHIP_HAWAII))
 			atombios_crtc_program_pll(crtc, radeon_crtc->crtc_id, radeon_crtc->pll_id,


