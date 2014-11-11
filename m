Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaKKUsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:48:43 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47272 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaKKUsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:48:41 -0500
From: Olof Johansson <olof@lixom.net>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linux-foundation.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] ARM: dts: tegra: move serial aliases to per-board
Date: Tue, 11 Nov 2014 12:49:30 -0800
Message-Id: <1415738970-7963-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are general changes pending to make the /aliases/serial* entries
number the serial ports on the system. On tegra, so far the ports have been
just numbered dynamically as they are configured so that makes them change.

To avoid this, add specific aliases per board to keep the old numbers. This
allows us to change the numbering by default on future SoCs while keeping the
numbering on existing boards.

Signed-off-by: Olof Johansson <olof@lixom.net>
---

Stephen/Thierry/Alex, as noticed this week we really should try to get
this in before the 3.19 merge window so that the global aliases change
can happen there without regression.

If you have more fixes queued up, feel free to add this to the next pull
request. If not, a review and ack would be appreciated.

 arch/arm/boot/dts/tegra114-dalmore.dts        |    1 +
 arch/arm/boot/dts/tegra114-roth.dts           |    4 ++++
 arch/arm/boot/dts/tegra114-tn7.dts            |    4 ++++
 arch/arm/boot/dts/tegra114.dtsi               |    7 -------
 arch/arm/boot/dts/tegra124-jetson-tk1.dts     |    1 +
 arch/arm/boot/dts/tegra124-nyan-big.dts       |    1 +
 arch/arm/boot/dts/tegra124-venice2.dts        |    1 +
 arch/arm/boot/dts/tegra124.dtsi               |    7 -------
 arch/arm/boot/dts/tegra20-harmony.dts         |    1 +
 arch/arm/boot/dts/tegra20-iris-512.dts        |    5 +++++
 arch/arm/boot/dts/tegra20-medcom-wide.dts     |    4 ++++
 arch/arm/boot/dts/tegra20-paz00.dts           |    2 ++
 arch/arm/boot/dts/tegra20-seaboard.dts        |    1 +
 arch/arm/boot/dts/tegra20-tamonten.dtsi       |    1 +
 arch/arm/boot/dts/tegra20-trimslice.dts       |    1 +
 arch/arm/boot/dts/tegra20-ventana.dts         |    1 +
 arch/arm/boot/dts/tegra20-whistler.dts        |    1 +
 arch/arm/boot/dts/tegra20.dtsi                |    8 --------
 arch/arm/boot/dts/tegra30-apalis-eval.dts     |    4 ++++
 arch/arm/boot/dts/tegra30-beaver.dts          |    1 +
 arch/arm/boot/dts/tegra30-cardhu.dtsi         |    2 ++
 arch/arm/boot/dts/tegra30-colibri-eval-v3.dts |    3 +++
 arch/arm/boot/dts/tegra30.dtsi                |    8 --------
 23 files changed, 39 insertions(+), 30 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index 5c21d21..8b7aa0d 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -15,6 +15,7 @@
 	aliases {
 		rtc0 = "/i2c@7000d000/tps65913@58";
 		rtc1 = "/rtc@7000e000";
+		serial0 = &uartd;
 	};
 
 	memory {
diff --git a/arch/arm/boot/dts/tegra114-roth.dts b/arch/arm/boot/dts/tegra114-roth.dts
index c7c6825..a80f1e2 100644
--- a/arch/arm/boot/dts/tegra114-roth.dts
+++ b/arch/arm/boot/dts/tegra114-roth.dts
@@ -15,6 +15,10 @@
 		linux,initrd-end = <0x82800000>;
 	};
 
+	aliases {
+		serial0 = &uartd;
+	};
+
 	firmware {
 		trusted-foundations {
 			compatible = "tlm,trusted-foundations";
diff --git a/arch/arm/boot/dts/tegra114-tn7.dts b/arch/arm/boot/dts/tegra114-tn7.dts
index 9636621..2301c66 100644
--- a/arch/arm/boot/dts/tegra114-tn7.dts
+++ b/arch/arm/boot/dts/tegra114-tn7.dts
@@ -15,6 +15,10 @@
 		linux,initrd-end = <0x82800000>;
 	};
 
+	aliases {
+		serial0 = &uartd;
+	};
+
 	firmware {
 		trusted-foundations {
 			compatible = "tlm,trusted-foundations";
diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index 2ca9c18..222f3b3 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -9,13 +9,6 @@
 	compatible = "nvidia,tegra114";
 	interrupt-parent = <&gic>;
 
-	aliases {
-		serial0 = &uarta;
-		serial1 = &uartb;
-		serial2 = &uartc;
-		serial3 = &uartd;
-	};
-
 	host1x@50000000 {
 		compatible = "nvidia,tegra114-host1x", "simple-bus";
 		reg = <0x50000000 0x00028000>;
diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index f46a789..4eb540b 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -10,6 +10,7 @@
 	aliases {
 		rtc0 = "/i2c@0,7000d000/pmic@40";
 		rtc1 = "/rtc@0,7000e000";
+		serial0 = &uartd;
 	};
 
 	memory {
diff --git a/arch/arm/boot/dts/tegra124-nyan-big.dts b/arch/arm/boot/dts/tegra124-nyan-big.dts
index 7d0784c..53181d3 100644
--- a/arch/arm/boot/dts/tegra124-nyan-big.dts
+++ b/arch/arm/boot/dts/tegra124-nyan-big.dts
@@ -10,6 +10,7 @@
 	aliases {
 		rtc0 = "/i2c@0,7000d000/pmic@40";
 		rtc1 = "/rtc@0,7000e000";
+		serial0 = &uarta;
 	};
 
 	memory {
diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index 1300885..5c3f781 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -10,6 +10,7 @@
 	aliases {
 		rtc0 = "/i2c@0,7000d000/pmic@40";
 		rtc1 = "/rtc@0,7000e000";
+		serial0 = &uarta;
 	};
 
 	memory {
diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index f765110..dde226e 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -13,13 +13,6 @@
 	#address-cells = <2>;
 	#size-cells = <2>;
 
-	aliases {
-		serial0 = &uarta;
-		serial1 = &uartb;
-		serial2 = &uartc;
-		serial3 = &uartd;
-	};
-
 	pcie-controller@0,01003000 {
 		compatible = "nvidia,tegra124-pcie";
 		device_type = "pci";
diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index a37279a..b926a07 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -10,6 +10,7 @@
 	aliases {
 		rtc0 = "/i2c@7000d000/tps6586x@34";
 		rtc1 = "/rtc@7000e000";
+		serial0 = &uartd;
 	};
 
 	memory {
diff --git a/arch/arm/boot/dts/tegra20-iris-512.dts b/arch/arm/boot/dts/tegra20-iris-512.dts
index 8cfb83f..1dd7d7b 100644
--- a/arch/arm/boot/dts/tegra20-iris-512.dts
+++ b/arch/arm/boot/dts/tegra20-iris-512.dts
@@ -6,6 +6,11 @@
 	model = "Toradex Colibri T20 512MB on Iris";
 	compatible = "toradex,iris", "toradex,colibri_t20-512", "nvidia,tegra20";
 
+	aliases {
+		serial0 = &uarta;
+		serial1 = &uartd;
+	};
+
 	host1x@50000000 {
 		hdmi@54280000 {
 			status = "okay";
diff --git a/arch/arm/boot/dts/tegra20-medcom-wide.dts b/arch/arm/boot/dts/tegra20-medcom-wide.dts
index 1b7c56b..9b87526 100644
--- a/arch/arm/boot/dts/tegra20-medcom-wide.dts
+++ b/arch/arm/boot/dts/tegra20-medcom-wide.dts
@@ -6,6 +6,10 @@
 	model = "Avionic Design Medcom-Wide board";
 	compatible = "ad,medcom-wide", "ad,tamonten", "nvidia,tegra20";
 
+	aliases {
+		serial0 = &uartd;
+	};
+
 	pwm@7000a000 {
 		status = "okay";
 	};
diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index d4438e3..ed7e100 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -10,6 +10,8 @@
 	aliases {
 		rtc0 = "/i2c@7000d000/tps6586x@34";
 		rtc1 = "/rtc@7000e000";
+		serial0 = &uarta;
+		serial1 = &uartc;
 	};
 
 	memory {
diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index a1d4bf9..ea282c7 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -10,6 +10,7 @@
 	aliases {
 		rtc0 = "/i2c@7000d000/tps6586x@34";
 		rtc1 = "/rtc@7000e000";
+		serial0 = &uartd;
 	};
 
 	memory {
diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index 80e7d38..13d4e61 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -7,6 +7,7 @@
 	aliases {
 		rtc0 = "/i2c@7000d000/tps6586x@34";
 		rtc1 = "/rtc@7000e000";
+		serial0 = &uartd;
 	};
 
 	memory {
diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
index 5ad8797..d99af4e 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -10,6 +10,7 @@
 	aliases {
 		rtc0 = "/i2c@7000c500/rtc@56";
 		rtc1 = "/rtc@7000e000";
+		serial0 = &uarta;
 	};
 
 	memory {
diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index ca8484c..04c58e9 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -10,6 +10,7 @@
 	aliases {
 		rtc0 = "/i2c@7000d000/tps6586x@34";
 		rtc1 = "/rtc@7000e000";
+		serial0 = &uartd;
 	};
 
 	memory {
diff --git a/arch/arm/boot/dts/tegra20-whistler.dts b/arch/arm/boot/dts/tegra20-whistler.dts
index 1843725..340d811 100644
--- a/arch/arm/boot/dts/tegra20-whistler.dts
+++ b/arch/arm/boot/dts/tegra20-whistler.dts
@@ -10,6 +10,7 @@
 	aliases {
 		rtc0 = "/i2c@7000d000/max8907@3c";
 		rtc1 = "/rtc@7000e000";
+		serial0 = &uarta;
 	};
 
 	memory {
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 3b374c4..8acf5d8 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -9,14 +9,6 @@
 	compatible = "nvidia,tegra20";
 	interrupt-parent = <&intc>;
 
-	aliases {
-		serial0 = &uarta;
-		serial1 = &uartb;
-		serial2 = &uartc;
-		serial3 = &uartd;
-		serial4 = &uarte;
-	};
-
 	host1x@50000000 {
 		compatible = "nvidia,tegra20-host1x", "simple-bus";
 		reg = <0x50000000 0x00024000>;
diff --git a/arch/arm/boot/dts/tegra30-apalis-eval.dts b/arch/arm/boot/dts/tegra30-apalis-eval.dts
index 45d40f0..6236bde 100644
--- a/arch/arm/boot/dts/tegra30-apalis-eval.dts
+++ b/arch/arm/boot/dts/tegra30-apalis-eval.dts
@@ -11,6 +11,10 @@
 		rtc0 = "/i2c@7000c000/rtc@68";
 		rtc1 = "/i2c@7000d000/tps65911@2d";
 		rtc2 = "/rtc@7000e000";
+		serial0 = &uarta;
+		serial1 = &uartb;
+		serial2 = &uartc;
+		serial3 = &uartd;
 	};
 
 	pcie-controller@00003000 {
diff --git a/arch/arm/boot/dts/tegra30-beaver.dts b/arch/arm/boot/dts/tegra30-beaver.dts
index cee8f22..6b157ee 100644
--- a/arch/arm/boot/dts/tegra30-beaver.dts
+++ b/arch/arm/boot/dts/tegra30-beaver.dts
@@ -9,6 +9,7 @@
 	aliases {
 		rtc0 = "/i2c@7000d000/tps65911@2d";
 		rtc1 = "/rtc@7000e000";
+		serial0 = &uarta;
 	};
 
 	memory {
diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index 2063795..a1b682e 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -30,6 +30,8 @@
 	aliases {
 		rtc0 = "/i2c@7000d000/tps65911@2d";
 		rtc1 = "/rtc@7000e000";
+		serial0 = &uarta;
+		serial1 = &uartc;
 	};
 
 	memory {
diff --git a/arch/arm/boot/dts/tegra30-colibri-eval-v3.dts b/arch/arm/boot/dts/tegra30-colibri-eval-v3.dts
index 7793abd..4d3ddc5 100644
--- a/arch/arm/boot/dts/tegra30-colibri-eval-v3.dts
+++ b/arch/arm/boot/dts/tegra30-colibri-eval-v3.dts
@@ -10,6 +10,9 @@
 		rtc0 = "/i2c@7000c000/rtc@68";
 		rtc1 = "/i2c@7000d000/tps65911@2d";
 		rtc2 = "/rtc@7000e000";
+		serial0 = &uarta;
+		serial1 = &uartb;
+		serial2 = &uartd;
 	};
 
 	host1x@50000000 {
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index aa6ccea..b270b9e 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -9,14 +9,6 @@
 	compatible = "nvidia,tegra30";
 	interrupt-parent = <&intc>;
 
-	aliases {
-		serial0 = &uarta;
-		serial1 = &uartb;
-		serial2 = &uartc;
-		serial3 = &uartd;
-		serial4 = &uarte;
-	};
-
 	pcie-controller@00003000 {
 		compatible = "nvidia,tegra30-pcie";
 		device_type = "pci";
-- 
1.7.10.4

