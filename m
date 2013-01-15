Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030Ab3AOWtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:49:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:45652 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932876Ab3AOWt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:49:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Subject: [ 038/171] drm/radeon: fix eDP clk and lane setup for scaled modes
Date: Tue, 15 Jan 2013 14:43:23 -0800
Message-Id: <20130115224316.157021149@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 93927f9c1db5f55085457e820f0631064c7bfa34 upstream.

Need to use the adjusted mode since we are sending native
timing and using the scaler for non-native modes.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_encoders.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -95,7 +95,7 @@ static bool radeon_atom_mode_fixup(struc
 	    ((radeon_encoder->active_device & (ATOM_DEVICE_DFP_SUPPORT | ATOM_DEVICE_LCD_SUPPORT)) ||
 	     (radeon_encoder_get_dp_bridge_encoder_id(encoder) != ENCODER_OBJECT_ID_NONE))) {
 		struct drm_connector *connector = radeon_get_connector_for_encoder(encoder);
-		radeon_dp_set_link_config(connector, mode);
+		radeon_dp_set_link_config(connector, adjusted_mode);
 	}
 
 	return true;


