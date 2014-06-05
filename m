Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaFEEWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:22:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbaFEEWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 186/214] drm/radeon: fix hdmi mode enable on RS600/RS690/RS740
Date: Wed,  4 Jun 2014 21:19:09 -0700
Message-Id: <20140605041704.448575425@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit dcb852905772416e322536ced5cb3c796d176af5 upstream.

These chips were previously skipped since they are
pre-R600.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[wml: Backported to 3.4:
- adjust context
- no !ASIC_IS_DCE3(rdev)]
Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/r600_hdmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -530,7 +530,7 @@ void r600_hdmi_enable(struct drm_encoder
 		WREG32_P(radeon_encoder->hdmi_config_offset + 0x4, 0x1, ~0x1);
 	} else if (ASIC_IS_DCE3(rdev)) {
 		/* TODO */
-	} else if (rdev->family >= CHIP_R600) {
+	} else if (ASIC_IS_DCE2(rdev)) {
 		switch (radeon_encoder->encoder_id) {
 		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_TMDS1:
 			WREG32_P(AVIVO_TMDSA_CNTL, AVIVO_TMDSA_CNTL_HDMI_EN,
@@ -602,7 +602,7 @@ void r600_hdmi_disable(struct drm_encode
 		WREG32_P(radeon_encoder->hdmi_config_offset + 0xc, 0, ~0x1);
 	} else if (ASIC_IS_DCE32(rdev)) {
 		WREG32_P(radeon_encoder->hdmi_config_offset + 0x4, 0, ~0x1);
-	} else if (rdev->family >= CHIP_R600 && !ASIC_IS_DCE3(rdev)) {
+	} else if (ASIC_IS_DCE2(rdev) && !ASIC_IS_DCE3(rdev)) {
 		switch (radeon_encoder->encoder_id) {
 		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_TMDS1:
 			WREG32_P(AVIVO_TMDSA_CNTL, 0,


