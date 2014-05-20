Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbaETNYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:24:20 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:35192 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860AbaETNYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:24:04 -0400
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
        Pankaj Dev <pankaj.dev@st.com>
Subject: [PATCH v3 05/11] ARM: STi: DT: STiH416: 416 DT Entry for clockgen B/C/D/E/F
Date: Tue, 20 May 2014 15:22:49 +0200
Message-Id: <1400592175-13176-6-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400592175-13176-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1400592175-13176-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-20_02:2014-05-20,2014-05-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds DT entries for clockgen B/C/D/E/F

Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 arch/arm/boot/dts/stih416-clock.dtsi | 189 +++++++++++++++++++++++++++++++++++
 1 file changed, 189 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-clock.dtsi b/arch/arm/boot/dts/stih416-clock.dtsi
index 072c587..0eeadc7 100644
--- a/arch/arm/boot/dts/stih416-clock.dtsi
+++ b/arch/arm/boot/dts/stih416-clock.dtsi
@@ -502,5 +502,194 @@
 						     /* Remaining outputs unused */
 			};
 		};
+
+		/*
+		 * Frequency synthesizers on the SASG2
+		 */
+		clockgen_b0: clockgen-b0@fee108b4 {
+			#clock-cells = <1>;
+			compatible = "st,stih416-quadfs216", "st,quadfs";
+			reg = <0xfee108b4 0x44>;
+
+			clocks = <&clk_sysin>;
+			clock-output-names = "clk-s-usb48",
+					     "clk-s-dss",
+					     "clk-s-stfe-frc-2",
+					     "clk-s-thsens-scard";
+		};
+
+		clockgen_b1: clockgen-b1@fe8308c4 {
+			#clock-cells = <1>;
+			compatible = "st,stih416-quadfs216", "st,quadfs";
+			reg = <0xfe8308c4 0x44>;
+
+			clocks = <&clk_sysin>;
+			clock-output-names = "clk-s-pcm-0",
+					     "clk-s-pcm-1",
+					     "clk-s-pcm-2",
+					     "clk-s-pcm-3";
+		};
+
+		clockgen_c: clockgen-c@fe8307d0 {
+			#clock-cells = <1>;
+			compatible = "st,stih416-quadfs432", "st,quadfs";
+			reg = <0xfe8307d0 0x44>;
+
+			clocks = <&clk_sysin>;
+			clock-output-names = "clk-s-c-fs0-ch0",
+					     "clk-s-c-vcc-sd",
+					     "clk-s-c-fs0-ch2";
+		};
+
+		clk_s_vcc_hd: clk-s-vcc-hd@fe8308b8 {
+			#clock-cells = <0>;
+			compatible = "st,stih416-clkgenc-vcc-hd", "st,clkgen-mux";
+			reg = <0xfe8308b8 0x4>; /* SYSCFG2558 */
+
+			clocks = <&clk_sysin>,
+				 <&clockgen_c 0>;
+		};
+
+		/*
+		 * Add a dummy clock for the HDMI PHY for the VCC input mux
+		 */
+		clk_s_tmds_fromphy: clk-s-tmds-fromphy {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <0>;
+		};
+
+		clockgen_c_vcc: clockgen-c-vcc@fe8308ac {
+			#clock-cells = <1>;
+			compatible = "st,stih416-clkgenc", "st,clkgen-vcc";
+			reg = <0xfe8308ac 0xc>; /* SYSCFG2555,2556,2557 */
+
+			clocks = <&clk_s_vcc_hd>,
+				 <&clockgen_c 1>,
+				 <&clk_s_tmds_fromphy>,
+				 <&clockgen_c 2>;
+
+			clock-output-names  = "clk-s-pix-hdmi",
+					      "clk-s-pix-dvo",
+					      "clk-s-out-dvo",
+					      "clk-s-pix-hd",
+					      "clk-s-hddac",
+					      "clk-s-denc",
+					      "clk-s-sddac",
+					      "clk-s-pix-main",
+					      "clk-s-pix-aux",
+					      "clk-s-stfe-frc-0",
+					      "clk-s-ref-mcru",
+					      "clk-s-slave-mcru",
+					      "clk-s-tmds-hdmi",
+					      "clk-s-hdmi-reject-pll",
+					      "clk-s-thsens";
+		};
+
+		clockgen_d: clockgen-d@fee107e0 {
+			#clock-cells = <1>;
+			compatible = "st,stih416-quadfs216", "st,quadfs";
+			reg = <0xfee107e0 0x44>;
+
+			clocks = <&clk_sysin>;
+			clock-output-names = "clk-s-ccsc",
+					     "clk-s-stfe-frc-1",
+					     "clk-s-tsout-1",
+					     "clk-s-mchi";
+		};
+
+		/*
+		 * Frequency synthesizers on the MPE42
+		 */
+		clockgen_e: clockgen-e@fd3208bc {
+			#clock-cells = <1>;
+			compatible = "st,stih416-quadfs660-E", "st,quadfs";
+			reg = <0xfd3208bc 0xb0>;
+
+			clocks = <&clk_sysin>;
+			clock-output-names = "clk-m-pix-mdtp-0",
+					     "clk-m-pix-mdtp-1",
+					     "clk-m-pix-mdtp-2",
+					     "clk-m-mpelpc";
+		};
+
+		clockgen_f: clockgen-f@fd320878 {
+			#clock-cells = <1>;
+			compatible = "st,stih416-quadfs660-F", "st,quadfs";
+			reg = <0xfd320878 0xf0>;
+
+			clocks = <&clk_sysin>;
+			clock-output-names = "clk-m-main-vidfs",
+					     "clk-m-hva-fs",
+					     "clk-m-fvdp-vcpu",
+					     "clk-m-fvdp-proc-fs";
+		};
+
+		clk_m_fvdp_proc: clk-m-fvdp-proc@fd320910 {
+			#clock-cells = <0>;
+			compatible = "st,stih416-clkgenf-vcc-fvdp", "st,clkgen-mux";
+			reg = <0xfd320910 0x4>; /* SYSCFG8580 */
+
+			clocks = <&clk_m_a1_div2 0>,
+				 <&clockgen_f 3>;
+		};
+
+		clk_m_hva: clk-m-hva@fd690868 {
+			#clock-cells = <0>;
+			compatible = "st,stih416-clkgenf-vcc-hva", "st,clkgen-mux";
+			reg = <0xfd690868 0x4>; /* SYSCFG9538 */
+
+			clocks = <&clockgen_f 1>,
+				 <&clk_m_a1_div0 3>;
+		};
+
+		clk_m_f_vcc_hd: clk-m-f-vcc-hd@fd32086c {
+			#clock-cells = <0>;
+			compatible = "st,stih416-clkgenf-vcc-hd", "st,clkgen-mux";
+			reg = <0xfd32086c 0x4>; /* SYSCFG8539 */
+
+			clocks = <&clockgen_c_vcc 7>,
+				 <&clockgen_f 0>;
+		};
+
+		clk_m_f_vcc_sd: clk-m-f-vcc-sd@fd32086c {
+			#clock-cells = <0>;
+			compatible = "st,stih416-clkgenf-vcc-sd", "st,clkgen-mux";
+			reg = <0xfd32086c 0x4>; /* SYSCFG8539 */
+
+			clocks = <&clockgen_c_vcc 8>,
+				 <&clockgen_f 1>;
+		};
+
+		/*
+		 * Add a dummy clock for the HDMIRx external signal clock
+		 */
+		clk_m_pix_hdmirx_sas: clk-m-pix-hdmirx-sas {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <0>;
+		};
+
+		clockgen_f_vcc: clockgen-f-vcc@fd32086c {
+			#clock-cells = <1>;
+			compatible = "st,stih416-clkgenf", "st,clkgen-vcc";
+			reg = <0xfd32086c 0xc>; /* SYSCFG8539,8540,8541 */
+
+			clocks = <&clk_m_f_vcc_hd>,
+				 <&clk_m_f_vcc_sd>,
+				 <&clockgen_f 0>,
+				 <&clk_m_pix_hdmirx_sas>;
+
+			clock-output-names  = "clk-m-pix-main-pipe",
+					      "clk-m-pix-aux-pipe",
+					      "clk-m-pix-main-cru",
+					      "clk-m-pix-aux-cru",
+					      "clk-m-xfer-be-compo",
+					      "clk-m-xfer-pip-compo",
+					      "clk-m-xfer-aux-compo",
+					      "clk-m-vsens",
+					      "clk-m-pix-hdmirx-0",
+					      "clk-m-pix-hdmirx-1";
+		};
 	};
 };
-- 
1.9.1

