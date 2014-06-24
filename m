Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbaFXKfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:35:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54313 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753633AbaFXKfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:35:30 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/12] Documentation: bindings: add doc for the generic ChipIdea USB driver
Date: Tue, 24 Jun 2014 12:35:17 +0200
Message-Id: <1403606121-6368-9-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the generic ChipIdea USB driver bindings.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 .../devicetree/bindings/usb/ci-hdrc-generic.txt    | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-generic.txt

diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-generic.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-generic.txt
new file mode 100644
index 000000000000..4c85f9944077
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/ci-hdrc-generic.txt
@@ -0,0 +1,22 @@
+* Generic ChipIdea USB controller
+
+Required properties:
+- compatible: should be "chipidea-usb"
+- reg: base address and length of the registers
+- interrupts: interrupt for the USB controller
+
+Optional properties:
+- clocks: reference to the USB clock
+- usb-phy: reference to the USB PHY
+- vbus-supply: reference to the VBUS regulator
+
+Example:
+
+	usb@f7ed0000 {
+		compatible = "chipidea-usb";
+		reg = <0xf7ed0000 0x10000>;
+		interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&chip CLKID_USB0>;
+		usb-phy = <&usb_phy0>;
+		vbus-supply = <&reg_usb0_vbus>;
+	};
-- 
1.9.1

