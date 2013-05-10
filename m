Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab3EJOVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:21:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57214 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755314Ab3EJOVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:35 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.796395569@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [046/118] drm/radeon: fix hdmi mode enable on RS600/RS690/RS740
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit dcb852905772416e322536ced5cb3c796d176af5 upstream.

These chips were previously skipped since they are
pre-R600.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/r600_hdmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -506,7 +506,7 @@ void r600_hdmi_enable(struct drm_encoder
 	offset = radeon_encoder->hdmi_offset;
 	if (ASIC_IS_DCE32(rdev) && !ASIC_IS_DCE4(rdev)) {
 		WREG32_P(radeon_encoder->hdmi_config_offset + 0x4, 0x1, ~0x1);
-	} else if (rdev->family >= CHIP_R600 && !ASIC_IS_DCE3(rdev)) {
+	} else if (ASIC_IS_DCE2(rdev) && !ASIC_IS_DCE3(rdev)) {
 		switch (radeon_encoder->encoder_id) {
 		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_TMDS1:
 			WREG32_P(AVIVO_TMDSA_CNTL, 0x4, ~0x4);
@@ -572,7 +572,7 @@ void r600_hdmi_disable(struct drm_encode
 
 	if (ASIC_IS_DCE32(rdev) && !ASIC_IS_DCE4(rdev)) {
 		WREG32_P(radeon_encoder->hdmi_config_offset + 0x4, 0, ~0x1);
-	} else if (rdev->family >= CHIP_R600 && !ASIC_IS_DCE3(rdev)) {
+	} else if (ASIC_IS_DCE2(rdev) && !ASIC_IS_DCE3(rdev)) {
 		switch (radeon_encoder->encoder_id) {
 		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_TMDS1:
 			WREG32_P(AVIVO_TMDSA_CNTL, 0, ~0x4);

