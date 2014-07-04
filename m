Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965091AbaGDLO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:14:27 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45202 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbaGDLOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:14:24 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH 2/3] ARM: dts: sti: Add st-dwc3 devicetree bindings documentation
Date: Fri,  4 Jul 2014 12:13:51 +0100
Message-Id: <1404472432-24764-3-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404472432-24764-1-git-send-email-peter.griffin@linaro.org>
References: <1404472432-24764-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents the device tree documentation required for
the ST usb3 controller glue layer found in STiH407 devices.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 Documentation/devicetree/bindings/usb/dwc3-st.txt | 58 +++++++++++++++++++++++
 1 file changed, 58 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/dwc3-st.txt

diff --git a/Documentation/devicetree/bindings/usb/dwc3-st.txt b/Documentation/devicetree/bindings/usb/dwc3-st.txt
new file mode 100644
index 0000000..f14e5da
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/dwc3-st.txt
@@ -0,0 +1,58 @@
+ST DWC3 glue logic
+
+This file documents the parameters for the dwc3-st driver.
+This driver provides the glue logic to use the dwc3 on STiH407 based platforms.
+
+Required properties:
+ - compatible	: must be "st,stih407-dwc3"
+ - reg		: glue logic base address and USB syscfg ctrl register offest
+ - reg-names	: Should be "reg-glue" and "syscfg-reg".
+ - st,syscon    : should be phandle to system configuration node which
+		  encompases the glue registers.
+ - resets       : phandle pointing to the system powerdown controller
+See: Documentation/devicetree/bindings/reset/st,sti-powerdown.txt
+See: Documentation/devicetree/bindings/reset/reset.txt
+
+ - #address-cells, #size-cells : should be '1' if the device has sub-nodes
+                                 with 'reg' property.
+
+ - pinctl-names : A pinctrl state named "default" must be defined.
+See: Documentation/devicetree/bindings/pinctrl/pinctrl-binding.txt.
+
+ - pinctrl-0	: Pin control group
+See: Documentation/devicetree/bindings/pinctrl/pinctrl-binding.txt.
+
+ - ranges: allows valid 1:1 translation between child's address space and
+   parent's address space.
+
+Optional properties:
+ - st,dwc3-drd-device: to program the HC as "device" (static setup)
+
+Sub-nodes:
+The dwc3 core should be added as subnode to ST DWC3 glue as shown in the
+example below. The DT binding details of dwc3 can be found in:
+Documentation/devicetree/bindings/usb/dwc3.txt
+
+Example:
+
+st_dwc3: dwc3@8f94000 {
+	status		= "disabled";
+	compatible	= "st,stih407-dwc3";
+	reg		= <0x08f94000 0x1000>, <0x110 0x4>;
+	reg-names	= "reg-glue", "syscfg-reg";
+	st,syscfg	= <&syscfg_core>;
+	resets          = <&powerdown STIH407_USB3_POWERDOWN>;
+	#address-cells	= <1>;
+	#size-cells	= <1>;
+	pinctrl-names	= "default";
+	pinctrl-0	= <&pinctrl_usb3>;
+	ranges;
+
+	dwc3: dwc3@9900000 {
+		compatible	= "synopsys,dwc3";
+		reg		= <0x09900000 0x100000>;
+		interrupts	=  <GIC_SPI 155 IRQ_TYPE_NONE>;
+
+		usb-phy = <&usb2_phy>, <&usb3_phy>;
+	};
+};
-- 
1.9.1

