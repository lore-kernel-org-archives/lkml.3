Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761815AbaGRNMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:12:34 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17637 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934795AbaGRNM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:12:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 079/170] drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi
Date: Fri, 18 Jul 2014 14:11:24 +0200
Message-Id: <7bd2e093da845f9b507c0471d9beff0f8fd95320.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7d5ab3009a8ca777174f6f469277b3922d56fd4b upstream.

May fix display issues with non-HDMI displays.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/atombios_crtc.c | 48 ++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index dcb652a6f924..ba8742ab85ee 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -859,14 +859,16 @@ static void atombios_crtc_program_pll(struct drm_crtc *crtc,
 			args.v5.ucMiscInfo = 0; /* HDMI depth, etc. */
 			if (ss_enabled && (ss->type & ATOM_EXTERNAL_SS_MASK))
 				args.v5.ucMiscInfo |= PIXEL_CLOCK_V5_MISC_REF_DIV_SRC;
-			switch (bpc) {
-			case 8:
-			default:
-				args.v5.ucMiscInfo |= PIXEL_CLOCK_V5_MISC_HDMI_24BPP;
-				break;
-			case 10:
-				args.v5.ucMiscInfo |= PIXEL_CLOCK_V5_MISC_HDMI_30BPP;
-				break;
+			if (encoder_mode == ATOM_ENCODER_MODE_HDMI) {
+				switch (bpc) {
+				case 8:
+				default:
+					args.v5.ucMiscInfo |= PIXEL_CLOCK_V5_MISC_HDMI_24BPP;
+					break;
+				case 10:
+					args.v5.ucMiscInfo |= PIXEL_CLOCK_V5_MISC_HDMI_30BPP;
+					break;
+				}
 			}
 			args.v5.ucTransmitterID = encoder_id;
 			args.v5.ucEncoderMode = encoder_mode;
@@ -881,20 +883,22 @@ static void atombios_crtc_program_pll(struct drm_crtc *crtc,
 			args.v6.ucMiscInfo = 0; /* HDMI depth, etc. */
 			if (ss_enabled && (ss->type & ATOM_EXTERNAL_SS_MASK))
 				args.v6.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_REF_DIV_SRC;
-			switch (bpc) {
-			case 8:
-			default:
-				args.v6.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_HDMI_24BPP;
-				break;
-			case 10:
-				args.v6.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_HDMI_30BPP;
-				break;
-			case 12:
-				args.v6.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_HDMI_36BPP;
-				break;
-			case 16:
-				args.v6.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_HDMI_48BPP;
-				break;
+			if (encoder_mode == ATOM_ENCODER_MODE_HDMI) {
+				switch (bpc) {
+				case 8:
+				default:
+					args.v6.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_HDMI_24BPP;
+					break;
+				case 10:
+					args.v6.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_HDMI_30BPP;
+					break;
+				case 12:
+					args.v6.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_HDMI_36BPP;
+					break;
+				case 16:
+					args.v6.ucMiscInfo |= PIXEL_CLOCK_V6_MISC_HDMI_48BPP;
+					break;
+				}
 			}
 			args.v6.ucTransmitterID = encoder_id;
 			args.v6.ucEncoderMode = encoder_mode;
-- 
2.0.0

