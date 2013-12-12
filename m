Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab3LLN1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:27:00 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33143 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab3LLN0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:26:38 -0500
From: Matt Porter <mporter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH v5 9/9] ARM: dts: add usb udc support to bcm281xx
Date: Thu, 12 Dec 2013 08:26:10 -0500
Message-Id: <1386854770-2173-10-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386854770-2173-1-git-send-email-mporter@linaro.org>
References: <1386854770-2173-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds USB OTG/PHY and clock support to BCM281xx and enables
UDC support on the bcm11351-brt and bcm28155-ap boards.

Signed-off-by: Matt Porter <mporter@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
---
 arch/arm/boot/dts/bcm11351-brt.dts |  6 ++++++
 arch/arm/boot/dts/bcm11351.dtsi    | 18 ++++++++++++++++++
 arch/arm/boot/dts/bcm28155-ap.dts  |  8 ++++++++
 3 files changed, 32 insertions(+)

diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
index 23cd16d..396b704 100644
--- a/arch/arm/boot/dts/bcm11351-brt.dts
+++ b/arch/arm/boot/dts/bcm11351-brt.dts
@@ -44,5 +44,11 @@
 		status = "okay";
 	};
 
+	usbotg: usb@3f120000 {
+		status = "okay";
+	};
 
+	usbphy: usb-phy@3f130000 {
+		status = "okay";
+	};
 };
diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index 1246885..0fbb455 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -243,4 +243,22 @@
 			#clock-cells = <0>;
 		};
 	};
+
+	usbotg: usb@3f120000 {
+		compatible = "snps,dwc2";
+		reg = <0x3f120000 0x10000>;
+		interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&usb_otg_ahb_clk>;
+		clock-names = "otg";
+		phys = <&usbphy>;
+		phy-names = "usb2-phy";
+		status = "disabled";
+	};
+
+	usbphy: usb-phy@3f130000 {
+		compatible = "brcm,kona-usb2-phy";
+		reg = <0x3f130000 0x28>;
+		#phy-cells = <0>;
+		status = "disabled";
+	};
 };
diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
index 08e47c2..a3bc436 100644
--- a/arch/arm/boot/dts/bcm28155-ap.dts
+++ b/arch/arm/boot/dts/bcm28155-ap.dts
@@ -43,4 +43,12 @@
 		cd-gpios = <&gpio 14 0>;
 		status = "okay";
 	};
+
+	usbotg: usb@3f120000 {
+		status = "okay";
+	};
+
+	usbphy: usb-phy@3f130000 {
+		status = "okay";
+	};
 };
-- 
1.8.4

