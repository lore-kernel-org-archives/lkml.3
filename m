Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab3ERDRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:17:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab3ERDAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:11 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=va3dyq-Y-DUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=szMjFW20K1wA:10 a=zd2uoN0lAAAA:8 a=VwQbUJbxAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021701.801034582@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:18:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [ 126/136 ] drm/radeon: fix hdmi mode enable on RS600/RS690/RS740
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0126-drm-radeon-fix-hdmi-mode-enable-on-RS600-RS690-RS740.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit dcb852905772416e322536ced5cb3c796d176af5 ]

These chips were previously skipped since they are
pre-R600.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/r600_hdmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index e3558c3..ecf263f 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -489,7 +489,7 @@ void r600_hdmi_enable(struct drm_encoder *encoder)
 	offset = dig->afmt->offset;
 
 	/* Older chipsets require setting HDMI and routing manually */
-	if (rdev->family >= CHIP_R600 && !ASIC_IS_DCE3(rdev)) {
+	if (ASIC_IS_DCE2(rdev) && !ASIC_IS_DCE3(rdev)) {
 		hdmi = HDMI0_ERROR_ACK | HDMI0_ENABLE;
 		switch (radeon_encoder->encoder_id) {
 		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_TMDS1:
@@ -558,7 +558,7 @@ void r600_hdmi_disable(struct drm_encoder *encoder)
 	radeon_irq_kms_disable_afmt(rdev, dig->afmt->id);
 
 	/* Older chipsets not handled by AtomBIOS */
-	if (rdev->family >= CHIP_R600 && !ASIC_IS_DCE3(rdev)) {
+	if (ASIC_IS_DCE2(rdev) && !ASIC_IS_DCE3(rdev)) {
 		switch (radeon_encoder->encoder_id) {
 		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_TMDS1:
 			WREG32_P(AVIVO_TMDSA_CNTL, 0,
-- 
1.7.10.4


