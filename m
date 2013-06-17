Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3FQRwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:52:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50600 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab3FQRf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:35:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 45/84] drm/radeon: don't allow audio on DCE6
Date: Mon, 17 Jun 2013 10:30:49 -0700
Message-Id: <1371490288-23167-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 1cbcca302a318499f20a512847c5d6a510c08c35 upstream.

It's not supported yet.  Fixes display issues when
users force it on.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_encoders.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 4552d4a..6cf2b52 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -667,6 +667,8 @@ atombios_digital_setup(struct drm_encoder *encoder, int action)
 int
 atombios_get_encoder_mode(struct drm_encoder *encoder)
 {
+	struct drm_device *dev = encoder->dev;
+	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
 	struct drm_connector *connector;
 	struct radeon_connector *radeon_connector;
@@ -693,7 +695,8 @@ atombios_get_encoder_mode(struct drm_encoder *encoder)
 	case DRM_MODE_CONNECTOR_DVII:
 	case DRM_MODE_CONNECTOR_HDMIB: /* HDMI-B is basically DL-DVI; analog works fine */
 		if (drm_detect_hdmi_monitor(radeon_connector->edid) &&
-		    radeon_audio)
+		    radeon_audio &&
+		    !ASIC_IS_DCE6(rdev)) /* remove once we support DCE6 */
 			return ATOM_ENCODER_MODE_HDMI;
 		else if (radeon_connector->use_digital)
 			return ATOM_ENCODER_MODE_DVI;
@@ -704,7 +707,8 @@ atombios_get_encoder_mode(struct drm_encoder *encoder)
 	case DRM_MODE_CONNECTOR_HDMIA:
 	default:
 		if (drm_detect_hdmi_monitor(radeon_connector->edid) &&
-		    radeon_audio)
+		    radeon_audio &&
+		    !ASIC_IS_DCE6(rdev)) /* remove once we support DCE6 */
 			return ATOM_ENCODER_MODE_HDMI;
 		else
 			return ATOM_ENCODER_MODE_DVI;
@@ -718,7 +722,8 @@ atombios_get_encoder_mode(struct drm_encoder *encoder)
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
1.8.1.2

