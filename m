Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaDALRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:17:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42344 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbaDALRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 055/144] drm/radeon/atom: select the proper number of lanes in transmitter setup
Date: Tue,  1 Apr 2014 12:14:19 +0100
Message-Id: <1396350948-29910-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d03874c881a049a50e12f285077ab1f9fc2686e1 upstream.

We need to check for DVI vs. HDMI when setting up duallink since
HDMI is single link only.  Fixes 4k modes on newer asics.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=75223

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_encoders.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 56ed69e..f0d8cb1 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1297,7 +1297,7 @@ atombios_dig_transmitter_setup(struct drm_encoder *encoder, int action, uint8_t
 			}
 			if (is_dp)
 				args.v5.ucLaneNum = dp_lane_count;
-			else if (radeon_encoder->pixel_clock > 165000)
+			else if (radeon_dig_monitor_is_duallink(encoder, radeon_encoder->pixel_clock))
 				args.v5.ucLaneNum = 8;
 			else
 				args.v5.ucLaneNum = 4;
-- 
1.9.1

