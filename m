Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaB0PtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:49:25 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:53745 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677AbaB0PtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:49:17 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@st.com>,
        Pankaj Dev <pankaj.dev@st.com>
Subject: [PATCH v0 12/15] ARM: STi: DT: STiH416: 416 DT Entry for clockgen B/C/D/E/F
Date: Thu, 27 Feb 2014 16:24:25 +0100
Message-Id: <1393514668-17440-13-git-send-email-gabriel.fernandez@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
References: <1393514668-17440-1-git-send-email-gabriel.fernandez@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds DT entries for clockgen B/C/D/E/F

Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
---
 arch/arm/boot/dts/stih416-clock.dtsi | 170 +++++++++++++++++++++++++++++++++++
 1 file changed, 170 insertions(+)

diff --git a/arch/arm/boot/dts/stih416-clock.dtsi b/arch/arm/boot/dts/stih416-clock.dtsi
index f63b0a1..6b2e387 100644
--- a/arch/arm/boot/dts/stih416-clock.dtsi
+++ b/arch/arm/boot/dts/stih416-clock.dtsi
@@ -503,5 +503,175 @@
 						/* Remaining outputs unused */
 			};
 		};
+                /*
+                 * Frequency synthesizers on the SASG2.
+                 *
+                 */
+                CLOCKGEN_B0: CLOCKGEN_B0 {
+                        #clock-cells = <1>;
+                        compatible = "st,stih416-quadfs216", "st,quadfs";
+                        reg = <0xfee108b4 0x44>;
+
+                        clocks = <&CLK_SYSIN>;
+                        clock-output-names = "CLK_S_USB48",
+                                             "CLK_S_DSS",
+                                             "CLK_S_STFE_FRC_2",
+                                             "CLK_S_THSENS_SCARD";
+                };
+
+                CLOCKGEN_B1: CLOCKGEN_B1 {
+                        #clock-cells = <1>;
+                        compatible = "st,stih416-quadfs216", "st,quadfs";
+                        reg = <0xfe8308c4 0x44>;
+
+                        clocks = <&CLK_SYSIN>;
+                        clock-output-names = "CLK_S_PCM_0",
+                                             "CLK_S_PCM_1",
+                                             "CLK_S_PCM_2",
+                                             "CLK_S_PCM_3";
+                };
+
+                CLOCKGEN_C: CLOCKGEN_C {
+                        #clock-cells = <1>;
+                        compatible = "st,stih416-quadfs432", "st,quadfs";
+                        reg = <0xfe8307d0 0x44>;
+
+                        clocks = <&CLK_SYSIN>;
+                        clock-output-names = "CLK_S_C_FS0_CH0",
+                                             "CLK_S_C_VCC_SD",
+                                             "CLK_S_C_FS0_CH2";
+                };
+
+                CLK_S_VCC_HD: CLK_S_VCC_HD {
+                        #clock-cells = <0>;
+                        compatible = "st,stih416-clkgenc-vcc-hd", "st,clkgen-mux";
+                        reg = <0xfe8308b8 4>; /* SYSCFG2558 */
+
+                        clocks = <&CLK_SYSIN>, <&CLOCKGEN_C 0>;
+                };
+
+                /*
+                 * Add a dummy clock for the HDMI PHY for the VCC input mux
+                 */
+                CLK_S_TMDS_FROMPHY: CLK_S_TMDS_FROMPHY {
+                        #clock-cells = <0>;
+                        compatible = "fixed-clock";
+                        clock-frequency = <0>;
+                };
+
+                CLOCKGEN_C_VCC: CLOCKGEN_C_VCC {
+                        #clock-cells = <1>;
+                        compatible = "st,stih416-clkgenc", "st,clkgen-vcc";
+                        reg = <0xfe8308ac 12>; /* SYSCFG2555,2556,2557 */
+
+                        clocks = <&CLK_S_VCC_HD>, <&CLOCKGEN_C 1>,
+                                 <&CLK_S_TMDS_FROMPHY>, <&CLOCKGEN_C 2>;
+
+                        clock-output-names  =
+                                "CLK_S_PIX_HDMI",  "CLK_S_PIX_DVO",
+                                "CLK_S_OUT_DVO",   "CLK_S_PIX_HD",
+                                "CLK_S_HDDAC",     "CLK_S_DENC",
+                                "CLK_S_SDDAC",     "CLK_S_PIX_MAIN",
+                                "CLK_S_PIX_AUX",   "CLK_S_STFE_FRC_0",
+                                "CLK_S_REF_MCRU",  "CLK_S_SLAVE_MCRU",
+                                "CLK_S_TMDS_HDMI", "CLK_S_HDMI_REJECT_PLL",
+                                "CLK_S_THSENS";
+                };
+
+                CLOCKGEN_D: CLOCKGEN_D {
+                        #clock-cells = <1>;
+                        compatible = "st,stih416-quadfs216", "st,quadfs";
+                        reg = <0xfee107e0 0x44>;
+
+                        clocks = <&CLK_SYSIN>;
+                        clock-output-names = "CLK_S_CCSC",
+                                             "CLK_S_STFE_FRC_1",
+                                             "CLK_S_TSOUT_1",
+                                             "CLK_S_MCHI";
+                };
+
+		/*
+		 * Frequency synthesizers on the MPE42
+		 */
+                CLOCKGEN_E: CLOCKGEN_E {
+                        #clock-cells = <1>;
+                        compatible = "st,stih416-quadfs660-E", "st,quadfs";
+                        reg = <0xfd3208bc 0xB0>;
+
+                        clocks = <&CLK_SYSIN>;
+                        clock-output-names = "CLK_M_PIX_MDTP_0",
+                                             "CLK_M_PIX_MDTP_1",
+                                             "CLK_M_PIX_MDTP_2",
+                                             "CLK_M_MPELPC";
+                };
+
+                CLOCKGEN_F: CLOCKGEN_F {
+                        #clock-cells = <1>;
+                        compatible = "st,stih416-quadfs660-F", "st,quadfs";
+                        reg = <0xfd320878 0xF0>;
+
+                        clocks = <&CLK_SYSIN>;
+                        clock-output-names = "CLK_M_MAIN_VIDFS",
+                                             "CLK_M_HVA_FS",
+                                             "CLK_M_FVDP_VCPU",
+					     "CLK_M_FVDP_PROC_FS";
+                };
+
+                CLK_M_FVDP_PROC: CLK_M_FVDP_PROC {
+                        #clock-cells = <0>;
+                        compatible = "st,stih416-clkgenf-vcc-fvdp", "st,clkgen-mux";
+                        reg = <0xfd320910 4>; /* SYSCFG8580 */
+
+                        clocks = <&CLK_M_A1_DIV2 0>, <&CLOCKGEN_F 3>;
+                };
+
+                CLK_M_HVA: CLK_M_HVA {
+                        #clock-cells = <0>;
+                        compatible = "st,stih416-clkgenf-vcc-hva", "st,clkgen-mux";
+                        reg = <0xfd690868 4>; /* SYSCFG9538 */
+
+                        clocks = <&CLOCKGEN_F 1>, <&CLK_M_A1_DIV0 3>;
+                };
+
+                CLK_M_F_VCC_HD: CLK_M_F_VCC_HD {
+                        #clock-cells = <0>;
+                        compatible = "st,stih416-clkgenf-vcc-hd", "st,clkgen-mux";
+                        reg = <0xfd32086c 4>; /* SYSCFG8539 */
+
+                        clocks = <&CLOCKGEN_C_VCC 7>, <&CLOCKGEN_F 0>;
+                };
+
+                CLK_M_F_VCC_SD: CLK_M_F_VCC_SD {
+                        #clock-cells = <0>;
+                        compatible = "st,stih416-clkgenf-vcc-sd", "st,clkgen-mux";
+                        reg = <0xfd32086c 4>; /* SYSCFG8539 */
+
+                        clocks = <&CLOCKGEN_C_VCC 8>, <&CLOCKGEN_F 1>;
+                };
+
+                /*
+                 * Add a dummy clock for the HDMIRx external signal clock
+                 */
+                CLK_M_PIX_HDMIRX_SAS: CLK_M_PIX_HDMIRX_SAS {
+                        #clock-cells = <0>;
+                        compatible = "fixed-clock";
+                        clock-frequency = <0>;
+                };
+
+                CLOCKGEN_F_VCC: CLOCKGEN_F_VCC {
+                        #clock-cells = <1>;
+                        compatible = "st,stih416-clkgenf", "st,clkgen-vcc";
+                        reg = <0xfd32086c 12>; /* SYSCFG8539,8540,8541 */
+
+                        clocks = <&CLK_M_F_VCC_HD>, <&CLK_M_F_VCC_SD>,
+                                 <&CLOCKGEN_F 0>, <&CLK_M_PIX_HDMIRX_SAS>;
+
+                        clock-output-names  =
+                                "CLK_M_PIX_MAIN_PIPE",  "CLK_M_PIX_AUX_PIPE",
+                                "CLK_M_PIX_MAIN_CRU",   "CLK_M_PIX_AUX_CRU",
+                                "CLK_M_XFER_BE_COMPO",  "CLK_M_XFER_PIP_COMPO",
+                                "CLK_M_XFER_AUX_COMPO", "CLK_M_VSENS",
+                                "CLK_M_PIX_HDMIRX_0",   "CLK_M_PIX_HDMIRX_1";
+                };
 	};
 };
-- 
1.9.0

