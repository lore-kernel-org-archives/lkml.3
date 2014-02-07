Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaBGLwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:52:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42321 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482AbaBGLwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 188/233] drm/radeon: fix DAC interrupt handling on DCE5+
Date: Fri,  7 Feb 2014 11:46:47 +0000
Message-Id: <1391773652-25214-189-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e9a321c6b2ac954a7dbf235f419c255a424a1273 upstream.

DCE5 and newer hardware only has 1 DAC.  Use the correct
offset.  This may fix display problems on certain board
configurations.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c | 4 ++--
 drivers/gpu/drm/radeon/si.c        | 2 +-
 drivers/gpu/drm/radeon/sid.h       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 8307883..18ae744 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -4182,8 +4182,8 @@ void evergreen_disable_interrupt_state(struct radeon_device *rdev)
 		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET, 0);
 	}
 
-	/* only one DAC on DCE6 */
-	if (!ASIC_IS_DCE6(rdev))
+	/* only one DAC on DCE5 */
+	if (!ASIC_IS_DCE5(rdev))
 		WREG32(DACA_AUTODETECT_INT_CONTROL, 0);
 	WREG32(DACB_AUTODETECT_INT_CONTROL, 0);
 
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 0da5449..9e04414 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -5639,7 +5639,7 @@ static void si_disable_interrupt_state(struct radeon_device *rdev)
 	}
 
 	if (!ASIC_IS_NODCE(rdev)) {
-		WREG32(DACA_AUTODETECT_INT_CONTROL, 0);
+		WREG32(DAC_AUTODETECT_INT_CONTROL, 0);
 
 		tmp = RREG32(DC_HPD1_INT_CONTROL) & DC_HPDx_INT_POLARITY;
 		WREG32(DC_HPD1_INT_CONTROL, tmp);
diff --git a/drivers/gpu/drm/radeon/sid.h b/drivers/gpu/drm/radeon/sid.h
index 60e6ad7..0b55877 100644
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -719,7 +719,7 @@
 #       define GRPH_PFLIP_INT_MASK                      (1 << 0)
 #       define GRPH_PFLIP_INT_TYPE                      (1 << 8)
 
-#define	DACA_AUTODETECT_INT_CONTROL			0x66c8
+#define	DAC_AUTODETECT_INT_CONTROL			0x67c8
 
 #define DC_HPD1_INT_STATUS                              0x601c
 #define DC_HPD2_INT_STATUS                              0x6028
-- 
1.8.3.2

