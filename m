Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaIAI3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:29:44 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39679 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaIAI3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:29:41 -0400
From: Guodong Xu <guodong.xu@linaro.org>
To: lee.jones@linaro.org, sameo@linux.intel.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, grant.likely@linaro.org, khilman@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, zhangnian@huawei.com
Cc: Guodong Xu <guodong.xu@linaro.org>
Subject: [PATCH v8 3/3] ARM: dts: hi3620-hi4511: Add HI6421 MFD and regulator nodes
Date: Mon,  1 Sep 2014 16:28:35 +0800
Message-Id: <1409560115-30646-4-git-send-email-guodong.xu@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409560115-30646-1-git-send-email-guodong.xu@linaro.org>
References: <1409560115-30646-1-git-send-email-guodong.xu@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Hi6421 MFD dts node and regulator nodes into hi3620-hi4511
board config dts file.

Signed-off-by: Guodong Xu <guodong.xu@linaro.org>
---
 arch/arm/boot/dts/hi3620-hi4511.dts | 233 ++++++++++++++++++++++++++++++++++++
 1 file changed, 233 insertions(+)

diff --git a/arch/arm/boot/dts/hi3620-hi4511.dts b/arch/arm/boot/dts/hi3620-hi4511.dts
index fe62392..a1aadbb 100644
--- a/arch/arm/boot/dts/hi3620-hi4511.dts
+++ b/arch/arm/boot/dts/hi3620-hi4511.dts
@@ -635,6 +635,239 @@
 				pinctrl-single,bias-pullup = <0 1 0 1>;
 			};
 		};
+
+		hi6421 {
+			compatible = "hisilicon,hi6421-pmic";
+			reg = <0xc00000 0x0180>; /* 0x60 << 2 */
+
+			regulators {
+				// supply for MLC NAND/ eMMC
+				hi6421_vout0_reg: hi6421_vout0 {
+					regulator-name = "VOUT0";
+					regulator-min-microvolt = <2850000>;
+					regulator-max-microvolt = <2850000>;
+				};
+
+				// supply for 26M Oscillator
+				hi6421_vout1_reg: hi6421_vout1 {
+					regulator-name = "VOUT1";
+					regulator-min-microvolt = <1700000>;
+					regulator-max-microvolt = <2000000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				// supply for AP system
+				hi6421_vout2_reg: hi6421_vout2 {
+					regulator-name = "VOUT2";
+					regulator-min-microvolt = <1050000>;
+					regulator-max-microvolt = <1400000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				// supply for DDR PHY I/O
+				hi6421_vout3_reg: hi6421_vout3 {
+					regulator-name = "VOUT3";
+					regulator-min-microvolt = <1050000>;
+					regulator-max-microvolt = <1400000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				// supply for MIPI, USB2.0, PCIe, PLL Analog
+				hi6421_vout4_reg: hi6421_vout4 {
+					regulator-name = "VOUT4";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3000000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				// supply for I/O 1.8V
+				hi6421_vout5_reg: hi6421_vout5 {
+					regulator-name = "VOUT5";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3000000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				// supply for I/O 2.6V
+				hi6421_vout6_reg: hi6421_vout6 {
+					regulator-name = "VOUT6";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3000000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				// supply for SD I/O
+				hi6421_vout7_reg: hi6421_vout7 {
+					regulator-name = "VOUT7";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3000000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				// supply for USB PHY
+				hi6421_vout8_reg: hi6421_vout8 {
+					regulator-name = "VOUT8";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				// supply for Efuse power
+				hi6421_vout9_reg: hi6421_vout9 {
+					regulator-name = "VOUT9";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3000000>;
+				};
+
+				// supply for BT RF&PA
+				hi6421_vout10_reg: hi6421_vout10 {
+					regulator-name = "VOUT10";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3000000>;
+				};
+
+				// supply for GPS RF&PA
+				hi6421_vout11_reg: hi6421_vout11 {
+					regulator-name = "VOUT11";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3000000>;
+				};
+
+				// supply for SD card
+				hi6421_vout12_reg: hi6421_vout12 {
+					regulator-name = "VOUT12";
+					regulator-min-microvolt = <2850000>;
+					regulator-max-microvolt = <2850000>;
+				};
+
+				// supply for CMMB
+				hi6421_vout13_reg: hi6421_vout13 {
+					regulator-name = "VOUT13";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3000000>;
+				};
+
+				// supply for WIFI I/O
+				hi6421_vout14_reg: hi6421_vout14 {
+					regulator-name = "VOUT14";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3000000>;
+				};
+
+				// supply for WIFI core & PA
+				hi6421_vout15_reg: hi6421_vout15 {
+					regulator-name = "VOUT15";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				// supply for LCD I/O
+				hi6421_vout16_reg: hi6421_vout16 {
+					regulator-name = "VOUT16";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3000000>;
+					regulator-always-on;
+				};
+
+				// supply for LCD Ananlog
+				hi6421_vout17_reg: hi6421_vout17 {
+					regulator-name = "VOUT17";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3000000>;
+					regulator-always-on;
+				};
+
+				// supply for Camera I/O
+				hi6421_vout18_reg: hi6421_vout18 {
+					regulator-name = "VOUT18";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3000000>;
+				};
+
+				// supply for Camera Analog
+				hi6421_vout19_reg: hi6421_vout19 {
+					regulator-name = "VOUT19";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3000000>;
+				};
+
+				// supply for Camera VCM
+				hi6421_vout20_reg: hi6421_vout20 {
+					regulator-name = "VOUT20";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <3000000>;
+				};
+
+				// supply for Audio, incl. HKADC
+				hi6421_vout_audio_reg: hi6421_vout_audio {
+					regulator-name = "AVDD2";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				// supply for Cortex-A9 CPU core
+				hi6421_buck0_reg: hi6421_buck0 {
+					regulator-name = "VBUCK0";
+					regulator-min-microvolt = <700000>;
+					regulator-max-microvolt = <1600000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				// supply for Cortex-A9 CPU core
+				hi6421_buck1_reg: hi6421_buck1 {
+					regulator-name = "VBUCK1";
+					regulator-min-microvolt = <700000>;
+					regulator-max-microvolt = <1600000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				// supply for GPU
+				hi6421_buck2_reg: hi6421_buck2 {
+					regulator-name = "VBUCK2";
+					regulator-min-microvolt = <700000>;
+					regulator-max-microvolt = <1600000>;
+					regulator-boot-on;
+				};
+
+				// supply for Peripheral
+				hi6421_buck3_reg: hi6421_buck3 {
+					regulator-name = "VBUCK3";
+					regulator-min-microvolt = <950000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				// supply for LPDDR2 and AP I/O
+				hi6421_buck4_reg: hi6421_buck4 {
+					regulator-name = "VBUCK4";
+					regulator-min-microvolt = <1150000>;
+					regulator-max-microvolt = <2000000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+
+				// supply for Low voltage
+				hi6421_buck5_reg: hi6421_buck5 {
+					regulator-name = "VBUCK5";
+					regulator-min-microvolt = <1150000>;
+					regulator-max-microvolt = <1900000>;
+					regulator-boot-on;
+					regulator-always-on;
+				};
+			};
+		};
+
 	};
 
 	gpio-keys {
-- 
1.9.1

