Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363AbaGVW0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:26:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44779 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbaGVW0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:26:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 051/116] drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi
Date: Tue, 22 Jul 2014 15:21:02 -0700
Message-Id: <1406067727-19683-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7d5ab3009a8ca777174f6f469277b3922d56fd4b upstream.

May fix display issues with non-HDMI displays.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_crtc.c | 48 ++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index b9ff6e2..bbcc441 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -839,14 +839,16 @@ static void atombios_crtc_program_pll(struct drm_crtc *crtc,
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
@@ -861,20 +863,22 @@ static void atombios_crtc_program_pll(struct drm_crtc *crtc,
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
1.9.1

