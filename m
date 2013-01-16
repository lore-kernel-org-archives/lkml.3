Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab3APQDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:03:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36064 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030Ab3APQC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:02:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 087/222] drm/radeon: fix eDP clk and lane setup for scaled modes
Date: Wed, 16 Jan 2013 13:54:47 -0200
Message-Id: <1358351822-7675-88-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 93927f9c1db5f55085457e820f0631064c7bfa34 upstream.

Need to use the adjusted mode since we are sending native
timing and using the scaler for non-native modes.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_encoders.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index dd3c995..74cc710 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -95,7 +95,7 @@ static bool radeon_atom_mode_fixup(struct drm_encoder *encoder,
 	    ((radeon_encoder->active_device & (ATOM_DEVICE_DFP_SUPPORT | ATOM_DEVICE_LCD_SUPPORT)) ||
 	     (radeon_encoder_get_dp_bridge_encoder_id(encoder) != ENCODER_OBJECT_ID_NONE))) {
 		struct drm_connector *connector = radeon_get_connector_for_encoder(encoder);
-		radeon_dp_set_link_config(connector, mode);
+		radeon_dp_set_link_config(connector, adjusted_mode);
 	}
 
 	return true;
-- 
1.7.9.5

