Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111AbaGRNkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:40:53 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17643 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965657AbaGRNMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:12:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 082/170] drm/radeon/atom: fix dithering on certain panels
Date: Fri, 18 Jul 2014 14:11:27 +0200
Message-Id: <4a88652c5b6dae30f51c877df7beb9eed82675f8.1405685481.git.jslaby@suse.cz>
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

commit 642528355c694f5ed68f6bff9ff520326a249f99 upstream.

We need to specify the encoder mode as LVDS for eDP
when using the Crtc_Source atom table in order to properly
set up the FMT hardware.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=73911

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/atombios_encoders.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 7bb7074a131f..583345636d4b 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1910,8 +1910,11 @@ atombios_set_encoder_crtc_source(struct drm_encoder *encoder)
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
2.0.0

