Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaEBEoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 00:44:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47607 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaEBEoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 00:44:08 -0400
From: Andy Gross <agross@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Andy Gross <agross@codeaurora.org>
Subject: [PATCH] pinctrl: msm: Add more MSM8X74 pin definitions
Date: Thu,  1 May 2014 23:44:02 -0500
Message-Id: <1399005842-27898-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds pin definitiones for the MSM8x74 TLMM.  New definitions
include:

BLSP devices (I2C, UART, UART flow control, SPI, and UIM), mi2s, gp clk, pdm,
gcc clk, cci_timer, cci_i2c, cam_clk, hsic, tsif, sdc3, sdc4, and other assorted
pins.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 .../bindings/pinctrl/qcom,msm8974-pinctrl.txt      |  22 +-
 drivers/pinctrl/pinctrl-msm8x74.c                  | 233 ++++++++++++++-------
 2 files changed, 173 insertions(+), 82 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt
index 9fb89e3..9c292ea 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt
@@ -50,7 +50,27 @@ Valid values for pins are:
     Supports bias and drive-strength
 
 Valid values for function are:
-  blsp_i2c2, blsp_i2c6, blsp_i2c11, blsp_spi1, blsp_uart2, blsp_uart8, slimbus
+  cci_i2c0, cci_i2c1, uim1, uim2, uim_batt_alarm,
+  blsp_uim1, blsp_uart1, blsp_uart1_flow, blsp_i2c1, blsp_spi1,
+  blsp_uim2, blsp_uart2, blsp_uart2_flow, blsp_i2c2, blsp_spi2,
+  blsp_uim3, blsp_uart3, blsp_uart3_flow, blsp_i2c3, blsp_spi3,
+  blsp_uim4, blsp_uart4, blsp_uart4_flow, blsp_i2c4, blsp_spi4,
+  blsp_uim5, blsp_uart5, blsp_uart5_flow, blsp_i2c5, blsp_spi5,
+  blsp_uim6, blsp_uart6, blsp_uart6_flow, blsp_i2c6, blsp_spi6,
+  blsp_uim7, blsp_uart7, blsp_uart7_flow, blsp_i2c7, blsp_spi7,
+  blsp_uim8, blsp_uart8, blsp_uart8_flow, blsp_i2c8, blsp_spi8,
+  blsp_uim9, blsp_uart9, blsp_uart9_flow, blsp_i2c9, blsp_spi9,
+  blsp_uim10, blsp_uart10, blsp_uart10_flow, blsp_i2c10, blsp_spi10,
+  blsp_uim11, blsp_uart11, blsp_uart11_flow, blsp_i2c11, blsp_spi11,
+  blsp_uim12, blsp_uart12, blsp_uart12_flow, blsp_i2c12, blsp_spi12,
+  blsp_spi1_cs1, blsp_spi2_cs2, blsp_spi_cs3, blsp_spi2_cs1, blsp_spi2_cs2
+  blsp_spi2_cs3, blsp_spi10_cs1, blsp_spi10_cs2, blsp_spi10_cs3,
+  sdc3, sdc4, gcc_gp_clk1, gcc_gp_clk2, gcc_gp_clk3, cci_timer0, cci_timer1,
+  cci_timer2, cci_timer3, cci_async_in0, cci_async_in1, cci_async_in2,
+  cam_mckl0, cam_mclk1, cam_mclk2, cam_mclk3, mdp_vsync, hdmi_cec, hdmi_ddc,
+  hdmi_hpd, edp_hpd, gp_pdm0, gp_pdm1, gp_pdm2, gp_pdm3, gp0_clk, gp1_clk,
+  gp_mn, tsif1, tsif2, hsic, grfc, audio_ref_clk, qua_mi2s, pri_mi2s, spkr_mi2s,
+  ter_mi2s, sec_mi2s, slimbus
 
   (Note that this is not yet the complete list of functions)
 
diff --git a/drivers/pinctrl/pinctrl-msm8x74.c b/drivers/pinctrl/pinctrl-msm8x74.c
index 4dd5c0d..f1c66ef 100644
--- a/drivers/pinctrl/pinctrl-msm8x74.c
+++ b/drivers/pinctrl/pinctrl-msm8x74.c
@@ -402,7 +402,7 @@ static const unsigned int sdc2_data_pins[] = { 151 };
  * the pingroup table below.
  */
 enum msm8x74_functions {
-	MSM_MUX_cci_i2c,
+	MSM_MUX_cci_i2c0,
 	MSM_MUX_cci_i2c1,
 	MSM_MUX_blsp_i2c1,
 	MSM_MUX_blsp_i2c2,
@@ -473,6 +473,9 @@ enum msm8x74_functions {
 	MSM_MUX_blsp_uim10,
 	MSM_MUX_blsp_uim11,
 	MSM_MUX_blsp_uim12,
+	MSM_MUX_uim1,
+	MSM_MUX_uim2,
+	MSM_MUX_uim_batt_alarm,
 	MSM_MUX_sdc3,
 	MSM_MUX_sdc4,
 	MSM_MUX_gcc_gp_clk1,
@@ -481,9 +484,12 @@ enum msm8x74_functions {
 	MSM_MUX_qua_mi2s,
 	MSM_MUX_pri_mi2s,
 	MSM_MUX_spkr_mi2s,
+	MSM_MUX_ter_mi2s,
+	MSM_MUX_sec_mi2s,
 	MSM_MUX_hdmi_cec,
 	MSM_MUX_hdmi_ddc,
 	MSM_MUX_hdmi_hpd,
+	MSM_MUX_edp_hpd,
 	MSM_MUX_mdp_vsync,
 	MSM_MUX_cam_mclk0,
 	MSM_MUX_cam_mclk1,
@@ -497,6 +503,17 @@ enum msm8x74_functions {
 	MSM_MUX_cci_async_in0,
 	MSM_MUX_cci_async_in1,
 	MSM_MUX_cci_async_in2,
+	MSM_MUX_gp_pdm0,
+	MSM_MUX_gp_pdm1,
+	MSM_MUX_gp_pdm2,
+	MSM_MUX_gp0_clk,
+	MSM_MUX_gp1_clk,
+	MSM_MUX_gp_mn,
+	MSM_MUX_tsif1,
+	MSM_MUX_tsif2,
+	MSM_MUX_hsic,
+	MSM_MUX_grfc,
+	MSM_MUX_audio_ref_clk,
 	MSM_MUX_slimbus,
 	MSM_MUX_NA,
 };
@@ -531,7 +548,7 @@ static const char * const blsp_spi3_groups[] = {
 	"gpio8", "gpio9", "gpio10", "gpio11"
 };
 
-static const char * const cci_i2c_groups[] = { "gpio19", "gpio20" };
+static const char * const cci_i2c0_groups[] = { "gpio19", "gpio20" };
 static const char * const cci_i2c1_groups[] = { "gpio21", "gpio22" };
 
 static const char * const blsp_uart4_groups[] = { "gpio19", "gpio20" };
@@ -609,6 +626,16 @@ static const char * const blsp_spi12_groups[] = {
 	"gpio85", "gpio86", "gpio87", "gpio88"
 };
 
+static const char * const uim1_groups[] = {
+	"gpio97", "gpio98", "gpio99", "gpio100"
+};
+
+static const char * const uim2_groups[] = {
+	"gpio49", "gpio50", "gpio51", "gpio52"
+};
+
+static const char * const uim_batt_alarm_groups[] = { "gpio101" };
+
 static const char * const sdc3_groups[] = {
 	"gpio35", "gpio36", "gpio37", "gpio38", "gpio39", "gpio40"
 };
@@ -617,6 +644,9 @@ static const char * const sdc4_groups[] = {
 	"gpio91", "gpio92", "gpio93", "gpio94", "gpio95", "gpio96"
 };
 
+static const char * const gp0_clk_groups[] = { "gpio26" };
+static const char * const gp1_clk_groups[] = { "gpio27", "gpio57", "gpio78" };
+static const char * const gp_mn_groups[] = { "gpio29" };
 static const char * const gcc_gp_clk1_groups[] = { "gpio57", "gpio78" };
 static const char * const gcc_gp_clk2_groups[] = { "gpio58", "gpio81" };
 static const char * const gcc_gp_clk3_groups[] = { "gpio59", "gpio82" };
@@ -633,17 +663,18 @@ static const char * const spkr_mi2s_groups[] = {
 	"gpio69", "gpio70", "gpio71", "gpio72"
 };
 
-static const char * const hdmi_cec_groups[] = {
-	"gpio31"
+static const char * const ter_mi2s_groups[] = {
+	"gpio73", "gpio74", "gpio75", "gpio76", "gpio77"
 };
 
-static const char * const hdmi_ddc_groups[] = {
-	"gpio32", "gpio33"
+static const char * const sec_mi2s_groups[] = {
+	"gpio78", "gpio79", "gpio80", "gpio81", "gpio82"
 };
 
-static const char * const hdmi_hpd_groups[] = {
-	"gpio34"
-};
+static const char * const hdmi_cec_groups[] = { "gpio31" };
+static const char * const hdmi_ddc_groups[] = { "gpio32", "gpio33" };
+static const char * const hdmi_hpd_groups[] = { "gpio34" };
+static const char * const edp_hpd_groups[] = { "gpio102" };
 
 static const char * const mdp_vsync_groups[] = { "gpio12", "gpio13", "gpio14" };
 static const char * const cam_mclk0_groups[] = { "gpio15" };
@@ -660,11 +691,37 @@ static const char * const cci_async_in0_groups[] = { "gpio28" };
 static const char * const cci_async_in1_groups[] = { "gpio26" };
 static const char * const cci_async_in2_groups[] = { "gpio27" };
 
+static const char * const gp_pdm0_groups[] = { "gpio54", "gpio68" };
+static const char * const gp_pdm1_groups[] = { "gpio74", "gpio86" };
+static const char * const gp_pdm2_groups[] = { "gpio63", "gpio79" };
+
+static const char * const tsif1_groups[] = {
+	"gpio89", "gpio90", "gpio91", "gpio92"
+};
+
+static const char * const tsif2_groups[] = {
+	"gpio93", "gpio94", "gpio95", "gpio96"
+};
+
+static const char * const hsic_groups[] = { "gpio144", "gpio145" };
+static const char * const grfc_groups[] = {
+	"gpio104", "gpio105", "gpio106", "gpio107", "gpio108", "gpio109",
+	"gpio110", "gpio111", "gpio112", "gpio113", "gpio114", "gpio115",
+	"gpio116", "gpio117", "gpio118", "gpio119", "gpio120", "gpio121",
+	"gpio122", "gpio123", "gpio124", "gpio125", "gpio126", "gpio127",
+	"gpio128", "gpio136", "gpio137", "gpio141", "gpio143"
+};
+
+static const char * const audio_ref_clk_groups[] = { "gpio69" };
+
 static const char * const slimbus_groups[] = { "gpio70", "gpio71" };
 
 static const struct msm_function msm8x74_functions[] = {
-	FUNCTION(cci_i2c),
+	FUNCTION(cci_i2c0),
 	FUNCTION(cci_i2c1),
+	FUNCTION(uim1),
+	FUNCTION(uim2),
+	FUNCTION(uim_batt_alarm),
 	FUNCTION(blsp_uim1),
 	FUNCTION(blsp_uim2),
 	FUNCTION(blsp_uim3),
@@ -742,6 +799,8 @@ static const struct msm_function msm8x74_functions[] = {
 	FUNCTION(qua_mi2s),
 	FUNCTION(pri_mi2s),
 	FUNCTION(spkr_mi2s),
+	FUNCTION(ter_mi2s),
+	FUNCTION(sec_mi2s),
 	FUNCTION(mdp_vsync),
 	FUNCTION(cam_mclk0),
 	FUNCTION(cam_mclk1),
@@ -758,6 +817,18 @@ static const struct msm_function msm8x74_functions[] = {
 	FUNCTION(hdmi_cec),
 	FUNCTION(hdmi_ddc),
 	FUNCTION(hdmi_hpd),
+	FUNCTION(edp_hpd),
+	FUNCTION(gp_pdm0),
+	FUNCTION(gp_pdm1),
+	FUNCTION(gp_pdm2),
+	FUNCTION(gp0_clk),
+	FUNCTION(gp1_clk),
+	FUNCTION(gp_mn),
+	FUNCTION(tsif1),
+	FUNCTION(tsif2),
+	FUNCTION(hsic),
+	FUNCTION(grfc),
+	FUNCTION(audio_ref_clk),
 	FUNCTION(slimbus),
 };
 
@@ -781,17 +852,17 @@ static const struct msm_pingroup msm8x74_groups[] = {
 	PINGROUP(16,  cam_mclk1, NA, NA, NA, NA, NA, NA),
 	PINGROUP(17,  cam_mclk2, NA, NA, NA, NA, NA, NA),
 	PINGROUP(18,  cam_mclk3, NA, NA, NA, NA, NA, NA),
-	PINGROUP(19,  cci_i2c, blsp_spi4, blsp_uart4, blsp_uim4, NA, NA, NA),
-	PINGROUP(20,  cci_i2c, blsp_spi4, blsp_uart4, blsp_uim4, NA, NA, NA),
+	PINGROUP(19,  cci_i2c0, blsp_spi4, blsp_uart4, blsp_uim4, NA, NA, NA),
+	PINGROUP(20,  cci_i2c0, blsp_spi4, blsp_uart4, blsp_uim4, NA, NA, NA),
 	PINGROUP(21,  cci_i2c1, blsp_spi4, blsp_uart4_flow, blsp_i2c4, NA, NA, NA),
 	PINGROUP(22,  cci_i2c1, blsp_spi4, blsp_uart4_flow, blsp_i2c4, NA, NA, NA),
 	PINGROUP(23,  cci_timer0, blsp_spi5, blsp_uart5, blsp_uim5, NA, NA, NA),
 	PINGROUP(24,  cci_timer1, blsp_spi5, blsp_uart5, blsp_uim5, NA, NA, NA),
 	PINGROUP(25,  cci_timer2, blsp_spi5, blsp_uart5_flow, blsp_i2c5, NA, NA, NA),
-	PINGROUP(26,  cci_timer3, cci_async_in1, blsp_spi5, blsp_uart5_flow, blsp_i2c5, NA, NA),
-	PINGROUP(27,  cci_timer4, cci_async_in2, blsp_spi6, blsp_uart6, blsp_i2c6, NA, NA),
+	PINGROUP(26,  cci_timer3, cci_async_in1, blsp_spi5, blsp_uart5_flow, blsp_i2c5, gp0_clk, NA),
+	PINGROUP(27,  cci_timer4, cci_async_in2, blsp_spi6, blsp_uart6, blsp_i2c6, gp1_clk, NA),
 	PINGROUP(28,  cci_async_in0, blsp_spi6, blsp_uart6, blsp_uim6, NA, NA, NA),
-	PINGROUP(29,  blsp_spi6, blsp_uart6_flow, blsp_i2c6, NA, NA, NA, NA),
+	PINGROUP(29,  blsp_spi6, blsp_uart6_flow, blsp_i2c6, gp_mn, NA, NA, NA),
 	PINGROUP(30,  blsp_spi6, blsp_uart6_flow, blsp_i2c6, NA, NA, NA, NA),
 	PINGROUP(31,  hdmi_cec, NA, NA, NA, NA, NA, NA),
 	PINGROUP(32,  hdmi_ddc, NA, NA, NA, NA, NA, NA),
@@ -811,12 +882,12 @@ static const struct msm_pingroup msm8x74_groups[] = {
 	PINGROUP(46,  blsp_spi8, blsp_uart8, blsp_uim8, NA, NA, NA, NA),
 	PINGROUP(47,  blsp_spi8, blsp_uart8_flow, blsp_i2c8, blsp_spi10_cs1, NA, NA, NA),
 	PINGROUP(48,  blsp_spi8, blsp_uart8_flow, blsp_i2c8, blsp_spi10_cs2, NA, NA, NA),
-	PINGROUP(49,  NA, blsp_spi9, blsp_uart9, blsp_uim9, NA, NA, NA),
-	PINGROUP(50,  NA, blsp_spi9, blsp_uart9, blsp_uim9, NA, NA, NA),
-	PINGROUP(51,  NA, blsp_spi9, blsp_uart9_flow, blsp_i2c9, NA, NA, NA),
-	PINGROUP(52,  NA, blsp_spi9, blsp_uart9_flow, blsp_i2c9, NA, NA, NA),
+	PINGROUP(49,  uim2, blsp_spi9, blsp_uart9, blsp_uim9, NA, NA, NA),
+	PINGROUP(50,  uim2, blsp_spi9, blsp_uart9, blsp_uim9, NA, NA, NA),
+	PINGROUP(51,  uim2, blsp_spi9, blsp_uart9_flow, blsp_i2c9, NA, NA, NA),
+	PINGROUP(52,  uim2, blsp_spi9, blsp_uart9_flow, blsp_i2c9, NA, NA, NA),
 	PINGROUP(53,  blsp_spi10, blsp_uart10, blsp_uim10, blsp_spi2_cs1, NA, NA, NA),
-	PINGROUP(54,  blsp_spi10, blsp_uart10, blsp_uim10, blsp_spi2_cs2, NA, NA, NA),
+	PINGROUP(54,  blsp_spi10, blsp_uart10, blsp_uim10, blsp_spi2_cs2, gp_pdm0, NA, NA),
 	PINGROUP(55,  blsp_spi10, blsp_uart10_flow, blsp_i2c10, NA, NA, NA, NA),
 	PINGROUP(56,  blsp_spi10, blsp_uart10_flow, blsp_i2c10, NA, NA, NA, NA),
 	PINGROUP(57,  qua_mi2s, gcc_gp_clk1, NA, NA, NA, NA, NA),
@@ -825,72 +896,72 @@ static const struct msm_pingroup msm8x74_groups[] = {
 	PINGROUP(60,  qua_mi2s, NA, NA, NA, NA, NA, NA),
 	PINGROUP(61,  qua_mi2s, NA, NA, NA, NA, NA, NA),
 	PINGROUP(62,  qua_mi2s, blsp_spi2_cs1, NA, NA, NA, NA, NA),
-	PINGROUP(63,  qua_mi2s, blsp_spi2_cs2, NA, NA, NA, NA, NA),
+	PINGROUP(63,  qua_mi2s, blsp_spi2_cs2, gp_pdm2, NA, NA, NA, NA),
 	PINGROUP(64,  pri_mi2s, NA, NA, NA, NA, NA, NA),
 	PINGROUP(65,  pri_mi2s, NA, NA, NA, NA, NA, NA),
 	PINGROUP(66,  pri_mi2s, blsp_spi2_cs3, NA, NA, NA, NA, NA),
 	PINGROUP(67,  pri_mi2s, blsp_spi10_cs1, NA, NA, NA, NA, NA),
-	PINGROUP(68,  pri_mi2s, blsp_spi10_cs2, NA, NA, NA, NA, NA),
-	PINGROUP(69,  spkr_mi2s, NA, NA, NA, NA, NA, NA),
+	PINGROUP(68,  pri_mi2s, blsp_spi10_cs2, gp_pdm0, NA, NA, NA, NA),
+	PINGROUP(69,  spkr_mi2s, audio_ref_clk, NA, NA, NA, NA, NA),
 	PINGROUP(70,  slimbus, spkr_mi2s, NA, NA, NA, NA, NA),
 	PINGROUP(71,  slimbus, spkr_mi2s, NA, NA, NA, NA, NA),
-	PINGROUP(72,  spkr_mi2s, NA, NA, NA, NA, NA, NA),
-	PINGROUP(73,  NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(74,  NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(75,  NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(76,  NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(77,  NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(78,  NA, gcc_gp_clk1, NA, NA, NA, NA, NA),
-	PINGROUP(79,  NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(80,  NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(81,  NA, blsp_spi11, blsp_uart11, blsp_uim11, gcc_gp_clk2, NA, NA),
-	PINGROUP(82,  NA, blsp_spi11, blsp_uart11, blsp_uim11, gcc_gp_clk3, NA, NA),
+	PINGROUP(72,  NA, spkr_mi2s, NA, NA, NA, NA, NA),
+	PINGROUP(73,  ter_mi2s, NA, NA, NA, NA, NA, NA),
+	PINGROUP(74,  ter_mi2s, gp_pdm1, NA, NA, NA, NA, NA),
+	PINGROUP(75,  ter_mi2s, NA, NA, NA, NA, NA, NA),
+	PINGROUP(76,  ter_mi2s, NA, NA, NA, NA, NA, NA),
+	PINGROUP(77,  ter_mi2s, NA, NA, NA, NA, NA, NA),
+	PINGROUP(78,  sec_mi2s, gcc_gp_clk1, NA, NA, NA, NA, NA),
+	PINGROUP(79,  sec_mi2s, gp_pdm2, NA, NA, NA, NA, NA),
+	PINGROUP(80,  sec_mi2s, NA, NA, NA, NA, NA, NA),
+	PINGROUP(81,  sec_mi2s, blsp_spi11, blsp_uart11, blsp_uim11, gcc_gp_clk2, NA, NA),
+	PINGROUP(82,  sec_mi2s, blsp_spi11, blsp_uart11, blsp_uim11, gcc_gp_clk3, NA, NA),
 	PINGROUP(83,  blsp_spi11, blsp_uart11_flow, blsp_i2c11, NA, NA, NA, NA),
 	PINGROUP(84,  blsp_spi11, blsp_uart11_flow, blsp_i2c11, NA, NA, NA, NA),
 	PINGROUP(85,  blsp_spi12, blsp_uart12, blsp_uim12, NA, NA, NA, NA),
-	PINGROUP(86,  blsp_spi12, blsp_uart12, blsp_uim12, NA, NA, NA, NA),
+	PINGROUP(86,  blsp_spi12, blsp_uart12, blsp_uim12, gp_pdm1, NA, NA, NA),
 	PINGROUP(87,  blsp_spi12, blsp_uart12_flow, blsp_i2c12, NA, NA, NA, NA),
 	PINGROUP(88,  blsp_spi12, blsp_uart12_flow, blsp_i2c12, NA, NA, NA, NA),
-	PINGROUP(89,  NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(90,  NA, blsp_spi10_cs3, NA, NA, NA, NA, NA),
-	PINGROUP(91,  NA, sdc4, NA, NA, NA, NA, NA),
-	PINGROUP(92,  NA, sdc4, NA, NA, NA, NA, NA),
-	PINGROUP(93,  NA, sdc4, NA, NA, NA, NA, NA),
-	PINGROUP(94,  NA, sdc4, NA, NA, NA, NA, NA),
-	PINGROUP(95,  NA, sdc4, NA, NA, NA, NA, NA),
-	PINGROUP(96,  NA, sdc4, NA, NA, NA, NA, NA),
-	PINGROUP(97,  NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(98,  NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(99,  NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(100, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(101, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(102, NA, NA, NA, NA, NA, NA, NA),
+	PINGROUP(89,  tsif1, NA, NA, NA, NA, NA, NA),
+	PINGROUP(90,  tsif1, blsp_spi10_cs3, NA, NA, NA, NA, NA),
+	PINGROUP(91,  tsif1, sdc4, NA, NA, NA, NA, NA),
+	PINGROUP(92,  tsif1, sdc4, NA, NA, NA, NA, NA),
+	PINGROUP(93,  tsif2, sdc4, NA, NA, NA, NA, NA),
+	PINGROUP(94,  tsif2, sdc4, NA, NA, NA, NA, NA),
+	PINGROUP(95,  tsif2, sdc4, NA, NA, NA, NA, NA),
+	PINGROUP(96,  tsif2, sdc4, NA, NA, NA, NA, NA),
+	PINGROUP(97,  uim1, NA, NA, NA, NA, NA, NA),
+	PINGROUP(98,  uim1, NA, NA, NA, NA, NA, NA),
+	PINGROUP(99,  uim1, NA, NA, NA, NA, NA, NA),
+	PINGROUP(100, uim1, NA, NA, NA, NA, NA, NA),
+	PINGROUP(101, uim_batt_alarm, NA, NA, NA, NA, NA, NA),
+	PINGROUP(102, edp_hpd, NA, NA, NA, NA, NA, NA),
 	PINGROUP(103, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(104, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(105, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(106, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(107, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(108, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(109, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(110, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(111, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(112, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(113, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(114, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(115, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(116, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(117, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(118, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(119, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(120, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(121, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(122, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(123, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(124, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(125, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(126, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(127, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(128, NA, NA, NA, NA, NA, NA, NA),
+	PINGROUP(104, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(105, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(106, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(107, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(108, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(109, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(110, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(111, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(112, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(113, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(114, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(115, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(116, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(117, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(118, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(119, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(120, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(121, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(122, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(123, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(124, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(125, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(126, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(127, grfc, NA, NA, NA, NA, NA, NA),
+	PINGROUP(128, NA, grfc, NA, NA, NA, NA, NA),
 	PINGROUP(129, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(130, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(131, NA, NA, NA, NA, NA, NA, NA),
@@ -898,16 +969,16 @@ static const struct msm_pingroup msm8x74_groups[] = {
 	PINGROUP(133, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(134, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(135, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(136, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(137, NA, NA, NA, NA, NA, NA, NA),
+	PINGROUP(136, NA, grfc, NA, NA, NA, NA, NA),
+	PINGROUP(137, NA, grfc, NA, NA, NA, NA, NA),
 	PINGROUP(138, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(139, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(140, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(141, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(143, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(143, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(144, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(145, NA, NA, NA, NA, NA, NA, NA),
+	PINGROUP(141, NA, grfc, NA, NA, NA, NA, NA),
+	PINGROUP(142, NA, NA, NA, NA, NA, NA, NA),
+	PINGROUP(143, NA, grfc, NA, NA, NA, NA, NA),
+	PINGROUP(144, hsic, NA, NA, NA, NA, NA, NA),
+	PINGROUP(145, hsic, NA, NA, NA, NA, NA, NA),
 	SDC_PINGROUP(sdc1_clk, 0x2044, 13, 6),
 	SDC_PINGROUP(sdc1_cmd, 0x2044, 11, 3),
 	SDC_PINGROUP(sdc1_data, 0x2044, 9, 0),
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

