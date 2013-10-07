Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab3JGKNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:13:20 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:53042 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab3JGKMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:12:48 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Paul Zimmerman <paulz@synopsys.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH 5/5] ARM: dts: add usb udc support to bcm281xx
Date: Mon,  7 Oct 2013 06:12:32 -0400
Message-Id: <1381140752-312-6-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381140752-312-1-git-send-email-matt.porter@linaro.org>
References: <1381140752-312-1-git-send-email-matt.porter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds USB OTG/Control/PHY and clock support to BCM281xx and enables
UDC support on the bcm11351-brt and bcm28155-ap boards.

Signed-off-by: Matt Porter <matt.porter@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
---
 arch/arm/boot/dts/bcm11351-brt.dts | 10 ++++++++++
 arch/arm/boot/dts/bcm11351.dtsi    | 21 +++++++++++++++++++++
 arch/arm/boot/dts/bcm28155-ap.dts  | 12 ++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
index 9d36eb4..5a269c7 100644
--- a/arch/arm/boot/dts/bcm11351-brt.dts
+++ b/arch/arm/boot/dts/bcm11351-brt.dts
@@ -43,5 +43,15 @@
 		status = "okay";
 	};
 
+	usbotg@3f120000 {
+		status = "okay";
+	};
 
+	usbctl@3f130000 {
+		status = "okay";
+	};
+
+	usbphy {
+		status = "okay";
+	};
 };
diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index 22aef21..1c647f2 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -227,4 +227,25 @@
 			#clock-cells = <0>;
 		};
 	};
+
+	usbotg: usbotg@3f120000 {
+		compatible = "snps,dwc2";
+		reg = <0x3f120000 0x10000>;
+		interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&usb_otg_ahb_clk>;
+		clock-names = "otg";
+		snps,phy-utmi-width = <8>;
+		status = "disabled";
+	};
+
+	usbctl: usbctl@3f130000 {
+		compatible = "brcm,kona-ctrl-usb";
+		reg = <0x3f130000 0x28>;
+		status = "disabled";
+	};
+
+	usbphy: usbphy {
+		compatible = "brcm,kona-usb2";
+		status = "disabled";
+	};
 };
diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
index 96ae67a..7b1b741 100644
--- a/arch/arm/boot/dts/bcm28155-ap.dts
+++ b/arch/arm/boot/dts/bcm28155-ap.dts
@@ -42,4 +42,16 @@
 		max-frequency = <48000000>;
 		status = "okay";
 	};
+
+	usbotg@3f120000 {
+		status = "okay";
+	};
+
+	usbctl@3f130000 {
+		status = "okay";
+	};
+
+	usbphy {
+		status = "okay";
+	};
 };
-- 
1.8.4

