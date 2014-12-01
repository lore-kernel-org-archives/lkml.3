Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbaLAUrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:47:51 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36017 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaLAUrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:47:49 -0500
From: Jilai Wang <jilaiw@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Jilai Wang <jilaiw@codeaurora.org>
Subject: [PATCH] rnndb: Add register fields for msm/hdmi HDCP support
Date: Mon,  1 Dec 2014 15:47:34 -0500
Message-Id: <1417466854-4366-1-git-send-email-jilaiw@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the field description for HDMI HDCP registers.

Signed-off-by: Jilai Wang <jilaiw@codeaurora.org>
---
 rnndb/hdmi/hdmi.xml | 46 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 40 insertions(+), 6 deletions(-)

diff --git a/rnndb/hdmi/hdmi.xml b/rnndb/hdmi/hdmi.xml
index 64393b4..c67e6c1 100644
--- a/rnndb/hdmi/hdmi.xml
+++ b/rnndb/hdmi/hdmi.xml
@@ -12,12 +12,14 @@ xsi:schemaLocation="http://nouveau.freedesktop.org/ rules-ng.xsd">
 
 <domain name="HDMI" width="32">
 	<enum name="hdmi_hdcp_key_state">
-		<value name="NO_KEYS" value="0"/>
-		<value name="NOT_CHECKED" value="1"/>
-		<value name="CHECKING" value="2"/>
-		<value name="KEYS_VALID" value="3"/>
-		<value name="AKSV_INVALID" value="4"/>
-		<value name="CHECKSUM_MISMATCH" value="5"/>
+		<value name="HDCP_KEYS_STATE_NO_KEYS" value="0"/>
+		<value name="HDCP_KEYS_STATE_NOT_CHECKED" value="1"/>
+		<value name="HDCP_KEYS_STATE_CHECKING" value="2"/>
+		<value name="HDCP_KEYS_STATE_VALID" value="3"/>
+		<value name="HDCP_KEYS_STATE_AKSV_NOT_VALID" value="4"/>
+		<value name="HDCP_KEYS_STATE_CHKSUM_MISMATCH" value="5"/>
+		<value name="HDCP_KEYS_STATE_PROD_AKSV" value="6"/>
+		<value name="HDCP_KEYS_STATE_RESERVED" value="7"/>
 	</enum>
 	<enum name="hdmi_ddc_read_write">
 		<value name="DDC_WRITE" value="0"/>
@@ -168,15 +170,39 @@ xsi:schemaLocation="http://nouveau.freedesktop.org/ rules-ng.xsd">
 		<bitfield name="ENABLE" pos="0" type="boolean"/>
 		<bitfield name="ENCRYPTION_ENABLE" pos="8" type="boolean"/>
 	</reg32>
+	<reg32 offset="0x00114" name="HDCP_DEBUG_CTRL"/>
 	<reg32 offset="0x00118" name="HDCP_INT_CTRL"/>
 	<reg32 offset="0x0011c" name="HDCP_LINK0_STATUS">
 		<bitfield name="AN_0_READY" pos="8" type="boolean"/>
 		<bitfield name="AN_1_READY" pos="9" type="boolean"/>
 		<bitfield name="KEY_STATE" low="28" high="30" type="hdmi_hdcp_key_state"/>
 	</reg32>
+	<reg32 offset="0x00120" name="HDCP_DDC_CTRL_0"/>
+	<reg32 offset="0x00124" name="HDCP_DDC_CTRL_1"/>
+	<reg32 offset="0x00128" name="HDCP_DDC_STATUS"/>
+
+	<reg32 offset="0x0012c" name="HDCP_ENTROPY_CTRL0"/>
+	<reg32 offset="0x0025c" name="HDCP_ENTROPY_CTRL1"/>
+
 	<reg32 offset="0x00130" name="HDCP_RESET">
 		<bitfield name="LINK0_DEAUTHENTICATE" pos="0" type="boolean"/>
 	</reg32>
+
+	<reg32 offset="0x00134" name="HDCP_RCVPORT_DATA0"/>
+	<reg32 offset="0x00138" name="HDCP_RCVPORT_DATA1"/>
+	<reg32 offset="0x0013C" name="HDCP_RCVPORT_DATA2_0"/>
+	<reg32 offset="0x00140" name="HDCP_RCVPORT_DATA2_1"/>
+	<reg32 offset="0x00144" name="HDCP_RCVPORT_DATA3"/>
+	<reg32 offset="0x00148" name="HDCP_RCVPORT_DATA4"/>
+	<reg32 offset="0x0014c" name="HDCP_RCVPORT_DATA5"/>
+	<reg32 offset="0x00150" name="HDCP_RCVPORT_DATA6"/>
+	<reg32 offset="0x00154" name="HDCP_RCVPORT_DATA7"/>
+	<reg32 offset="0x00158" name="HDCP_RCVPORT_DATA8"/>
+	<reg32 offset="0x0015c" name="HDCP_RCVPORT_DATA9"/>
+	<reg32 offset="0x00160" name="HDCP_RCVPORT_DATA10"/>
+	<reg32 offset="0x00164" name="HDCP_RCVPORT_DATA11"/>
+	<reg32 offset="0x00168" name="HDCP_RCVPORT_DATA12"/>
+
 	<reg32 offset="0x0016c" name="VENSPEC_INFO0"/>
 	<reg32 offset="0x00170" name="VENSPEC_INFO1"/>
 	<reg32 offset="0x00174" name="VENSPEC_INFO2"/>
@@ -319,6 +345,11 @@ xsi:schemaLocation="http://nouveau.freedesktop.org/ rules-ng.xsd">
 		<bitfield name="INDEX" low="16" high="23" type="uint"/>
 		<bitfield name="INDEX_WRITE" pos="31" type="boolean"/>
 	</reg32>
+
+	<reg32 offset="0x0023c" name="HDCP_SHA_CTRL"/>
+	<reg32 offset="0x00240" name="HDCP_SHA_STATUS"/>
+	<reg32 offset="0x00244" name="HDCP_SHA_DATA"/>
+
 	<reg32 offset="0x00250" name="HPD_INT_STATUS">
 		<bitfield name="INT" pos="0"/>  <!-- an irq has occurred -->
 		<bitfield name="CABLE_DETECTED" pos="1"/>
@@ -374,6 +405,9 @@ xsi:schemaLocation="http://nouveau.freedesktop.org/ rules-ng.xsd">
 		<bitfield name="REFTIMER" low="0" high="15" type="uint"/>
 	</reg32>
 
+	<reg32 offset="0x00284" name="HDCP_SW_UPPER_AKSV"/>
+	<reg32 offset="0x00288" name="HDCP_SW_LOWER_AKSV"/>
+
 	<reg32 offset="0x00298" name="CEC_STATUS"/>
 	<reg32 offset="0x0029c" name="CEC_INT"/>
 	<reg32 offset="0x002a0" name="CEC_ADDR"/>
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

