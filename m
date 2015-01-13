Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbbAMUll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:41:41 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37854 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbbAMUlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:41:40 -0500
From: Jilai Wang <jilaiw@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Jilai Wang <jilaiw@codeaurora.org>
Subject: [PATCH 1/2] drm/msm/hdmi: add register description for HDMI HDCP support (V2)
Date: Tue, 13 Jan 2015 15:41:30 -0500
Message-Id: <1421181690-24258-1-git-send-email-jilaiw@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1417467084-4579-1-git-send-email-jilaiw@codeaurora.org>
References: <1417467084-4579-1-git-send-email-jilaiw@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add HDCP related register description.
V1: Initial Change
V2: Add register bit description.

Signed-off-by: Jiali Wang <jilaiw@codeaurora.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.xml.h | 42 +++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.xml.h b/drivers/gpu/drm/msm/hdmi/hdmi.xml.h
index 2d1272e..e7b455b 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.xml.h
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.xml.h
@@ -8,17 +8,8 @@ http://github.com/freedreno/envytools/
 git clone https://github.com/freedreno/envytools.git
 
 The rules-ng-ng source files this header was generated from are:
-- /home/robclark/src/freedreno/envytools/rnndb/msm.xml                 (    676 bytes, from 2014-12-05 15:34:49)
-- /home/robclark/src/freedreno/envytools/rnndb/freedreno_copyright.xml (   1453 bytes, from 2013-03-31 16:51:27)
-- /home/robclark/src/freedreno/envytools/rnndb/mdp/mdp4.xml            (  20908 bytes, from 2014-12-08 16:13:00)
-- /home/robclark/src/freedreno/envytools/rnndb/mdp/mdp_common.xml      (   2357 bytes, from 2014-12-08 16:13:00)
-- /home/robclark/src/freedreno/envytools/rnndb/mdp/mdp5.xml            (  26005 bytes, from 2014-12-08 16:13:00)
-- /home/robclark/src/freedreno/envytools/rnndb/dsi/dsi.xml             (  11712 bytes, from 2013-08-17 17:13:43)
-- /home/robclark/src/freedreno/envytools/rnndb/dsi/sfpb.xml            (    344 bytes, from 2013-08-11 19:26:32)
-- /home/robclark/src/freedreno/envytools/rnndb/dsi/mmss_cc.xml         (   1686 bytes, from 2014-10-31 16:48:57)
-- /home/robclark/src/freedreno/envytools/rnndb/hdmi/qfprom.xml         (    600 bytes, from 2013-07-05 19:21:12)
-- /home/robclark/src/freedreno/envytools/rnndb/hdmi/hdmi.xml           (  25125 bytes, from 2014-12-02 15:04:52)
-- /home/robclark/src/freedreno/envytools/rnndb/edp/edp.xml             (   8253 bytes, from 2014-12-08 16:13:00)
+- /local/mnt2/workspace2/jilaiw/chromeos/envytools/envytools/rnndb/hdmi/hdmi.xml           (  26848 bytes, from 2014-12-11 18:18:13)
+- /local/mnt2/workspace2/jilaiw/chromeos/envytools/envytools/rnndb/freedreno_copyright.xml (   1453 bytes, from 2014-11-24 22:27:21)
 
 Copyright (C) 2013-2014 by the following authors:
 - Rob Clark <robdclark@gmail.com> (robclark)
@@ -203,12 +194,28 @@ static inline uint32_t HDMI_AUDIO_INFO1_LSV(uint32_t val)
 #define HDMI_HDCP_CTRL_ENCRYPTION_ENABLE			0x00000100
 
 #define REG_HDMI_HDCP_DEBUG_CTRL				0x00000114
+#define HDMI_HDCP_DEBUG_CTRL_RNG_CIPHER				0x00000004
 
 #define REG_HDMI_HDCP_INT_CTRL					0x00000118
+#define HDMI_HDCP_INT_CTRL_AUTH_SUCCESS_INT			0x00000001
+#define HDMI_HDCP_INT_CTRL_AUTH_SUCCESS_ACK			0x00000002
+#define HDMI_HDCP_INT_CTRL_AUTH_SUCCESS_MASK			0x00000004
+#define HDMI_HDCP_INT_CTRL_AUTH_FAIL_INT			0x00000010
+#define HDMI_HDCP_INT_CTRL_AUTH_FAIL_ACK			0x00000020
+#define HDMI_HDCP_INT_CTRL_AUTH_FAIL_MASK			0x00000040
+#define HDMI_HDCP_INT_CTRL_AUTH_FAIL_INFO_ACK			0x00000080
+#define HDMI_HDCP_INT_CTRL_AUTH_XFER_REQ_INT			0x00000100
+#define HDMI_HDCP_INT_CTRL_AUTH_XFER_REQ_ACK			0x00000200
+#define HDMI_HDCP_INT_CTRL_AUTH_XFER_REQ_MASK			0x00000400
+#define HDMI_HDCP_INT_CTRL_AUTH_XFER_DONE_INT			0x00001000
+#define HDMI_HDCP_INT_CTRL_AUTH_XFER_DONE_ACK			0x00002000
+#define HDMI_HDCP_INT_CTRL_AUTH_XFER_DONE_MASK			0x00004000
 
 #define REG_HDMI_HDCP_LINK0_STATUS				0x0000011c
 #define HDMI_HDCP_LINK0_STATUS_AN_0_READY			0x00000100
 #define HDMI_HDCP_LINK0_STATUS_AN_1_READY			0x00000200
+#define HDMI_HDCP_LINK0_STATUS_RI_MATCHES			0x00001000
+#define HDMI_HDCP_LINK0_STATUS_V_MATCHES			0x00100000
 #define HDMI_HDCP_LINK0_STATUS_KEY_STATE__MASK			0x70000000
 #define HDMI_HDCP_LINK0_STATUS_KEY_STATE__SHIFT			28
 static inline uint32_t HDMI_HDCP_LINK0_STATUS_KEY_STATE(enum hdmi_hdcp_key_state val)
@@ -217,10 +224,19 @@ static inline uint32_t HDMI_HDCP_LINK0_STATUS_KEY_STATE(enum hdmi_hdcp_key_state
 }
 
 #define REG_HDMI_HDCP_DDC_CTRL_0				0x00000120
+#define HDMI_HDCP_DDC_CTRL_0_DISABLE				0x00000001
 
 #define REG_HDMI_HDCP_DDC_CTRL_1				0x00000124
+#define HDMI_HDCP_DDC_CTRL_1_FAILED_ACK				0x00000001
 
 #define REG_HDMI_HDCP_DDC_STATUS				0x00000128
+#define HDMI_HDCP_DDC_STATUS_XFER_REQ				0x00000010
+#define HDMI_HDCP_DDC_STATUS_XFER_DONE				0x00000400
+#define HDMI_HDCP_DDC_STATUS_ABORTED				0x00001000
+#define HDMI_HDCP_DDC_STATUS_TIMEOUT				0x00002000
+#define HDMI_HDCP_DDC_STATUS_NACK0				0x00004000
+#define HDMI_HDCP_DDC_STATUS_NACK1				0x00008000
+#define HDMI_HDCP_DDC_STATUS_FAILED				0x00010000
 
 #define REG_HDMI_HDCP_ENTROPY_CTRL0				0x0000012c
 
@@ -309,6 +325,7 @@ static inline uint32_t HDMI_DDC_CTRL_TRANSACTION_CNT(uint32_t val)
 #define HDMI_DDC_SW_STATUS_NACK3				0x00008000
 
 #define REG_HDMI_DDC_HW_STATUS					0x0000021c
+#define HDMI_DDC_HW_STATUS_DONE					0x00000008
 
 #define REG_HDMI_DDC_SPEED					0x00000220
 #define HDMI_DDC_SPEED_THRESHOLD__MASK				0x00000003
@@ -375,8 +392,11 @@ static inline uint32_t HDMI_DDC_DATA_INDEX(uint32_t val)
 #define REG_HDMI_HDCP_SHA_CTRL					0x0000023c
 
 #define REG_HDMI_HDCP_SHA_STATUS				0x00000240
+#define HDMI_HDCP_SHA_STATUS_BLOCK_DONE				0x00000001
+#define HDMI_HDCP_SHA_STATUS_COMP_DONE				0x00000010
 
 #define REG_HDMI_HDCP_SHA_DATA					0x00000244
+#define HDMI_HDCP_SHA_DATA_DONE					0x00000001
 
 #define REG_HDMI_HPD_INT_STATUS					0x00000250
 #define HDMI_HPD_INT_STATUS_INT					0x00000001
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

