Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaIOKgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:36:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36932 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753989AbaIOKg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:36:27 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 08/12] Documentation: bindings: add doc for the USB2 ChipIdea USB driver
Date: Mon, 15 Sep 2014 12:36:14 +0200
Message-Id: <1410777378-12726-9-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410777378-12726-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1410777378-12726-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the USB2 ChipIdea driver (ci13xxx) bindings.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 .../devicetree/bindings/usb/ci-hdrc-usb2.txt       | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt

diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
new file mode 100644
index 000000000000..8dd6d8285dab
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
@@ -0,0 +1,22 @@
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
+		vbus-supply = <&reg_usb0_vbus>;
+	};
-- 
1.9.1

