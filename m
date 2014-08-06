Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbaHFRDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:03:36 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53835 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609AbaHFRDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:03:31 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH v3 5/6] usb: host: ohci-st: Add ohci-st devicetree bindings documentation
Date: Wed,  6 Aug 2014 18:03:08 +0100
Message-Id: <1407344589-24863-6-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407344589-24863-1-git-send-email-peter.griffin@linaro.org>
References: <1407344589-24863-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents the device tree bindings required for
the ohci on-chip controller found in ST consumer electronics SoC's.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 Documentation/devicetree/bindings/usb/ohci-st.txt | 40 +++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/ohci-st.txt

diff --git a/Documentation/devicetree/bindings/usb/ohci-st.txt b/Documentation/devicetree/bindings/usb/ohci-st.txt
new file mode 100644
index 0000000..17181c5
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ohci-st.txt
@@ -0,0 +1,40 @@
+ST USB OHCI controller
+
+Required properties:
+
+ - compatible		: must be "st,st-ohci-300x"
+ - reg			: physical base addresses of the controller and length of memory mapped
+			  region
+ - interrupts		: one OHCI controller interrupt should be described here
+
+Optional properties:
+
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
+		compatible = "st,ohci-platform";
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

