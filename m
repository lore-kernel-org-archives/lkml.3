Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672Ab3AOWwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:52:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:46787 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933651Ab3AOWw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Julien Cristau <jcristau@debian.org>
Subject: [ 124/171] drm/radeon: fix ordering in pll picking on dce4+
Date: Tue, 15 Jan 2013 14:44:49 -0800
Message-Id: <20130115224322.297944113@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ecd67955fd4c8e66e4df312098989d5fa7da624c upstream.

No functional change, but re-order the cases so they
evaluate properly due to the way the DCE macros work.

Noticed by kallisti5 on IRC.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Julien Cristau <jcristau@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/atombios_crtc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1533,12 +1533,12 @@ static int radeon_atom_pick_pll(struct d
 				 * crtc virtual pixel clock.
 				 */
 				if (ENCODER_MODE_IS_DP(atombios_get_encoder_mode(test_encoder))) {
-					if (ASIC_IS_DCE5(rdev))
-						return ATOM_DCPLL;
+					if (rdev->clock.dp_extclk)
+						return ATOM_PPLL_INVALID;
 					else if (ASIC_IS_DCE6(rdev))
 						return ATOM_PPLL0;
-					else if (rdev->clock.dp_extclk)
-						return ATOM_PPLL_INVALID;
+					else if (ASIC_IS_DCE5(rdev))
+						return ATOM_DCPLL;
 				}
 			}
 		}


