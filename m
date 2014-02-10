Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaBJTqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:46:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34929 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaBJTqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 075/124] drm/radeon: disable ss on DP for DCE3.x
Date: Mon, 10 Feb 2014 11:40:15 -0800
Message-Id: <1392061264-28124-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d8e24525094200601236fa64a54cf73e3d682f2e upstream.

Seems to cause problems with certain DP monitors.

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=40699

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_crtc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index ef32bf6..b997e79 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -938,11 +938,14 @@ static bool atombios_crtc_prepare_pll(struct drm_crtc *crtc, struct drm_display_
 							radeon_atombios_get_ppll_ss_info(rdev,
 											 &radeon_crtc->ss,
 											 ATOM_DP_SS_ID1);
-				} else
+				} else {
 					radeon_crtc->ss_enabled =
 						radeon_atombios_get_ppll_ss_info(rdev,
 										 &radeon_crtc->ss,
 										 ATOM_DP_SS_ID1);
+				}
+				/* disable spread spectrum on DCE3 DP */
+				radeon_crtc->ss_enabled = false;
 			}
 			break;
 		case ATOM_ENCODER_MODE_LVDS:
-- 
1.8.3.2

