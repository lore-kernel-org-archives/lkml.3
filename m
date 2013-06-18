Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab3FRMBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:01:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56071 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab3FRLoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 41/93] drm/radeon: don't allow audio on DCE6
Date: Tue, 18 Jun 2013 12:42:49 +0100
Message-Id: <1371555821-12820-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 1cbcca302a318499f20a512847c5d6a510c08c35 upstream.

It's not supported yet.  Fixes display issues when
users force it on.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_encoders.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 74cc710..66ecc38 100644
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
1.8.1.2

