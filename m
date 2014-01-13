Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaAMRAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:00:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53016 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaAMQCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 047/208] drm/radeon: add missing display tiling setup for oland
Date: Mon, 13 Jan 2014 15:58:08 +0000
Message-Id: <1389628849-1614-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 227ae10f17a5f2fd1307b7e582b603ef7bbb7e97 upstream.

Fixes improperly set up display params for 2D tiling on
oland.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_crtc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index 4c5be9a..8b92676 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1196,7 +1196,9 @@ static int dce4_crtc_do_set_base(struct drm_crtc *crtc,
 	} else if ((rdev->family == CHIP_TAHITI) ||
 		   (rdev->family == CHIP_PITCAIRN))
 		fb_format |= SI_GRPH_PIPE_CONFIG(SI_ADDR_SURF_P8_32x32_8x16);
-	else if (rdev->family == CHIP_VERDE)
+	else if ((rdev->family == CHIP_VERDE) ||
+		 (rdev->family == CHIP_OLAND) ||
+		 (rdev->family == CHIP_HAINAN)) /* for completeness.  HAINAN has no display hw */
 		fb_format |= SI_GRPH_PIPE_CONFIG(SI_ADDR_SURF_P4_8x16);
 
 	switch (radeon_crtc->crtc_id) {
-- 
1.8.3.2

