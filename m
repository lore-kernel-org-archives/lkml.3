Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaLQKE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:04:29 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:35201 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbaLQKEZ (ORCPT
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
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH 2/2] ARM: DT: STiH407: Specify default clocks for HDMI devices
Date: Wed, 17 Dec 2014 11:02:24 +0100
Message-Id: <1418810544-11405-3-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418810544-11405-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1418810544-11405-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-17_03:2014-12-17,2014-12-17,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specify default clocks for HDMI devices to ensure a maximum of
compatible frequencies.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 arch/arm/boot/dts/stih407-family.dtsi | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
index 5fd3c96..a7eb76c 100644
--- a/arch/arm/boot/dts/stih407-family.dtsi
+++ b/arch/arm/boot/dts/stih407-family.dtsi
@@ -292,6 +292,27 @@
 			compatible = "st,sti-display-subsystem";
 			#address-cells = <1>;
 			#size-cells = <1>;
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
 			ranges;
 
 			sti-compositor@9d11000 {
@@ -334,6 +355,20 @@
 				resets = <&softreset STIH407_HDTVOUT_SOFTRESET>;
 				#address-cells = <1>;
 				#size-cells = <1>;
+
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
 				ranges;
 
 				sti-hdmi@8d04000 {
-- 
1.9.1

