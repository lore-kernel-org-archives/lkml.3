Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab3LSMWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:22:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45105 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab3LSL6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 141/208] drm/radeon: program DCE2 audio dto just like DCE3
Date: Thu, 19 Dec 2013 11:53:59 +0000
Message-Id: <1387454106-19326-142-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 55d4e020fb8ddd3896a8cd3351028f5c3a2c4bd3 upstream.

Seems to work like the DCE3 version despite what
the register spec says.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=71975

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/r600_hdmi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index 92c6df7..4006a32 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -304,9 +304,9 @@ void r600_audio_set_dto(struct drm_encoder *encoder, u32 clock)
 			WREG32(DCCG_AUDIO_DTO1_MODULE, dto_modulo);
 			WREG32(DCCG_AUDIO_DTO_SELECT, 1); /* select DTO1 */
 		}
-	} else if (ASIC_IS_DCE3(rdev)) {
+	} else {
 		/* according to the reg specs, this should DCE3.2 only, but in
-		 * practice it seems to cover DCE3.0/3.1 as well.
+		 * practice it seems to cover DCE2.0/3.0/3.1 as well.
 		 */
 		if (dig->dig_encoder == 0) {
 			WREG32(DCCG_AUDIO_DTO0_PHASE, base_rate * 100);
@@ -317,10 +317,6 @@ void r600_audio_set_dto(struct drm_encoder *encoder, u32 clock)
 			WREG32(DCCG_AUDIO_DTO1_MODULE, clock * 100);
 			WREG32(DCCG_AUDIO_DTO_SELECT, 1); /* select DTO1 */
 		}
-	} else {
-		/* according to the reg specs, this should be DCE2.0 and DCE3.0/3.1 */
-		WREG32(AUDIO_DTO, AUDIO_DTO_PHASE(base_rate / 10) |
-		       AUDIO_DTO_MODULE(clock / 10));
 	}
 }
 
-- 
1.8.3.2

