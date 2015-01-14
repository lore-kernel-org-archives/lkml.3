Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbbANPsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:48:35 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:50413 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753466AbbANPsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:48:30 -0500
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
Subject: [PATCH 2/2] ARM: DT: STiH410: Add DRM dt nodes
Date: Wed, 14 Jan 2015 16:47:12 +0100
Message-Id: <1421250432-25903-3-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421250432-25903-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1421250432-25903-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-14_05:2015-01-14,2015-01-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the DRM/KMS dt nodes.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 arch/arm/boot/dts/stih410.dtsi | 138 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/arch/arm/boot/dts/stih410.dtsi b/arch/arm/boot/dts/stih410.dtsi
index 37995f4..208b5e8 100644
--- a/arch/arm/boot/dts/stih410.dtsi
+++ b/arch/arm/boot/dts/stih410.dtsi
@@ -80,5 +80,143 @@
 			phys = <&usb2_picophy2>;
 			phy-names = "usb";
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
+
+			assigned-clocks	= <&clk_s_d2_quadfs 0>,
+					  <&clk_s_d2_quadfs 0>,
+					  <&clk_s_d2_flexgen CLK_PIX_MAIN_DISP>,
+					  <&clk_s_d2_flexgen CLK_PIX_AUX_DISP>,
+					  <&clk_s_d2_flexgen CLK_PIX_GDP1>,
+					  <&clk_s_d2_flexgen CLK_PIX_GDP2>,
+					  <&clk_s_d2_flexgen CLK_PIX_GDP3>,
+					  <&clk_s_d2_flexgen CLK_PIX_GDP4>;
+
+			assigned-clock-parents = <0>,
+						 <0>,
+						 <&clk_s_d2_quadfs 0>,
+						 <&clk_s_d2_quadfs 0>,
+						 <&clk_s_d2_quadfs 0>,
+						 <&clk_s_d2_quadfs 0>,
+						 <&clk_s_d2_quadfs 0>,
+						 <&clk_s_d2_quadfs 0>;
+
+			assigned-clock-rates = <297000000>, <297000000>;
+
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
+				assigned-clocks = <&clk_s_d2_flexgen CLK_PIX_HDMI>,
+						  <&clk_s_d2_flexgen CLK_TMDS_HDMI>,
+						  <&clk_s_d2_flexgen CLK_REF_HDMIPHY>,
+						  <&clk_s_d0_flexgen CLK_PCM_0>,
+						  <&clk_s_d2_flexgen CLK_PIX_HDDAC>,
+						  <&clk_s_d2_flexgen CLK_HDDAC>;
+
+				assigned-clock-parents = <&clk_s_d2_quadfs 0>,
+							 <&clk_tmdsout_hdmi>,
+							 <&clk_s_d2_quadfs 0>,
+							 <&clk_s_d0_quadfs 0>,
+							 <&clk_s_d2_quadfs 0>,
+							 <&clk_s_d2_quadfs 0>;
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
-- 
1.9.1

