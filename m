Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaIKRDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:03:31 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50752 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaIKRDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:03:09 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        b.zolnierkie@samsung.com, patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org,
        peppe.cavallaro@st.com
Subject: [PATCH v3 2/4] phy: phy-stih407-usb: Add dt documentation for USB picophy found on stih407 SoC family
Date: Thu, 11 Sep 2014 18:02:45 +0100
Message-Id: <1410454967-21500-3-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410454967-21500-1-git-send-email-peter.griffin@linaro.org>
References: <1410454967-21500-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the dt documentation for the usb picophy found on stih407 SoC family
available from STMicroelectronics.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 .../devicetree/bindings/phy/phy-stih407-usb.txt    | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-stih407-usb.txt

diff --git a/Documentation/devicetree/bindings/phy/phy-stih407-usb.txt b/Documentation/devicetree/bindings/phy/phy-stih407-usb.txt
new file mode 100644
index 0000000..1ef8228
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/phy-stih407-usb.txt
@@ -0,0 +1,30 @@
+ST STiH407 USB PHY controller
+
+This file documents the dt bindings for the usb picoPHY driver which is the PHY for both USB2 and USB3
+host controllers (when controlling usb2/1.1 devices) available on STiH407 SoC family from STMicroelectronics.
+
+Required properties:
+- compatible		: should be "st,stih407-usb2-phy"
+- reg			: contain the offset and length of the system configuration registers
+			  used as glue logic to control & parameter phy
+- reg-names		: the names of the system configuration registers in "reg", should be "param" and "reg"
+- st,syscfg		: sysconfig register to manage phy parameter at driver level
+- resets		: list of phandle and reset specifier pairs. There should be two entries, one
+			  for the whole phy and one for the port
+- reset-names		: list of reset signal names. Should be "global" and "port"
+See: Documentation/devicetree/bindings/reset/st,sti-powerdown.txt
+See: Documentation/devicetree/bindings/reset/reset.txt
+
+Example:
+
+usb2_picophy0: usbpicophy@f8 {
+	compatible	= "st,stih407-usb2-phy";
+	reg		= <0xf8 0x04>,	/* syscfg 5062 */
+			  <0xf4 0x04>;	/* syscfg 5061 */
+	reg-names	= "param", "ctrl";
+	#phy-cells	= <0>;
+	st,syscfg	= <&syscfg_core>;
+	resets		= <&softreset STIH407_PICOPHY_SOFTRESET>,
+			  <&picophyreset STIH407_PICOPHY0_RESET>;
+	reset-names	= "global", "port";
+};
-- 
1.9.1

