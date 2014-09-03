Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbaICK2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:28:16 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:65523 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154AbaICK2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:28:13 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, kishon@ti.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH 2/3] phy: phy-stih407-usb: Add dt documentation for USB picophy found on stih407 SoC family
Date: Wed,  3 Sep 2014 11:27:58 +0100
Message-Id: <1409740079-16554-3-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409740079-16554-1-git-send-email-peter.griffin@linaro.org>
References: <1409740079-16554-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the dt documentation for the usb picophy found on stih407 SoC family
available from STMicroelectronics.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 .../devicetree/bindings/phy/phy-stih407-usb.txt    | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-stih407-usb.txt

diff --git a/Documentation/devicetree/bindings/phy/phy-stih407-usb.txt b/Documentation/devicetree/bindings/phy/phy-stih407-usb.txt
new file mode 100644
index 0000000..650d346
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/phy-stih407-usb.txt
@@ -0,0 +1,37 @@
+ST STiH407 USB-PHY controller
+
+This file documents the dt bindings for the picoPHY driver which is the PHY for both USB2 and USB3 host controllers
+controllers available on STiH407 SoC families.
+
+On STiH410, we have to use the DWC3 port#2 with a picoPHY to manage USB2
+devices. The USB2 Controller will use the ports #0 and #1.
+
+This is to document the DT parameters to be passed from the blob in that case.
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
+usb2_picophy0: usbpicophy@0 {
+	compatible	= "st,stih407-usb2-phy";
+	reg		= <0xf8 0x04>,	/* syscfg 5062 */
+			  <0xf4 0x04>;	/* syscfg 5061 */
+	reg-names	= "param",
+			  "ctrl";
+			  #phy-cells = <0>;
+	st,syscfg	= <&syscfg_core>;
+	resets		= <&softreset STIH407_PICOPHY_SOFTRESET>,
+			  <&picophyreset STIH407_PICOPHY0_RESET>;
+	reset-names	= "global",
+			  "port";
+};
-- 
1.9.1

