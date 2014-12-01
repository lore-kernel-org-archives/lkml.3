Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbaLAUvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:51:33 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36257 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaLAUvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:51:32 -0500
From: Jilai Wang <jilaiw@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Jilai Wang <jilaiw@codeaurora.org>
Subject: [PATCH 1/2] drm/msm/hdmi: add register description for HDMI HDCP support
Date: Mon,  1 Dec 2014 15:51:24 -0500
Message-Id: <1417467084-4579-1-git-send-email-jilaiw@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add HDCP related register description.

Signed-off-by: Jiali Wang <jilaiw@codeaurora.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.xml.h | 76 +++++++++++++++++++++++++++++--------
 1 file changed, 60 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.xml.h b/drivers/gpu/drm/msm/hdmi/hdmi.xml.h
index 76fd0cf..6dd6168 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.xml.h
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.xml.h
@@ -8,16 +8,8 @@ http://github.com/freedreno/envytools/
 git clone https://github.com/freedreno/envytools.git
 
 The rules-ng-ng source files this header was generated from are:
-- /home/robclark/src/freedreno/envytools/rnndb/msm.xml                 (    647 bytes, from 2013-11-30 14:45:35)
-- /home/robclark/src/freedreno/envytools/rnndb/freedreno_copyright.xml (   1453 bytes, from 2013-03-31 16:51:27)
-- /home/robclark/src/freedreno/envytools/rnndb/mdp/mdp4.xml            (  20457 bytes, from 2014-08-01 12:22:48)
-- /home/robclark/src/freedreno/envytools/rnndb/mdp/mdp_common.xml      (   1615 bytes, from 2014-07-17 15:34:33)
-- /home/robclark/src/freedreno/envytools/rnndb/mdp/mdp5.xml            (  22517 bytes, from 2014-07-17 15:34:33)
-- /home/robclark/src/freedreno/envytools/rnndb/dsi/dsi.xml             (  11712 bytes, from 2013-08-17 17:13:43)
-- /home/robclark/src/freedreno/envytools/rnndb/dsi/sfpb.xml            (    344 bytes, from 2013-08-11 19:26:32)
-- /home/robclark/src/freedreno/envytools/rnndb/dsi/mmss_cc.xml         (   1686 bytes, from 2014-08-01 12:23:53)
-- /home/robclark/src/freedreno/envytools/rnndb/hdmi/qfprom.xml         (    600 bytes, from 2013-07-05 19:21:12)
-- /home/robclark/src/freedreno/envytools/rnndb/hdmi/hdmi.xml           (  23613 bytes, from 2014-07-17 15:33:30)
+- /local/mnt2/workspace2/jilaiw/chromeos/envytools/envytools/rnndb/hdmi/hdmi.xml           (  25125 bytes, from 2014-11-24 23:30:39)
+- /local/mnt2/workspace2/jilaiw/chromeos/envytools/envytools/rnndb/freedreno_copyright.xml (   1453 bytes, from 2014-11-24 22:27:21)
 
 Copyright (C) 2013-2014 by the following authors:
 - Rob Clark <robdclark@gmail.com> (robclark)
@@ -45,12 +37,14 @@ WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 
 enum hdmi_hdcp_key_state {
-	NO_KEYS = 0,
-	NOT_CHECKED = 1,
-	CHECKING = 2,
-	KEYS_VALID = 3,
-	AKSV_INVALID = 4,
-	CHECKSUM_MISMATCH = 5,
+	HDCP_KEYS_STATE_NO_KEYS = 0,
+	HDCP_KEYS_STATE_NOT_CHECKED = 1,
+	HDCP_KEYS_STATE_CHECKING = 2,
+	HDCP_KEYS_STATE_VALID = 3,
+	HDCP_KEYS_STATE_AKSV_NOT_VALID = 4,
+	HDCP_KEYS_STATE_CHKSUM_MISMATCH = 5,
+	HDCP_KEYS_STATE_PROD_AKSV = 6,
+	HDCP_KEYS_STATE_RESERVED = 7,
 };
 
 enum hdmi_ddc_read_write {
@@ -199,6 +193,8 @@ static inline uint32_t HDMI_AUDIO_INFO1_LSV(uint32_t val)
 #define HDMI_HDCP_CTRL_ENABLE					0x00000001
 #define HDMI_HDCP_CTRL_ENCRYPTION_ENABLE			0x00000100
 
+#define REG_HDMI_HDCP_DEBUG_CTRL				0x00000114
+
 #define REG_HDMI_HDCP_INT_CTRL					0x00000118
 
 #define REG_HDMI_HDCP_LINK0_STATUS				0x0000011c
@@ -211,9 +207,47 @@ static inline uint32_t HDMI_HDCP_LINK0_STATUS_KEY_STATE(enum hdmi_hdcp_key_state
 	return ((val) << HDMI_HDCP_LINK0_STATUS_KEY_STATE__SHIFT) & HDMI_HDCP_LINK0_STATUS_KEY_STATE__MASK;
 }
 
+#define REG_HDMI_HDCP_DDC_CTRL_0				0x00000120
+
+#define REG_HDMI_HDCP_DDC_CTRL_1				0x00000124
+
+#define REG_HDMI_HDCP_DDC_STATUS				0x00000128
+
+#define REG_HDMI_HDCP_ENTROPY_CTRL0				0x0000012c
+
+#define REG_HDMI_HDCP_ENTROPY_CTRL1				0x0000025c
+
 #define REG_HDMI_HDCP_RESET					0x00000130
 #define HDMI_HDCP_RESET_LINK0_DEAUTHENTICATE			0x00000001
 
+#define REG_HDMI_HDCP_RCVPORT_DATA0				0x00000134
+
+#define REG_HDMI_HDCP_RCVPORT_DATA1				0x00000138
+
+#define REG_HDMI_HDCP_RCVPORT_DATA2_0				0x0000013c
+
+#define REG_HDMI_HDCP_RCVPORT_DATA2_1				0x00000140
+
+#define REG_HDMI_HDCP_RCVPORT_DATA3				0x00000144
+
+#define REG_HDMI_HDCP_RCVPORT_DATA4				0x00000148
+
+#define REG_HDMI_HDCP_RCVPORT_DATA5				0x0000014c
+
+#define REG_HDMI_HDCP_RCVPORT_DATA6				0x00000150
+
+#define REG_HDMI_HDCP_RCVPORT_DATA7				0x00000154
+
+#define REG_HDMI_HDCP_RCVPORT_DATA8				0x00000158
+
+#define REG_HDMI_HDCP_RCVPORT_DATA9				0x0000015c
+
+#define REG_HDMI_HDCP_RCVPORT_DATA10				0x00000160
+
+#define REG_HDMI_HDCP_RCVPORT_DATA11				0x00000164
+
+#define REG_HDMI_HDCP_RCVPORT_DATA12				0x00000168
+
 #define REG_HDMI_VENSPEC_INFO0					0x0000016c
 
 #define REG_HDMI_VENSPEC_INFO1					0x00000170
@@ -329,6 +363,12 @@ static inline uint32_t HDMI_DDC_DATA_INDEX(uint32_t val)
 }
 #define HDMI_DDC_DATA_INDEX_WRITE				0x80000000
 
+#define REG_HDMI_HDCP_SHA_CTRL					0x0000023c
+
+#define REG_HDMI_HDCP_SHA_STATUS				0x00000240
+
+#define REG_HDMI_HDCP_SHA_DATA					0x00000244
+
 #define REG_HDMI_HPD_INT_STATUS					0x00000250
 #define HDMI_HPD_INT_STATUS_INT					0x00000001
 #define HDMI_HPD_INT_STATUS_CABLE_DETECTED			0x00000002
@@ -359,6 +399,10 @@ static inline uint32_t HDMI_DDC_REF_REFTIMER(uint32_t val)
 	return ((val) << HDMI_DDC_REF_REFTIMER__SHIFT) & HDMI_DDC_REF_REFTIMER__MASK;
 }
 
+#define REG_HDMI_HDCP_SW_UPPER_AKSV				0x00000284
+
+#define REG_HDMI_HDCP_SW_LOWER_AKSV				0x00000288
+
 #define REG_HDMI_CEC_STATUS					0x00000298
 
 #define REG_HDMI_CEC_INT					0x0000029c
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

