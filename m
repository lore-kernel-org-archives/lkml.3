Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab3EIXEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:04:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab3EIW0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 57/73] drm/radeon: fix hdmi mode enable on RS600/RS690/RS740
Date: Thu,  9 May 2013 15:25:47 -0700
Message-Id: <20130509222532.219885851@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit dcb852905772416e322536ced5cb3c796d176af5 upstream.

These chips were previously skipped since they are
pre-R600.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600_hdmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -433,7 +433,7 @@ void r600_hdmi_enable(struct drm_encoder
 	offset = dig->afmt->offset;
 
 	/* Older chipsets require setting HDMI and routing manually */
-	if (rdev->family >= CHIP_R600 && !ASIC_IS_DCE3(rdev)) {
+	if (ASIC_IS_DCE2(rdev) && !ASIC_IS_DCE3(rdev)) {
 		hdmi = HDMI0_ERROR_ACK | HDMI0_ENABLE;
 		switch (radeon_encoder->encoder_id) {
 		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_TMDS1:
@@ -501,7 +501,7 @@ void r600_hdmi_disable(struct drm_encode
 	radeon_irq_kms_disable_afmt(rdev, dig->afmt->id);
 
 	/* Older chipsets not handled by AtomBIOS */
-	if (rdev->family >= CHIP_R600 && !ASIC_IS_DCE3(rdev)) {
+	if (ASIC_IS_DCE2(rdev) && !ASIC_IS_DCE3(rdev)) {
 		switch (radeon_encoder->encoder_id) {
 		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_TMDS1:
 			WREG32_P(AVIVO_TMDSA_CNTL, 0,


