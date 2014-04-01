Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaDAQKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:10:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44473 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaDAQKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:10:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 48/86] drm/radeon/atom: select the proper number of lanes in transmitter setup
Date: Tue,  1 Apr 2014 09:08:01 -0700
Message-Id: <1396368519-12728-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d03874c881a049a50e12f285077ab1f9fc2686e1 upstream.

We need to check for DVI vs. HDMI when setting up duallink since
HDMI is single link only.  Fixes 4k modes on newer asics.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=75223

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_encoders.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index e4f56ac..71619b0 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -1281,7 +1281,7 @@ atombios_dig_transmitter_setup(struct drm_encoder *encoder, int action, uint8_t
 			}
 			if (is_dp)
 				args.v5.ucLaneNum = dp_lane_count;
-			else if (radeon_encoder->pixel_clock > 165000)
+			else if (radeon_dig_monitor_is_duallink(encoder, radeon_encoder->pixel_clock))
 				args.v5.ucLaneNum = 8;
 			else
 				args.v5.ucLaneNum = 4;
-- 
1.8.3.2

