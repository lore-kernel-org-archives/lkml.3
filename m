Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966231AbaCUAJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:09:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966214AbaCUAJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.4 24/35] drm/radeon/atom: select the proper number of lanes in transmitter setup
Date: Thu, 20 Mar 2014 17:11:15 -0700
Message-Id: <20140321001054.953995591@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321001054.038170009@linuxfoundation.org>
References: <20140321001054.038170009@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d03874c881a049a50e12f285077ab1f9fc2686e1 upstream.

We need to check for DVI vs. HDMI when setting up duallink since
HDMI is single link only.  Fixes 4k modes on newer asics.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=75223

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_encoders.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1048,7 +1048,7 @@ atombios_dig_transmitter_setup(struct dr
 			}
 			if (is_dp)
 				args.v5.ucLaneNum = dp_lane_count;
-			else if (radeon_encoder->pixel_clock > 165000)
+			else if (radeon_dig_monitor_is_duallink(encoder, radeon_encoder->pixel_clock))
 				args.v5.ucLaneNum = 8;
 			else
 				args.v5.ucLaneNum = 4;


