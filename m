Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbaHGPWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:22:32 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:55186 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbaHGPW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:22:29 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v4 4/5] usb: host: ohci-st: Add ohci-st devicetree bindings documentation
Date: Thu,  7 Aug 2014 16:21:43 +0100
Message-Id: <1407424904-19251-5-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407424904-19251-1-git-send-email-peter.griffin@linaro.org>
References: <1407424904-19251-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents the device tree bindings required for
the ohci on-chip controller found in ST consumer electronics SoC's.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 Documentation/devicetree/bindings/usb/ohci-st.txt | 37 +++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/ohci-st.txt

diff --git a/Documentation/devicetree/bindings/usb/ohci-st.txt b/Documentation/devicetree/bindings/usb/ohci-st.txt
new file mode 100644
index 0000000..6d83937
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ohci-st.txt
@@ -0,0 +1,37 @@
+ST USB OHCI controller
+
+Required properties:
+
+ - compatible		: must be "st,st-ohci-300x"
+ - reg			: physical base addresses of the controller and length of memory mapped
+			  region
+ - interrupts		: one OHCI controller interrupt should be described here
+ - clocks		: phandle list of usb clocks
+ - clock-names		: should be "ic" for interconnect clock and "clk48"
+See: Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+ - phys			: phandle for the PHY device
+ - phy-names		: should be "usb"
+
+ - resets		: phandle to the powerdown and reset controller for the USB IP
+ - reset-names		: should be "power" and "softreset".
+See: Documentation/devicetree/bindings/reset/st,sti-powerdown.txt
+See: Documentation/devicetree/bindings/reset/reset.txt
+
+Example:
+
+	ohci0: usb@0xfe1ffc00 {
+		compatible = "st,st-ohci-300x";
+		reg = <0xfe1ffc00 0x100>;
+		interrupts = <GIC_SPI 149 IRQ_TYPE_NONE>;
+		clocks = <&clk_s_a1_ls 0>,
+			 <&clockgen_b0 0>;
+		clock-names = "ic", "clk48";
+		phys = <&usb2_phy>;
+		phy-names = "usb";
+		status = "okay";
+
+		resets = <&powerdown STIH416_USB0_POWERDOWN>,
+			 <&softreset STIH416_USB0_SOFTRESET>;
+		reset-names = "power", "softreset";
+	};
-- 
1.9.1

