Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbaKMLBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:01:01 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:37264 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798AbaKMLA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:00:59 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v2 07/14] ARM: STi: DT: STiH407: Add usb2 picophy dt nodes
Date: Thu, 13 Nov 2014 11:00:10 +0000
Message-Id: <1415876417-28728-8-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
References: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the dt nodes for the usb2 picophy found on the stih407
device family. It is used on stih407 by the dwc3 usb3 controller when
controlling usb2/1.1 devices.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/boot/dts/stih407.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
index 50637f5..4ce1f07 100644
--- a/arch/arm/boot/dts/stih407.dtsi
+++ b/arch/arm/boot/dts/stih407.dtsi
@@ -275,5 +275,17 @@
 
 			status = "disabled";
 		};
+
+		usb2_picophy0: usbpicophy@0 {
+			compatible = "st,stih407-usb2-phy";
+			reg = <0xf8 0x04>,	/* syscfg 5062 */
+			      <0xf4 0x04>;	/* syscfg 5061 */
+			reg-names = "param", "ctrl";
+			#phy-cells = <0>;
+			st,syscfg = <&syscfg_core>;
+			resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
+				 <&picophyreset STIH407_PICOPHY0_RESET>;
+			reset-names = "global", "port";
+		};
 	};
 };
-- 
1.9.1

