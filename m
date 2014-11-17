Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaKQNgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:36:11 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48721 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752953AbaKQNgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:36:04 -0500
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 09/13] Documentation: bindings: add doc for the USB2 ChipIdea USB driver
Date: Mon, 17 Nov 2014 14:35:43 +0100
Message-Id: <1416231347-27193-10-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416231347-27193-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1416231347-27193-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the USB2 ChipIdea driver (ci13xxx) bindings.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Acked-by: Peter Chen <peter.chen@freescale.com>
---
 .../devicetree/bindings/usb/ci-hdrc-usb2.txt       | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt

diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
new file mode 100644
index 000000000000..27f8b1e5ee46
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
@@ -0,0 +1,24 @@
+* USB2 ChipIdea USB controller for ci13xxx
+
+Required properties:
+- compatible: should be "chipidea,usb2"
+- reg: base address and length of the registers
+- interrupts: interrupt for the USB controller
+
+Optional properties:
+- clocks: reference to the USB clock
+- phys: reference to the USB PHY
+- phy-names: should be "usb-phy"
+- vbus-supply: reference to the VBUS regulator
+
+Example:
+
+	usb@f7ed0000 {
+		compatible = "chipidea,usb2";
+		reg = <0xf7ed0000 0x10000>;
+		interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&chip CLKID_USB0>;
+		phys = <&usb_phy0>;
+		phy-names = "usb-phy";
+		vbus-supply = <&reg_usb0_vbus>;
+	};
-- 
2.1.0

