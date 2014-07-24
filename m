Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407AbaGXLBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:01:15 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:40070 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732AbaGXLAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:00:46 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        gregkh@linuxfoundation.org, srinivas.kandagatla@gmail.com,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: peter.griffin@linaro.org, lee.jones@linaro.org
Subject: [PATCH v2 2/3] usb: host: st-hcd: Add st-hcd devicetree bindings documentation.
Date: Thu, 24 Jul 2014 12:00:15 +0100
Message-Id: <1406199616-10533-3-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406199616-10533-1-git-send-email-peter.griffin@linaro.org>
References: <1406199616-10533-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents the device tree documentation required for
the ST HCD controller found in STMicroelectronics SoCs.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 Documentation/devicetree/bindings/usb/st-hcd.txt | 49 ++++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/st-hcd.txt

diff --git a/Documentation/devicetree/bindings/usb/st-hcd.txt b/Documentation/devicetree/bindings/usb/st-hcd.txt
new file mode 100644
index 0000000..b963be2
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/st-hcd.txt
@@ -0,0 +1,49 @@
+ST HCD (Host Controller Driver) for USB 2.0 and 1.1
+
+The device node has the following properties.
+
+Required properties:
+ - compatible		: must be "st,usb-300x"
+ - reg			: physical base addresses of the controller and length of memory mapped
+			  region
+ - reg-names		: names associated to the reg defines above, should be "ehci" and "ohci"
+ - interrupts		: interrupt numbers to the cpu
+ - interrupt-names	: should be "ehci" and "ohci"
+
+ - pinctrl-names	: a pinctrl state named "default" must be defined
+-  pinctrl-0		: phandle referencing pin configuration of the USB controller
+See: Documentation/devicetree/bindings/pinctrl/pinctrl-binding.txt
+
+ - clocks		: phandle list of usb clocks.
+ - clock-names		: should be "ic" for interconnect clock and "ohci" for the 48MHz clock
+See: Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+ - resets		: phandle to the powerdown and reset controller for the USB IP
+ - reset-names		: should be "powerdown" and "softreset".
+See: Documentation/devicetree/bindings/reset/st,sti-powerdown.txt
+See: Documentation/devicetree/bindings/reset/reset.txt
+
+Example:
+
+usb0: usb@fe100000 {
+	compatible	= "st,usb-300x";
+	reg		= <0xfe1ffc00 0x100>,
+			  <0xfe1ffe00 0x100>;
+	reg-names	= "ohci", "ehci";
+
+	interrupts	=  <GIC_SPI 148 IRQ_TYPE_NONE>,
+			   <GIC_SPI 149 IRQ_TYPE_NONE>;
+	interrupt-names	= "ehci", "ohci";
+	pinctrl-names	= "default";
+	pinctrl-0	= <&pinctrl_usb0>;
+	clocks		= <&clk_s_a1_ls CLK_ICN_IF_2>,
+			  <&clockgen_b0 0>;
+	clock-names	= "ic", "ohci";
+
+	resets		= <&powerdown STIH416_USB0_POWERDOWN>,
+			  <&softreset STIH416_USB0_SOFTRESET>;
+	reset-names	= "powerdown", "softreset";
+
+	phys		= <&usb2_phy>;
+	phy-names	= "usb2-phy";
+};
-- 
1.9.1

