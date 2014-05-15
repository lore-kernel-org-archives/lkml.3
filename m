Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaEORwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:52:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34538 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755240AbaEORwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:52:07 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org, Carlo Caione <carlo@caione.org>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [RFC PATCH 3/3] ARM: sunxi: dt: define AXP221 pmic node available on the APP4-EVB1 board
Date: Thu, 15 May 2014 19:51:45 +0200
Message-Id: <1400176305-22737-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400176305-22737-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1400176305-22737-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the AXP221 device node and its regulators for the APP4-EVB1 board.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sun6i-a31-app4-evb1.dts | 83 +++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31-app4-evb1.dts b/arch/arm/boot/dts/sun6i-a31-app4-evb1.dts
index 76f068f..2f4e7ba 100644
--- a/arch/arm/boot/dts/sun6i-a31-app4-evb1.dts
+++ b/arch/arm/boot/dts/sun6i-a31-app4-evb1.dts
@@ -35,6 +35,89 @@
 			status = "okay";
 			#address-cells = <1>;
 			#size-cells = <0>;
+
+			axp221: pmic@68 {
+				compatible = "x-powers,axp221";
+				reg = <0x68>;
+				interrupt-parent = <&nmi_intc>;
+				interrupts = <0 8>;
+
+				interrupt-controller;
+				#interrupt-cells = <1>;
+
+				vin1-supply = <&axp_ipsout_reg>;
+				vin2-supply = <&axp_ipsout_reg>;
+				vin3-supply = <&axp_ipsout_reg>;
+				vin4-supply = <&axp_ipsout_reg>;
+				vin5-supply = <&axp_ipsout_reg>;
+				aldoin-supply = <&axp_ipsout_reg>;
+				dldoin-supply = <&axp_ipsout_reg>;
+				eldoin-supply = <&axp_vcc3v0_reg>;
+				ldoioin-supply = <&axp_ipsout_reg>;
+				rtcldoin-supply = <&axp_ipsout_reg>;
+
+				regulators {
+					compatible = "x-powers,axp22x-reg";
+
+					x-powers,dcdc-freq = <1500>;
+
+					axp_vcc3v0_reg: dcdc1 {
+						regulator-always-on;
+					};
+
+					axp_vdd_gpu_reg: dcdc2 {
+						regulator-always-on;
+					};
+
+					axp_vdd_cpu_reg: dcdc3 {
+						regulator-always-on;
+					};
+
+					axp_vdd_sys_reg: dcdc4 {
+						regulator-always-on;
+					};
+
+					axp_vcc_dram_reg: dcdc5 {
+						regulator-always-on;
+					};
+
+					axp_cpus_vdd_reg: dc5ldo {
+						regulator-always-on;
+					};
+
+					axp_rtc_vcc_reg: rtc_ldo {
+						regulator-always-on;
+					};
+
+					axp_wifi_piog_vcc_reg: aldo1 {
+					};
+
+					axp_io_lpddr2_reg: aldo2 {
+						regulator-always-on;
+					};
+
+					axp_avcc_reg: aldo3 {
+						regulator-always-on;
+					};
+
+					axp_gps_vcc_reg: dldo2 {
+					};
+
+					axp_card_io_vdd_reg: eldo2 {
+					};
+
+					axp_csi_ts_vcc_reg: eldo3 {
+					};
+				};
+			};
 		};
 	};
+
+	axp_ipsout_reg: axp_ipsout {
+		compatible = "regulator-fixed";
+		regulator-name = "axp-ipsout";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		regulator-always-on;
+	};
 };
-- 
1.8.3.2

