Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbaHGPWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:22:30 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:35206 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbaHGPW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:22:28 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v4 3/5] usb: host: ehci-st: Add ehci-st devicetree bindings documentation
Date: Thu,  7 Aug 2014 16:21:42 +0100
Message-Id: <1407424904-19251-4-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407424904-19251-1-git-send-email-peter.griffin@linaro.org>
References: <1407424904-19251-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents the device tree bindings required for the
ehci on-chip controller found in ST consumer electronics SoC's.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 Documentation/devicetree/bindings/usb/ehci-st.txt | 39 +++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/ehci-st.txt

diff --git a/Documentation/devicetree/bindings/usb/ehci-st.txt b/Documentation/devicetree/bindings/usb/ehci-st.txt
new file mode 100644
index 0000000..fb45fa5
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ehci-st.txt
@@ -0,0 +1,39 @@
+ST USB EHCI controller
+
+Required properties:
+ - compatible		: must be "st,st-ehci-300x"
+ - reg			: physical base addresses of the controller and length of memory mapped
+			  region
+ - interrupts		: one EHCI interrupt should be described here
+ - pinctrl-names	: a pinctrl state named "default" must be defined
+ - pinctrl-0		: phandle referencing pin configuration of the USB controller
+See: Documentation/devicetree/bindings/pinctrl/pinctrl-binding.txt
+ - clocks		: phandle list of usb clocks
+ - clock-names		: should be "ic" for interconnect clock and "clk48"
+See: Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+ - phys			: phandle for the PHY device
+ - phy-names		: should be "usb"
+ - resets		: phandle + reset specifier pairs to the powerdown and softreset lines
+			  of the USB IP
+ - reset-names		: should be "power" and "softreset"
+See: Documentation/devicetree/bindings/reset/st,sti-powerdown.txt
+See: Documentation/devicetree/bindings/reset/reset.txt
+
+Example:
+
+	ehci1: usb@0xfe203e00 {
+		compatible = "st,st-ehci-300x";
+		reg = <0xfe203e00 0x100>;
+		interrupts = <GIC_SPI 148 IRQ_TYPE_NONE>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_usb1>;
+		clocks = <&clk_s_a1_ls 0>;
+		phys = <&usb2_phy>;
+		phy-names = "usb";
+		status = "okay";
+
+		resets = <&powerdown STIH416_USB1_POWERDOWN>,
+			 <&softreset STIH416_USB1_SOFTRESET>;
+		reset-names = "power", "softreset";
+	};
-- 
1.9.1

