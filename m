Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbaBKTs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:48:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbaBKTH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 076/107] drm/radeon: fix DAC interrupt handling on DCE5+
Date: Tue, 11 Feb 2014 11:05:42 -0800
Message-Id: <20140211184750.365869358@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e9a321c6b2ac954a7dbf235f419c255a424a1273 upstream.

DCE5 and newer hardware only has 1 DAC.  Use the correct
offset.  This may fix display problems on certain board
configurations.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |    4 ++--
 drivers/gpu/drm/radeon/si.c        |    2 +-
 drivers/gpu/drm/radeon/sid.h       |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -4249,8 +4249,8 @@ void evergreen_disable_interrupt_state(s
 		WREG32(GRPH_INT_CONTROL + EVERGREEN_CRTC5_REGISTER_OFFSET, 0);
 	}
 
-	/* only one DAC on DCE6 */
-	if (!ASIC_IS_DCE6(rdev))
+	/* only one DAC on DCE5 */
+	if (!ASIC_IS_DCE5(rdev))
 		WREG32(DACA_AUTODETECT_INT_CONTROL, 0);
 	WREG32(DACB_AUTODETECT_INT_CONTROL, 0);
 
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -5625,7 +5625,7 @@ static void si_disable_interrupt_state(s
 	}
 
 	if (!ASIC_IS_NODCE(rdev)) {
-		WREG32(DACA_AUTODETECT_INT_CONTROL, 0);
+		WREG32(DAC_AUTODETECT_INT_CONTROL, 0);
 
 		tmp = RREG32(DC_HPD1_INT_CONTROL) & DC_HPDx_INT_POLARITY;
 		WREG32(DC_HPD1_INT_CONTROL, tmp);
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -770,7 +770,7 @@
 #       define GRPH_PFLIP_INT_MASK                      (1 << 0)
 #       define GRPH_PFLIP_INT_TYPE                      (1 << 8)
 
-#define	DACA_AUTODETECT_INT_CONTROL			0x66c8
+#define	DAC_AUTODETECT_INT_CONTROL			0x67c8
 
 #define DC_HPD1_INT_STATUS                              0x601c
 #define DC_HPD2_INT_STATUS                              0x6028


