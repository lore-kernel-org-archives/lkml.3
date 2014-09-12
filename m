Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbaILMDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:03:18 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39326 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbaILMDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:03:16 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-65-5412e101ccac
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: dts: Add Maxim 77693 PMIC to the Trats2 board
Date: Fri, 12 Sep 2014 14:03:06 +0200
Message-id: <1410523386-10581-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t/xa7qMD4VCDHr281tsnLGe1WLSugNM
	FvOPnGO16H+zkNXi3KuVjBavXxha9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LdYe
	uctusfT6RSaLCdPXsli07j3CbrFq1x9GB0GPNfPWMHq0NPeweVzu62Xy+LvqBbPHzll32T1W
	Lv/C5rFpVSebx+Yl9R59W1YxenzeJBfAFcVlk5Kak1mWWqRvl8CVcadrIVvBCYGKiS93MzYw
	NvN2MXJySAiYSPyZNp0JwhaTuHBvPVsXIxeHkMBSRok9f7czQzh9TBL3lr9hB6liEzCW2Lx8
	CViViMA2Zol1jb8YQRxmgTeMEr17JrKAVAkLOEs8OHQarINFQFXi1oKlYDavgLvExPer2CD2
	yUmcPDaZdQIj9wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIaH7ZQfj4mNWhxgFOBiV
	eHg5zgmGCLEmlhVX5h5ilOBgVhLh3XVHKESINyWxsiq1KD++qDQntfgQIxMHp1QDo63c3Q1R
	VTqRgWlbjK0e3V/x6fr9WcnSf9ysVObvnae68+q7cMbVET1br7J+TxLuFmfVavhzfypDSYu6
	3KtQlk2/1zssSJMMEbMSvKDVuknQpN43ZeFD759nyiK/tiVOzfi2S0v10wEBm2eRLCeYt9UL
	RBpZZK5I55tUkflQlnOb/vTJ+tx8SizFGYmGWsxFxYkANhgKSzsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX77693 is a companion power management IC for smart phones and tablets.

The MAX77693 contains input over-voltage protection (OVP),
a fully-integrated 2.5A switching charger for Lithium Ion battery with
integrated battery disconnect, OTG/accessory 5V output power,
a high-current white LED driver for camera flash, two safeout LDOs,
a haptic motor driver, Model Gauge m3 battery fuel gauge and MicroUSB
Interface Controller (MUIC). I2C serial interface is used for
communicating.

Add MAX77693 node to the Trats2 board. This allows using:
 - charger regulator,
 - 2 safeout LDO regulators (for USB OTG),
 - extcon.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 34 +++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 11967f4561e0..0b641513a23d 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -22,6 +22,7 @@
 	aliases {
 		i2c9 = &i2c_ak8975;
 		i2c10 = &i2c_cm36651;
+		i2c11 = &i2c_max77693;
 	};
 
 	memory {
@@ -518,6 +519,39 @@
 		};
 	};
 
+	i2c_max77693: i2c-gpio-1 {
+		compatible = "i2c-gpio";
+		gpios = <&gpm2 0 0>, <&gpm2 1 0 >;
+		i2c-gpio,delay-us = <2>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "okay";
+
+		max77693@66 {
+			compatible = "maxim,max77693";
+			interrupt-parent = <&gpx1>;
+			interrupts = <5 2>;
+			reg = <0x66>;
+
+			regulators {
+				esafeout1_reg: esafeout@1 {
+					regulator-compatible = "ESAFEOUT1";
+					regulator-name = "ESAFEOUT1";
+				};
+				esafeout2_reg: esafeout@2 {
+					regulator-compatible = "ESAFEOUT2";
+					regulator-name = "ESAFEOUT2";
+				};
+				charger_reg: charger@0 {
+					regulator-compatible = "CHARGER";
+					regulator-name = "CHARGER";
+					regulator-min-microamp = <60000>;
+					regulator-max-microamp = <2580000>;
+				};
+			};
+		};
+	};
+
 	mmc@12550000 {
 		num-slots = <1>;
 		supports-highspeed;
-- 
1.9.1

