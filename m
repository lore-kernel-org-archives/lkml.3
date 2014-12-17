Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaLQKEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:04:31 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:35202 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087AbaLQKEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:04:25 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, benjamin.gaignard@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH 1/2] ARM: DT: STiH407: Add DRM dt nodes
Date: Wed, 17 Dec 2014 11:02:23 +0100
Message-Id: <1418810544-11405-2-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418810544-11405-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1418810544-11405-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-17_03:2014-12-17,2014-12-17,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the DRM/KMS dt notes.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 arch/arm/boot/dts/stih407-family.dtsi | 104 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/stihxxx-b2120.dtsi  |   2 +-
 2 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
index 3e31d32..5fd3c96 100644
--- a/arch/arm/boot/dts/stih407-family.dtsi
+++ b/arch/arm/boot/dts/stih407-family.dtsi
@@ -274,5 +274,109 @@
 
 			status = "disabled";
 		};
+
+		/* Display */
+		vtg_main: sti-vtg-main@8d02800 {
+			compatible = "st,vtg";
+			reg = <0x8d02800 0x200>;
+			interrupts = <GIC_SPI 108 IRQ_TYPE_NONE>;
+		};
+
+		vtg_aux: sti-vtg-aux@8d00200 {
+			compatible = "st,vtg";
+			reg = <0x8d00200 0x100>;
+			interrupts = <GIC_SPI 109 IRQ_TYPE_NONE>;
+		};
+
+		sti-display-subsystem {
+			compatible = "st,sti-display-subsystem";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			sti-compositor@9d11000 {
+				compatible = "st,stih407-compositor";
+				reg = <0x9d11000 0x1000>;
+
+				clock-names = "compo_main",
+					      "compo_aux",
+					      "pix_main",
+					      "pix_aux",
+					      "pix_gdp1",
+					      "pix_gdp2",
+					      "pix_gdp3",
+					      "pix_gdp4",
+					      "main_parent",
+					      "aux_parent";
+
+				clocks = <&clk_s_c0_flexgen CLK_COMPO_DVP>,
+					 <&clk_s_c0_flexgen CLK_COMPO_DVP>,
+					 <&clk_s_d2_flexgen CLK_PIX_MAIN_DISP>,
+					 <&clk_s_d2_flexgen CLK_PIX_AUX_DISP>,
+					 <&clk_s_d2_flexgen CLK_PIX_GDP1>,
+					 <&clk_s_d2_flexgen CLK_PIX_GDP2>,
+					 <&clk_s_d2_flexgen CLK_PIX_GDP3>,
+					 <&clk_s_d2_flexgen CLK_PIX_GDP4>,
+					 <&clk_s_d2_quadfs 0>,
+					 <&clk_s_d2_quadfs 1>;
+
+				reset-names = "compo-main", "compo-aux";
+				resets = <&softreset STIH407_COMPO_SOFTRESET>,
+					 <&softreset STIH407_COMPO_SOFTRESET>;
+				st,vtg = <&vtg_main>, <&vtg_aux>;
+			};
+
+			sti-tvout@8d08000 {
+				compatible = "st,stih407-tvout";
+				reg = <0x8d08000 0x1000>;
+				reg-names = "tvout-reg";
+				reset-names = "tvout";
+				resets = <&softreset STIH407_HDTVOUT_SOFTRESET>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges;
+
+				sti-hdmi@8d04000 {
+					compatible = "st,stih407-hdmi";
+					reg = <0x8d04000 0x1000>;
+					reg-names = "hdmi-reg";
+					interrupts = <GIC_SPI 106 IRQ_TYPE_NONE>;
+					interrupt-names	= "irq";
+					clock-names = "pix",
+						      "tmds",
+						      "phy",
+						      "audio",
+						      "main_parent",
+						      "aux_parent";
+
+					clocks = <&clk_s_d2_flexgen CLK_PIX_HDMI>,
+						 <&clk_s_d2_flexgen CLK_TMDS_HDMI>,
+						 <&clk_s_d2_flexgen CLK_REF_HDMIPHY>,
+						 <&clk_s_d0_flexgen CLK_PCM_0>,
+						 <&clk_s_d2_quadfs 0>,
+						 <&clk_s_d2_quadfs 1>;
+
+					hdmi,hpd-gpio = <&pio5 3>;
+					reset-names = "hdmi";
+					resets = <&softreset STIH407_HDMI_TX_PHY_SOFTRESET>;
+					ddc = <&hdmiddc>;
+
+				};
+
+				sti-hda@8d02000 {
+					compatible = "st,stih407-hda";
+					reg = <0x8d02000 0x400>, <0x92b0120 0x4>;
+					reg-names = "hda-reg", "video-dacs-ctrl";
+					clock-names = "pix",
+						      "hddac",
+						      "main_parent",
+						      "aux_parent";
+					clocks = <&clk_s_d2_flexgen CLK_PIX_HDDAC>,
+						 <&clk_s_d2_flexgen CLK_HDDAC>,
+						 <&clk_s_d2_quadfs 0>,
+						 <&clk_s_d2_quadfs 1>;
+				};
+			};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
index 0074bd4..0bc8c17 100644
--- a/arch/arm/boot/dts/stihxxx-b2120.dtsi
+++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
@@ -48,7 +48,7 @@
 		};
 
 		/* SSC11 to HDMI */
-		i2c@9541000 {
+		hdmiddc: i2c@9541000 {
 			status = "okay";
 			/* HDMI V1.3a supports Standard mode only */
 			clock-frequency = <100000>;
-- 
1.9.1

