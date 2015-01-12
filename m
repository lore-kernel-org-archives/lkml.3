Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbbALTDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:03:37 -0500
Received: from down.free-electrons.com ([37.187.137.238]:56952 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756513AbbALTCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:02:05 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 4/6] ARM: at91/dt: add SRAM nodes
Date: Mon, 12 Jan 2015 20:01:55 +0100
Message-Id: <1421089317-12607-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421089317-12607-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421089317-12607-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nodes for the SRAM available on atmel SoCs

Remove leftover TODOs in the sam9g45 file

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91rm9200.dtsi  |  5 +++++
 arch/arm/boot/dts/at91sam9260.dtsi |  5 +++++
 arch/arm/boot/dts/at91sam9261.dtsi |  5 +++++
 arch/arm/boot/dts/at91sam9263.dtsi | 10 ++++++++++
 arch/arm/boot/dts/at91sam9g20.dtsi |  9 +++++++++
 arch/arm/boot/dts/at91sam9g45.dtsi |  7 +++++--
 arch/arm/boot/dts/at91sam9n12.dtsi |  5 +++++
 arch/arm/boot/dts/at91sam9rl.dtsi  |  5 +++++
 arch/arm/boot/dts/at91sam9x5.dtsi  |  5 +++++
 arch/arm/boot/dts/sama5d3.dtsi     |  5 +++++
 arch/arm/boot/dts/sama5d4.dtsi     |  5 +++++
 11 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
index f449a864b81e..21c2b504f977 100644
--- a/arch/arm/boot/dts/at91rm9200.dtsi
+++ b/arch/arm/boot/dts/at91rm9200.dtsi
@@ -66,6 +66,11 @@
 		};
 	};
 
+	sram: sram@00200000 {
+		compatible = "mmio-sram";
+		reg = <0x00200000 0x4000>;
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index dd1313cbc314..6f52cb2eacd8 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -69,6 +69,11 @@
 		};
 	};
 
+	sram0: sram@002ff000 {
+		compatible = "mmio-sram";
+		reg = <0x00200000 0x2000>;
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
index cdb9ed612109..e247b0b5fdab 100644
--- a/arch/arm/boot/dts/at91sam9261.dtsi
+++ b/arch/arm/boot/dts/at91sam9261.dtsi
@@ -60,6 +60,11 @@
 		};
 	};
 
+	sram: sram@00300000 {
+		compatible = "mmio-sram";
+		reg = <0x00300000 0x28000>;
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index ef8a70c27439..8a210d5033b1 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -62,6 +62,16 @@
 		};
 	};
 
+	sram0: sram@00300000 {
+		compatible = "mmio-sram";
+		reg = <0x00300000 0x14000>;
+	};
+
+	sram1: sram@00500000 {
+		compatible = "mmio-sram";
+		reg = <0x00300000 0x4000>;
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
diff --git a/arch/arm/boot/dts/at91sam9g20.dtsi b/arch/arm/boot/dts/at91sam9g20.dtsi
index a50ee587a7af..9012fe9d7758 100644
--- a/arch/arm/boot/dts/at91sam9g20.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20.dtsi
@@ -16,6 +16,15 @@
 		reg = <0x20000000 0x08000000>;
 	};
 
+	sram0: sram@002ff000 {
+		status = "disabled";
+	};
+
+	sram1: sram@002fc000 {
+		compatible = "mmio-sram";
+		reg = <0x00200000 0x8000>;
+	};
+
 	ahb {
 		apb {
 			i2c0: i2c@fffac000 {
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index 2a8da8a884b4..ee80aa9c0759 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -74,6 +74,11 @@
 		};
 	};
 
+	sram: sram@00300000 {
+		compatible = "mmio-sram";
+		reg = <0x00300000 0x10000>;
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -1287,7 +1292,6 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00700000 0x100000>;
 			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
-			//TODO
 			clocks = <&usb>, <&uhphs_clk>, <&uhphs_clk>, <&uhpck>;
 			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
@@ -1297,7 +1301,6 @@
 			compatible = "atmel,at91sam9g45-ehci", "usb-ehci";
 			reg = <0x00800000 0x100000>;
 			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
-			//TODO
 			clocks = <&usb>, <&uhphs_clk>, <&uhphs_clk>, <&uhpck>;
 			clock-names = "usb_clk", "ehci_clk", "hclk", "uhpck";
 			status = "disabled";
diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index a7218bcc6a25..6ea7ee3b8ff8 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -64,6 +64,11 @@
 		};
 	};
 
+	sram: sram@00300000 {
+		compatible = "mmio-sram";
+		reg = <0x00300000 0x8000>;
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
index 72424371413e..c055da2f151f 100644
--- a/arch/arm/boot/dts/at91sam9rl.dtsi
+++ b/arch/arm/boot/dts/at91sam9rl.dtsi
@@ -70,6 +70,11 @@
 		};
 	};
 
+	sram: sram@00300000 {
+		compatible = "mmio-sram";
+		reg = <0x00300000 0x4000>;
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index bbb3ba65165f..818dabdd8c0e 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -72,6 +72,11 @@
 		};
 	};
 
+	sram: sram@00300000 {
+		compatible = "mmio-sram";
+		reg = <0x00300000 0x8000>;
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index d701ddda0e00..e17614fe58a9 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -78,6 +78,11 @@
 		};
 	};
 
+	sram: sram@00300000 {
+		compatible = "mmio-sram";
+		reg = <0x00300000 0x20000>;
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
diff --git a/arch/arm/boot/dts/sama5d4.dtsi b/arch/arm/boot/dts/sama5d4.dtsi
index 0a2477fe5525..1b4fe4e19721 100644
--- a/arch/arm/boot/dts/sama5d4.dtsi
+++ b/arch/arm/boot/dts/sama5d4.dtsi
@@ -103,6 +103,11 @@
 		};
 	};
 
+	ns_sram: sram@00210000 {
+		compatible = "mmio-sram";
+		reg = <0x00210000 0x10000>;
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
-- 
2.1.0

