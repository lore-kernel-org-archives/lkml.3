Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaGHTNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:13:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54278 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755777AbaGHTIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:43 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.21294403@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 056/125] drm/radeon: only apply hdmi bpc pll flags
 when encoder mode is hdmi
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7d5ab3009a8ca777174f6f469277b3922d56fd4b upstream.

May fix display issues with non-HDMI displays.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/atombios_crtc.c | 48 ++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -830,14 +830,16 @@ static void atombios_crtc_program_pll(st
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
@@ -852,20 +854,22 @@ static void atombios_crtc_program_pll(st
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

