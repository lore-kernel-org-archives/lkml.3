Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbaBGLvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:51:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42124 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbaBGLvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 149/233] drm/radeon: disable ss on DP for DCE3.x
Date: Fri,  7 Feb 2014 11:46:08 +0000
Message-Id: <1391773652-25214-150-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d8e24525094200601236fa64a54cf73e3d682f2e upstream.

Seems to cause problems with certain DP monitors.

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=40699

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_crtc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index 8b92676..ed8bc9d 100644
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

