Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab3FJG0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 02:26:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41691 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3FJGZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 02:25:53 -0400
From: J Keerthy <j-keerthy@ti.com>
To: <b-cousson@ti.com>, <devicetree-discuss@lists.ozlabs.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldewangan@nvidia.com>, <grant.likely@secretlab.ca>,
        <swarren@wwwdotorg.org>, <swarren@nvidia.com>, <sameo@linux.intel.com>,
        <gg@slimlogic.co.uk>, <lee.jones@linaro.org>,
        J Keerthy <j-keerthy@ti.com>
Subject: [PATCH 2/2] ARM: dts: OMAP5: add palmas node and omap specific palmas regulator properties
Date: Mon, 10 Jun 2013 11:52:15 +0530
Message-ID: <1370845335-14926-3-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1370845335-14926-1-git-send-email-j-keerthy@ti.com>
References: <1370845335-14926-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add palmas node and omap specific palmas regulator properties.

This patch is based on:

	git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git
	for_3.11/dts

Boot tested on omap5-uevm board.

Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 arch/arm/boot/dts/omap5-uevm.dts |  145 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 145 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index 927db1e..88172db 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -254,6 +254,151 @@
 	pinctrl-0 = <&i2c1_pins>;
 
 	clock-frequency = <400000>;
+
+	palmas: palmas@48 {
+		reg = <0x48>;
+		/* SPI = 0, IRQ# = 7, 4 = active high level-sensitive */
+		interrupts = <0 7 4>; /* IRQ_SYS_1N cascaded to gic */
+		interrupt-parent = <&gic>;
+	};
+
+};
+
+#include "palmas.dtsi"
+
+&palmas {
+	palmas_pmic {
+		ti,ldo6-vibrator;
+
+		regulators {
+			smps123_reg: smps123 {
+				regulator-min-microvolt = < 600000>;
+				regulator-max-microvolt = <1500000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			smps45_reg: smps45 {
+				regulator-min-microvolt = < 600000>;
+				regulator-max-microvolt = <1310000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			smps6_reg: smps6 {
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			smps7_reg: smps7 {
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			smps8_reg: smps8 {
+				regulator-min-microvolt = < 600000>;
+				regulator-max-microvolt = <1310000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			smps9_reg: smps9 {
+				regulator-min-microvolt = <2100000>;
+				regulator-max-microvolt = <2100000>;
+				regulator-always-on;
+				regulator-boot-on;
+				ti,smps-range = <0x80>;
+			};
+
+			smps10_reg: smps10 {
+				regulator-min-microvolt = <5000000>;
+				regulator-max-microvolt = <5000000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			ldo1_reg: ldo1 {
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			ldo2_reg: ldo2 {
+				regulator-min-microvolt = <2900000>;
+				regulator-max-microvolt = <2900000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			ldo3_reg: ldo3 {
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3000000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			ldo4_reg: ldo4 {
+				regulator-min-microvolt = <2200000>;
+				regulator-max-microvolt = <2200000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			ldo5_reg: ldo5 {
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			ldo6_reg: ldo6 {
+				regulator-min-microvolt = <1500000>;
+				regulator-max-microvolt = <1500000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			ldo7_reg: ldo7 {
+				regulator-min-microvolt = <1500000>;
+				regulator-max-microvolt = <1500000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			ldo8_reg: ldo8 {
+				regulator-min-microvolt = <1500000>;
+				regulator-max-microvolt = <1500000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			ldo9_reg: ldo9 {
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			ldoln_reg: ldoln {
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+
+			ldousb_reg: ldousb {
+				regulator-min-microvolt = <3250000>;
+				regulator-max-microvolt = <3250000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+		};
+	};
 };
 
 &i2c5 {
-- 
1.7.5.4

