Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965212Ab3GCTGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:06:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33255 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965008Ab3GCTA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:29 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=IIKEg64ng5wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=GxtWwKIUbDQA:10 a=zd2uoN0lAAAA:8 a=VwQbUJbxAAAA:8 a=WKrTr6Ylr8kd5KpFOEwA:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184100.876804138@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [093/141] drm/radeon: dont allow audio on DCE6
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0093-drm-radeon-don-t-allow-audio-on-DCE6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 1cbcca302a318499f20a512847c5d6a510c08c35 ]

It's not supported yet.  Fixes display issues when
users force it on.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/atombios_encoders.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 2eb418e..f14ce9a 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -396,6 +396,8 @@ atombios_digital_setup(struct drm_encoder *encoder, int action)
 int
 atombios_get_encoder_mode(struct drm_encoder *encoder)
 {
+	struct drm_device *dev = encoder->dev;
+	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
 	struct drm_connector *connector;
 	struct radeon_connector *radeon_connector;
@@ -421,7 +423,8 @@ atombios_get_encoder_mode(struct drm_encoder *encoder)
 	case DRM_MODE_CONNECTOR_DVII:
 	case DRM_MODE_CONNECTOR_HDMIB: /* HDMI-B is basically DL-DVI; analog works fine */
 		if (drm_detect_hdmi_monitor(radeon_connector->edid) &&
-		    radeon_audio)
+		    radeon_audio &&
+		    !ASIC_IS_DCE6(rdev)) /* remove once we support DCE6 */
 			return ATOM_ENCODER_MODE_HDMI;
 		else if (radeon_connector->use_digital)
 			return ATOM_ENCODER_MODE_DVI;
@@ -432,7 +435,8 @@ atombios_get_encoder_mode(struct drm_encoder *encoder)
 	case DRM_MODE_CONNECTOR_HDMIA:
 	default:
 		if (drm_detect_hdmi_monitor(radeon_connector->edid) &&
-		    radeon_audio)
+		    radeon_audio &&
+		    !ASIC_IS_DCE6(rdev)) /* remove once we support DCE6 */
 			return ATOM_ENCODER_MODE_HDMI;
 		else
 			return ATOM_ENCODER_MODE_DVI;
@@ -446,7 +450,8 @@ atombios_get_encoder_mode(struct drm_encoder *encoder)
 		    (dig_connector->dp_sink_type == CONNECTOR_OBJECT_ID_eDP))
 			return ATOM_ENCODER_MODE_DP;
 		else if (drm_detect_hdmi_monitor(radeon_connector->edid) &&
-			 radeon_audio)
+			 radeon_audio &&
+			 !ASIC_IS_DCE6(rdev)) /* remove once we support DCE6 */
 			return ATOM_ENCODER_MODE_HDMI;
 		else
 			return ATOM_ENCODER_MODE_DVI;
-- 
1.7.10.4


