Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbbAMOX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:23:57 -0500
Received: from down.free-electrons.com ([37.187.137.238]:34303 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751423AbbAMOXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:23:30 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: [PATCH v3 4/4] ARM: mvebu: Armada 385 GP: Add regulators to the SATA port
Date: Tue, 13 Jan 2015 15:22:33 +0100
Message-Id: <1421158953-2957-5-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421158953-2957-1-git-send-email-gregory.clement@free-electrons.com>
References: <1421158953-2957-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the regulators to each SATA port.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/armada-388-gp.dts | 126 ++++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/arch/arm/boot/dts/armada-388-gp.dts b/arch/arm/boot/dts/armada-388-gp.dts
index 4df22bf91683..590b383db323 100644
--- a/arch/arm/boot/dts/armada-388-gp.dts
+++ b/arch/arm/boot/dts/armada-388-gp.dts
@@ -173,6 +173,16 @@
 				status = "okay";
 				#address-cells = <1>;
 				#size-cells = <0>;
+
+				sata0: sata-port@0 {
+					reg = <0>;
+					target-supply = <&reg_5v_sata0>;
+				};
+
+				sata1: sata-port@1 {
+					reg = <1>;
+					target-supply = <&reg_5v_sata1>;
+				};
 			};
 
 			sata@e0000 {
@@ -181,6 +191,16 @@
 				status = "okay";
 				#address-cells = <1>;
 				#size-cells = <0>;
+
+				sata2: sata-port@0 {
+					reg = <0>;
+					target-supply = <&reg_5v_sata2>;
+				};
+
+				sata3: sata-port@1 {
+					reg = <1>;
+					target-supply = <&reg_5v_sata3>;
+				};
 			};
 
 			sdhci@d8000 {
@@ -278,6 +298,112 @@
 		regulator-always-on;
 		gpio = <&expander0 4 GPIO_ACTIVE_HIGH>;
 	};
+
+	reg_sata0: pwr-sata0 {
+		compatible = "regulator-fixed";
+		regulator-name = "pwr_en_sata0";
+		enable-active-high;
+		regulator-always-on;
+
+	};
+
+	reg_5v_sata0: v5-sata0 {
+		compatible = "regulator-fixed";
+		regulator-name = "v5.0-sata0";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		regulator-always-on;
+		vin-supply = <&reg_sata0>;
+	};
+
+	reg_12v_sata0: v12-sata0 {
+		compatible = "regulator-fixed";
+		regulator-name = "v12.0-sata0";
+		regulator-min-microvolt = <12000000>;
+		regulator-max-microvolt = <12000000>;
+		regulator-always-on;
+		vin-supply = <&reg_sata0>;
+	};
+
+	reg_sata1: pwr-sata1 {
+		regulator-name = "pwr_en_sata1";
+		compatible = "regulator-fixed";
+		regulator-min-microvolt = <12000000>;
+		regulator-max-microvolt = <12000000>;
+		enable-active-high;
+		regulator-always-on;
+		gpio = <&expander0 3 GPIO_ACTIVE_HIGH>;
+	};
+
+	reg_5v_sata1: v5-sata1 {
+		compatible = "regulator-fixed";
+		regulator-name = "v5.0-sata1";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		regulator-always-on;
+		vin-supply = <&reg_sata1>;
+	};
+
+	reg_12v_sata1: v12-sata1 {
+		compatible = "regulator-fixed";
+		regulator-name = "v12.0-sata1";
+		regulator-min-microvolt = <12000000>;
+		regulator-max-microvolt = <12000000>;
+		regulator-always-on;
+		vin-supply = <&reg_sata1>;
+	};
+
+	reg_sata2: pwr-sata2 {
+		compatible = "regulator-fixed";
+		regulator-name = "pwr_en_sata2";
+		enable-active-high;
+		regulator-always-on;
+		gpio = <&expander0 11 GPIO_ACTIVE_HIGH>;
+	};
+
+	reg_5v_sata2: v5-sata2 {
+		compatible = "regulator-fixed";
+		regulator-name = "v5.0-sata2";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		regulator-always-on;
+		vin-supply = <&reg_sata2>;
+	};
+
+	reg_12v_sata2: v12-sata2 {
+		compatible = "regulator-fixed";
+		regulator-name = "v12.0-sata2";
+		regulator-min-microvolt = <12000000>;
+		regulator-max-microvolt = <12000000>;
+		regulator-always-on;
+		vin-supply = <&reg_sata2>;
+	};
+
+	reg_sata3: pwr-sata3 {
+		compatible = "regulator-fixed";
+		regulator-name = "pwr_en_sata3";
+		enable-active-high;
+		regulator-always-on;
+		gpio = <&expander0 12 GPIO_ACTIVE_HIGH>;
+	};
+
+	reg_5v_sata3: v5-sata3 {
+		compatible = "regulator-fixed";
+		regulator-name = "v5.0-sata3";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		regulator-always-on;
+		vin-supply = <&reg_sata3>;
+	};
+
+	reg_12v_sata3: v12-sata3 {
+		compatible = "regulator-fixed";
+		regulator-name = "v12.0-sata3";
+		regulator-min-microvolt = <12000000>;
+		regulator-max-microvolt = <12000000>;
+		regulator-always-on;
+		vin-supply = <&reg_sata3>;
+	};
 };
 
 &pinctrl {
-- 
1.9.1

