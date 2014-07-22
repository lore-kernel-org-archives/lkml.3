Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687AbaGVWli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:41:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44703 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933165AbaGVWZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:25:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 050/116] drm/radeon/atom: fix dithering on certain panels
Date: Tue, 22 Jul 2014 15:21:01 -0700
Message-Id: <1406067727-19683-51-git-send-email-kamal@canonical.com>
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

commit 642528355c694f5ed68f6bff9ff520326a249f99 upstream.

We need to specify the encoder mode as LVDS for eDP
when using the Crtc_Source atom table in order to properly
set up the FMT hardware.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=73911

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_encoders.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 71619b0..f04f3c9 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1877,8 +1877,11 @@ atombios_set_encoder_crtc_source(struct drm_encoder *encoder)
 					args.v2.ucEncodeMode = ATOM_ENCODER_MODE_CRT;
 				else
 					args.v2.ucEncodeMode = atombios_get_encoder_mode(encoder);
-			} else
+			} else if (radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT)) {
+				args.v2.ucEncodeMode = ATOM_ENCODER_MODE_LVDS;
+			} else {
 				args.v2.ucEncodeMode = atombios_get_encoder_mode(encoder);
+			}
 			switch (radeon_encoder->encoder_id) {
 			case ENCODER_OBJECT_ID_INTERNAL_UNIPHY:
 			case ENCODER_OBJECT_ID_INTERNAL_UNIPHY1:
-- 
1.9.1

