Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbaGHAnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:43:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaGGXyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 30/94] drm/radeon/atom: fix dithering on certain panels
Date: Mon,  7 Jul 2014 16:57:20 -0700
Message-Id: <20140707235757.680512880@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 642528355c694f5ed68f6bff9ff520326a249f99 upstream.

We need to specify the encoder mode as LVDS for eDP
when using the Crtc_Source atom table in order to properly
set up the FMT hardware.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=73911

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_encoders.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1898,8 +1898,11 @@ atombios_set_encoder_crtc_source(struct
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


