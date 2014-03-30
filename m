Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaC3Xms (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:42:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754347AbaC3Xmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:46 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.201880747@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 046/200] drm/radeon: disable ss on DP for DCE3.x
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d8e24525094200601236fa64a54cf73e3d682f2e upstream.

Seems to cause problems with certain DP monitors.

Bug:
https://bugs.freedesktop.org/show_bug.cgi?id=40699

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: s/radeon_crtc->//]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/atombios_crtc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -956,10 +956,13 @@ static void atombios_crtc_set_pll(struct
 						ss_enabled =
 							radeon_atombios_get_ppll_ss_info(rdev, &ss,
 											 ATOM_DP_SS_ID1);
-				} else
+				} else {
 					ss_enabled =
 						radeon_atombios_get_ppll_ss_info(rdev, &ss,
 										 ATOM_DP_SS_ID1);
+				}
+				/* disable spread spectrum on DCE3 DP */
+				ss_enabled = false;
 			}
 			break;
 		case ATOM_ENCODER_MODE_LVDS:

