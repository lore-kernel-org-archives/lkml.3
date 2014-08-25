Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081AbaHYOqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:46:18 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:35029 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933032AbaHYOqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:46:11 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, olof@lixom.net
Cc: linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Olivier Bideau <olivier.bideau@st.com>
Subject: [RESEND PATCH 3/4] ARM: STi: DT: STiH407: 407 DT Entry for clockgen D0/D2/D3
Date: Mon, 25 Aug 2014 16:44:47 +0200
Message-Id: <1408977888-10473-4-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408977888-10473-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1408977888-10473-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-25_01:2014-08-25,2014-08-24,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds DT entries for clockgen D0/D2/D3

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Signed-off-by: Olivier Bideau <olivier.bideau@st.com>
---
 arch/arm/boot/dts/stih407-clock.dtsi | 126 +++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/arch/arm/boot/dts/stih407-clock.dtsi b/arch/arm/boot/dts/stih407-clock.dtsi
index 85cc135..6e59011 100644
--- a/arch/arm/boot/dts/stih407-clock.dtsi
+++ b/arch/arm/boot/dts/stih407-clock.dtsi
@@ -139,5 +139,131 @@
 						     "clk-compo-dvp";
 			};
 		};
+
+		clk_s_d0_quadfs: clk-s-d0-quadfs@9104000 {
+			#clock-cells = <1>;
+			compatible = "st,stih407-quadfs660-D", "st,quadfs";
+			reg = <0x9104000 0x1000>;
+
+			clocks = <&clk_sysin>;
+
+			clock-output-names = "clk-s-d0-fs0-ch0",
+					     "clk-s-d0-fs0-ch1",
+					     "clk-s-d0-fs0-ch2",
+					     "clk-s-d0-fs0-ch3";
+		};
+
+		clockgen-d0@09104000 {
+			compatible = "st,clkgen-c32";
+			reg = <0x9104000 0x1000>;
+
+			clk_s_d0_flexgen: clk-s-d0-flexgen {
+				#clock-cells = <1>;
+				compatible = "st,flexgen";
+
+				clocks = <&clk_s_d0_quadfs 0>,
+					 <&clk_s_d0_quadfs 1>,
+					 <&clk_s_d0_quadfs 2>,
+					 <&clk_s_d0_quadfs 3>,
+					 <&clk_sysin>;
+
+				clock-output-names = "clk-pcm-0",
+						     "clk-pcm-1",
+						     "clk-pcm-2",
+						     "clk-spdiff";
+			};
+		};
+
+		clk_s_d2_quadfs: clk-s-d2-quadfs@9106000 {
+			#clock-cells = <1>;
+			compatible = "st,stih407-quadfs660-D", "st,quadfs";
+			reg = <0x9106000 0x1000>;
+
+			clocks = <&clk_sysin>;
+
+			clock-output-names = "clk-s-d2-fs0-ch0",
+					     "clk-s-d2-fs0-ch1",
+					     "clk-s-d2-fs0-ch2",
+					     "clk-s-d2-fs0-ch3";
+		};
+
+		clk_tmdsout_hdmi: clk-tmdsout-hdmi {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <0>;
+		};
+
+		clockgen-d2@x9106000 {
+			compatible = "st,clkgen-c32";
+			reg = <0x9106000 0x1000>;
+
+			clk_s_d2_flexgen: clk-s-d2-flexgen {
+				#clock-cells = <1>;
+				compatible = "st,flexgen";
+
+				clocks = <&clk_s_d2_quadfs 0>,
+					 <&clk_s_d2_quadfs 1>,
+					 <&clk_s_d2_quadfs 2>,
+					 <&clk_s_d2_quadfs 3>,
+					 <&clk_sysin>,
+					 <&clk_sysin>,
+					 <&clk_tmdsout_hdmi>;
+
+				clock-output-names = "clk-pix-main-disp",
+						     "clk-pix-pip",
+						     "clk-pix-gdp1",
+						     "clk-pix-gdp2",
+						     "clk-pix-gdp3",
+						     "clk-pix-gdp4",
+						     "clk-pix-aux-disp",
+						     "clk-denc",
+						     "clk-pix-hddac",
+						     "clk-hddac",
+						     "clk-sddac",
+						     "clk-pix-dvo",
+						     "clk-dvo",
+						     "clk-pix-hdmi",
+						     "",
+						     "clk-ref-hdmiphy";
+						     };
+		};
+
+		clk_s_d3_quadfs: clk-s-d3-quadfs@9107000 {
+			#clock-cells = <1>;
+			compatible = "st,stih407-quadfs660-D", "st,quadfs";
+			reg = <0x9107000 0x1000>;
+
+			clocks = <&clk_sysin>;
+
+			clock-output-names = "clk-s-d3-fs0-ch0",
+					     "clk-s-d3-fs0-ch1",
+					     "clk-s-d3-fs0-ch2",
+					     "clk-s-d3-fs0-ch3";
+		};
+
+		clockgen-d3@9107000 {
+			compatible = "st,clkgen-c32";
+			reg = <0x9107000 0x1000>;
+
+			clk_s_d3_flexgen: clk-s-d3-flexgen {
+				#clock-cells = <1>;
+				compatible = "st,flexgen";
+
+				clocks = <&clk_s_d3_quadfs 0>,
+					 <&clk_s_d3_quadfs 1>,
+					 <&clk_s_d3_quadfs 2>,
+					 <&clk_s_d3_quadfs 3>,
+					 <&clk_sysin>;
+
+				clock-output-names = "clk-stfe-frc1",
+						     "clk-tsout-0",
+						     "clk-tsout-1",
+						     "clk-mchi",
+						     "clk-vsens-compo",
+						     "clk-frc1-remote",
+						     "clk-lpc-0",
+						     "clk-lpc-1";
+			};
+		};
 	};
 };
-- 
1.9.1

