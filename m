Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbbAMWSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:18:34 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44242 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbbAMWSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:18:32 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, gbeeresh@codeaurora.org,
        Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 1/2] drm/msm/mdp5: add register description for HW Cursor support
Date: Tue, 13 Jan 2015 17:18:03 -0500
Message-Id: <1421187484-13875-2-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1421187484-13875-1-git-send-email-sviau@codeaurora.org>
References: <1421187484-13875-1-git-send-email-sviau@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update generated headers, in particular pick up the definitions
for Hardware Cursor support (MDP5).

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h | 79 +++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h
index 7833c22..09701a4 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5.xml.h
@@ -129,6 +129,17 @@ enum mdp5_client_id {
 	CID_MAX = 23,
 };
 
+enum mdp5_cursor_format {
+	CURSOR_FMT_ARGB8888 = 0,
+	CURSOR_FMT_ARGB1555 = 2,
+	CURSOR_FMT_ARGB4444 = 4,
+};
+
+enum mdp5_cursor_alpha {
+	CURSOR_ALPHA_CONST = 0,
+	CURSOR_ALPHA_PER_PIXEL = 2,
+};
+
 enum mdp5_igc_type {
 	IGC_VIG = 0,
 	IGC_RGB = 1,
@@ -973,20 +984,88 @@ static inline uint32_t REG_MDP5_LM_BLEND_BG_TRANSP_HIGH0(uint32_t i0, uint32_t i
 static inline uint32_t REG_MDP5_LM_BLEND_BG_TRANSP_HIGH1(uint32_t i0, uint32_t i1) { return 0x00000048 + __offset_LM(i0) + 0x30*i1; }
 
 static inline uint32_t REG_MDP5_LM_CURSOR_IMG_SIZE(uint32_t i0) { return 0x000000e0 + __offset_LM(i0); }
+#define MDP5_LM_CURSOR_IMG_SIZE_SRC_W__MASK			0x0000ffff
+#define MDP5_LM_CURSOR_IMG_SIZE_SRC_W__SHIFT			0
+static inline uint32_t MDP5_LM_CURSOR_IMG_SIZE_SRC_W(uint32_t val)
+{
+	return ((val) << MDP5_LM_CURSOR_IMG_SIZE_SRC_W__SHIFT) & MDP5_LM_CURSOR_IMG_SIZE_SRC_W__MASK;
+}
+#define MDP5_LM_CURSOR_IMG_SIZE_SRC_H__MASK			0xffff0000
+#define MDP5_LM_CURSOR_IMG_SIZE_SRC_H__SHIFT			16
+static inline uint32_t MDP5_LM_CURSOR_IMG_SIZE_SRC_H(uint32_t val)
+{
+	return ((val) << MDP5_LM_CURSOR_IMG_SIZE_SRC_H__SHIFT) & MDP5_LM_CURSOR_IMG_SIZE_SRC_H__MASK;
+}
 
 static inline uint32_t REG_MDP5_LM_CURSOR_SIZE(uint32_t i0) { return 0x000000e4 + __offset_LM(i0); }
+#define MDP5_LM_CURSOR_SIZE_ROI_W__MASK				0x0000ffff
+#define MDP5_LM_CURSOR_SIZE_ROI_W__SHIFT			0
+static inline uint32_t MDP5_LM_CURSOR_SIZE_ROI_W(uint32_t val)
+{
+	return ((val) << MDP5_LM_CURSOR_SIZE_ROI_W__SHIFT) & MDP5_LM_CURSOR_SIZE_ROI_W__MASK;
+}
+#define MDP5_LM_CURSOR_SIZE_ROI_H__MASK				0xffff0000
+#define MDP5_LM_CURSOR_SIZE_ROI_H__SHIFT			16
+static inline uint32_t MDP5_LM_CURSOR_SIZE_ROI_H(uint32_t val)
+{
+	return ((val) << MDP5_LM_CURSOR_SIZE_ROI_H__SHIFT) & MDP5_LM_CURSOR_SIZE_ROI_H__MASK;
+}
 
 static inline uint32_t REG_MDP5_LM_CURSOR_XY(uint32_t i0) { return 0x000000e8 + __offset_LM(i0); }
+#define MDP5_LM_CURSOR_XY_SRC_X__MASK				0x0000ffff
+#define MDP5_LM_CURSOR_XY_SRC_X__SHIFT				0
+static inline uint32_t MDP5_LM_CURSOR_XY_SRC_X(uint32_t val)
+{
+	return ((val) << MDP5_LM_CURSOR_XY_SRC_X__SHIFT) & MDP5_LM_CURSOR_XY_SRC_X__MASK;
+}
+#define MDP5_LM_CURSOR_XY_SRC_Y__MASK				0xffff0000
+#define MDP5_LM_CURSOR_XY_SRC_Y__SHIFT				16
+static inline uint32_t MDP5_LM_CURSOR_XY_SRC_Y(uint32_t val)
+{
+	return ((val) << MDP5_LM_CURSOR_XY_SRC_Y__SHIFT) & MDP5_LM_CURSOR_XY_SRC_Y__MASK;
+}
 
 static inline uint32_t REG_MDP5_LM_CURSOR_STRIDE(uint32_t i0) { return 0x000000dc + __offset_LM(i0); }
+#define MDP5_LM_CURSOR_STRIDE_STRIDE__MASK			0x0000ffff
+#define MDP5_LM_CURSOR_STRIDE_STRIDE__SHIFT			0
+static inline uint32_t MDP5_LM_CURSOR_STRIDE_STRIDE(uint32_t val)
+{
+	return ((val) << MDP5_LM_CURSOR_STRIDE_STRIDE__SHIFT) & MDP5_LM_CURSOR_STRIDE_STRIDE__MASK;
+}
 
 static inline uint32_t REG_MDP5_LM_CURSOR_FORMAT(uint32_t i0) { return 0x000000ec + __offset_LM(i0); }
+#define MDP5_LM_CURSOR_FORMAT_FORMAT__MASK			0x00000007
+#define MDP5_LM_CURSOR_FORMAT_FORMAT__SHIFT			0
+static inline uint32_t MDP5_LM_CURSOR_FORMAT_FORMAT(enum mdp5_cursor_format val)
+{
+	return ((val) << MDP5_LM_CURSOR_FORMAT_FORMAT__SHIFT) & MDP5_LM_CURSOR_FORMAT_FORMAT__MASK;
+}
 
 static inline uint32_t REG_MDP5_LM_CURSOR_BASE_ADDR(uint32_t i0) { return 0x000000f0 + __offset_LM(i0); }
 
 static inline uint32_t REG_MDP5_LM_CURSOR_START_XY(uint32_t i0) { return 0x000000f4 + __offset_LM(i0); }
+#define MDP5_LM_CURSOR_START_XY_X_START__MASK			0x0000ffff
+#define MDP5_LM_CURSOR_START_XY_X_START__SHIFT			0
+static inline uint32_t MDP5_LM_CURSOR_START_XY_X_START(uint32_t val)
+{
+	return ((val) << MDP5_LM_CURSOR_START_XY_X_START__SHIFT) & MDP5_LM_CURSOR_START_XY_X_START__MASK;
+}
+#define MDP5_LM_CURSOR_START_XY_Y_START__MASK			0xffff0000
+#define MDP5_LM_CURSOR_START_XY_Y_START__SHIFT			16
+static inline uint32_t MDP5_LM_CURSOR_START_XY_Y_START(uint32_t val)
+{
+	return ((val) << MDP5_LM_CURSOR_START_XY_Y_START__SHIFT) & MDP5_LM_CURSOR_START_XY_Y_START__MASK;
+}
 
 static inline uint32_t REG_MDP5_LM_CURSOR_BLEND_CONFIG(uint32_t i0) { return 0x000000f8 + __offset_LM(i0); }
+#define MDP5_LM_CURSOR_BLEND_CONFIG_BLEND_EN			0x00000001
+#define MDP5_LM_CURSOR_BLEND_CONFIG_BLEND_ALPHA_SEL__MASK	0x00000006
+#define MDP5_LM_CURSOR_BLEND_CONFIG_BLEND_ALPHA_SEL__SHIFT	1
+static inline uint32_t MDP5_LM_CURSOR_BLEND_CONFIG_BLEND_ALPHA_SEL(enum mdp5_cursor_alpha val)
+{
+	return ((val) << MDP5_LM_CURSOR_BLEND_CONFIG_BLEND_ALPHA_SEL__SHIFT) & MDP5_LM_CURSOR_BLEND_CONFIG_BLEND_ALPHA_SEL__MASK;
+}
+#define MDP5_LM_CURSOR_BLEND_CONFIG_BLEND_TRANSP_EN		0x00000008
 
 static inline uint32_t REG_MDP5_LM_CURSOR_BLEND_PARAM(uint32_t i0) { return 0x000000fc + __offset_LM(i0); }
 
-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

