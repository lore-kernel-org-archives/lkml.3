Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbaGLBVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 21:21:31 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:12475 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170AbaGLBV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 21:21:29 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] pinctrl: qcom: Make muxing of gpio function explicit
Date: Fri, 11 Jul 2014 18:21:24 -0700
Message-ID: <1405128084-15731-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of relying on pinmux->disable(), make the gpio function an
explicit function for all pins that supports it.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---

This fixes the regression that was introduced by removing the disable function
from the pinmux ops. I was exploiting the disable function to put the gpio pins
"back" into gpio state and this was apparently not the right way to do things.

 .../bindings/pinctrl/qcom,apq8064-pinctrl.txt      |  2 +-
 .../bindings/pinctrl/qcom,ipq8064-pinctrl.txt      |  2 +-
 .../bindings/pinctrl/qcom,msm8960-pinctrl.txt      |  4 +--
 .../bindings/pinctrl/qcom,msm8974-pinctrl.txt      |  2 +-
 drivers/pinctrl/qcom/pinctrl-apq8064.c             | 19 +++++++++++++-
 drivers/pinctrl/qcom/pinctrl-ipq8064.c             | 17 +++++++++++-
 drivers/pinctrl/qcom/pinctrl-msm8960.c             | 30 +++++++++++++++++++++-
 drivers/pinctrl/qcom/pinctrl-msm8x74.c             | 29 ++++++++++++++++++++-
 8 files changed, 96 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt
index 7181f92..0211c6d 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,apq8064-pinctrl.txt
@@ -46,7 +46,7 @@ Valid values for pins are:
   gpio0-gpio89
 
 Valid values for function are:
-  cam_mclk, codec_mic_i2s, codec_spkr_i2s, gsbi1, gsbi2, gsbi3, gsbi4,
+  cam_mclk, codec_mic_i2s, codec_spkr_i2s, gpio, gsbi1, gsbi2, gsbi3, gsbi4,
   gsbi4_cam_i2c, gsbi5, gsbi5_spi_cs1, gsbi5_spi_cs2, gsbi5_spi_cs3, gsbi6,
   gsbi6_spi_cs1, gsbi6_spi_cs2, gsbi6_spi_cs3, gsbi7, gsbi7_spi_cs1,
   gsbi7_spi_cs2, gsbi7_spi_cs3, gsbi_cam_i2c, hdmi, mi2s, riva_bt, riva_fm,
diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,ipq8064-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,ipq8064-pinctrl.txt
index e0d35a4..e33e4dc 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,ipq8064-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,ipq8064-pinctrl.txt
@@ -51,7 +51,7 @@ Valid values for qcom,pins are:
 
 
 Valid values for function are:
-  mdio, mi2s, pdm, ssbi, spmi, audio_pcm, gsbi1, gsbi2, gsbi4, gsbi5,
+  mdio, mi2s, pdm, ssbi, spmi, audio_pcm, gpio, gsbi1, gsbi2, gsbi4, gsbi5,
   gsbi5_spi_cs1, gsbi5_spi_cs2, gsbi5_spi_cs3, gsbi6, gsbi7, nss_spi, sdc1,
   spdif, nand, tsif1, tsif2, usb_fs_n, usb_fs, usb2_hsic, rgmii2, sata,
   pcie1_rst, pcie1_prsnt, pcie1_pwren_n, pcie1_pwren, pcie1_pwrflt,
diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt
index 7dece8d..93b7de9 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt
@@ -83,7 +83,7 @@ to specify in a pin configuration subnode:
 		    sdc3_data
 
 - function:
-	Usage: optional
+	Usage: required
 	Value type: <string>
 	Definition: Specify the alternative function to be configured for the
 		    specified pins. Functions are only valid for gpio pins.
@@ -92,7 +92,7 @@ to specify in a pin configuration subnode:
 		    codec_mic_i2s, codec_spkr_i2s, ext_gps, fm, gps_blanking,
 		    gps_pps_in, gps_pps_out, gp_clk_0a, gp_clk_0b, gp_clk_1a,
 		    gp_clk_1b, gp_clk_2a, gp_clk_2b, gp_mn, gp_pdm_0a,
-		    gp_pdm_0b, gp_pdm_1a, gp_pdm_1b, gp_pdm_2a, gp_pdm_2b,
+		    gp_pdm_0b, gp_pdm_1a, gp_pdm_1b, gp_pdm_2a, gp_pdm_2b, gpio,
 		    gsbi1, gsbi1_spi_cs1_n, gsbi1_spi_cs2a_n, gsbi1_spi_cs2b_n,
 		    gsbi1_spi_cs3_n, gsbi2, gsbi2_spi_cs1_n, gsbi2_spi_cs2_n,
 		    gsbi2_spi_cs3_n, gsbi3, gsbi4, gsbi4_3d_cam_i2c_l,
diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt
index 73262b5..d2ea80d 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt
@@ -70,7 +70,7 @@ Valid values for function are:
   cam_mckl0, cam_mclk1, cam_mclk2, cam_mclk3, mdp_vsync, hdmi_cec, hdmi_ddc,
   hdmi_hpd, edp_hpd, gp_pdm0, gp_pdm1, gp_pdm2, gp_pdm3, gp0_clk, gp1_clk,
   gp_mn, tsif1, tsif2, hsic, grfc, audio_ref_clk, qua_mi2s, pri_mi2s, spkr_mi2s,
-  ter_mi2s, sec_mi2s, bt, fm, wlan, slimbus
+  ter_mi2s, sec_mi2s, bt, fm, wlan, slimbus, gpio
 
   (Note that this is not yet the complete list of functions)
 
diff --git a/drivers/pinctrl/qcom/pinctrl-apq8064.c b/drivers/pinctrl/qcom/pinctrl-apq8064.c
index 519f788..feb6f15 100644
--- a/drivers/pinctrl/qcom/pinctrl-apq8064.c
+++ b/drivers/pinctrl/qcom/pinctrl-apq8064.c
@@ -230,7 +230,7 @@ static const unsigned int sdc3_data_pins[] = { 95 };
 		.pins = gpio##id##_pins,		\
 		.npins = ARRAY_SIZE(gpio##id##_pins),	\
 		.funcs = (int[]){			\
-			APQ_MUX_NA, /* gpio mode */	\
+			APQ_MUX_gpio,			\
 			APQ_MUX_##f1,			\
 			APQ_MUX_##f2,			\
 			APQ_MUX_##f3,			\
@@ -293,6 +293,7 @@ enum apq8064_functions {
 	APQ_MUX_cam_mclk,
 	APQ_MUX_codec_mic_i2s,
 	APQ_MUX_codec_spkr_i2s,
+	APQ_MUX_gpio,
 	APQ_MUX_gsbi1,
 	APQ_MUX_gsbi2,
 	APQ_MUX_gsbi3,
@@ -335,6 +336,21 @@ static const char * const codec_mic_i2s_groups[] = {
 static const char * const codec_spkr_i2s_groups[] = {
 	"gpio39", "gpio40", "gpio41", "gpio42"
 };
+static const char * const gpio_groups[] = {
+	"gpio0", "gpio1", "gpio2", "gpio3", "gpio4", "gpio5", "gpio6", "gpio7",
+	"gpio8", "gpio9", "gpio10", "gpio11", "gpio12", "gpio13", "gpio14",
+	"gpio15", "gpio16", "gpio17", "gpio18", "gpio19", "gpio20", "gpio21",
+	"gpio22", "gpio23", "gpio24", "gpio25", "gpio26", "gpio27", "gpio28",
+	"gpio29", "gpio30", "gpio31", "gpio32", "gpio33", "gpio34", "gpio35",
+	"gpio36", "gpio37", "gpio38", "gpio39", "gpio40", "gpio41", "gpio42",
+	"gpio43", "gpio44", "gpio45", "gpio46", "gpio47", "gpio48", "gpio49",
+	"gpio50", "gpio51", "gpio52", "gpio53", "gpio54", "gpio55", "gpio56",
+	"gpio57", "gpio58", "gpio59", "gpio60", "gpio61", "gpio62", "gpio63",
+	"gpio64", "gpio65", "gpio66", "gpio67", "gpio68", "gpio69", "gpio70",
+	"gpio71", "gpio72", "gpio73", "gpio74", "gpio75", "gpio76", "gpio77",
+	"gpio78", "gpio79", "gpio80", "gpio81", "gpio82", "gpio83", "gpio84",
+	"gpio85", "gpio86", "gpio87", "gpio88", "gpio89"
+};
 static const char * const gsbi1_groups[] = {
 	"gpio18", "gpio19", "gpio20", "gpio21"
 };
@@ -430,6 +446,7 @@ static const struct msm_function apq8064_functions[] = {
 	FUNCTION(cam_mclk),
 	FUNCTION(codec_mic_i2s),
 	FUNCTION(codec_spkr_i2s),
+	FUNCTION(gpio),
 	FUNCTION(gsbi1),
 	FUNCTION(gsbi2),
 	FUNCTION(gsbi3),
diff --git a/drivers/pinctrl/qcom/pinctrl-ipq8064.c b/drivers/pinctrl/qcom/pinctrl-ipq8064.c
index acafea4..767cf11 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq8064.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq8064.c
@@ -183,7 +183,7 @@ static const unsigned int sdc3_data_pins[] = { 71 };
 		.pins = gpio##id##_pins,		\
 		.npins = ARRAY_SIZE(gpio##id##_pins),	\
 		.funcs = (int[]){			\
-			IPQ_MUX_NA, /* gpio mode */	\
+			IPQ_MUX_gpio,			\
 			IPQ_MUX_##f1,			\
 			IPQ_MUX_##f2,			\
 			IPQ_MUX_##f3,			\
@@ -243,6 +243,7 @@ static const unsigned int sdc3_data_pins[] = { 71 };
 	}
 
 enum ipq8064_functions {
+	IPQ_MUX_gpio,
 	IPQ_MUX_mdio,
 	IPQ_MUX_mi2s,
 	IPQ_MUX_pdm,
@@ -291,6 +292,19 @@ enum ipq8064_functions {
 	IPQ_MUX_NA,
 };
 
+static const char * const gpio_groups[] = {
+	"gpio0", "gpio1", "gpio2", "gpio3", "gpio4", "gpio5", "gpio6", "gpio7",
+	"gpio8", "gpio9", "gpio10", "gpio11", "gpio12", "gpio13", "gpio14",
+	"gpio15", "gpio16", "gpio17", "gpio18", "gpio19", "gpio20", "gpio21",
+	"gpio22", "gpio23", "gpio24", "gpio25", "gpio26", "gpio27", "gpio28",
+	"gpio29", "gpio30", "gpio31", "gpio32", "gpio33", "gpio34", "gpio35",
+	"gpio36", "gpio37", "gpio38", "gpio39", "gpio40", "gpio41", "gpio42",
+	"gpio43", "gpio44", "gpio45", "gpio46", "gpio47", "gpio48", "gpio49",
+	"gpio50", "gpio51", "gpio52", "gpio53", "gpio54", "gpio55", "gpio56",
+	"gpio57", "gpio58", "gpio59", "gpio60", "gpio61", "gpio62", "gpio63",
+	"gpio64", "gpio65", "gpio66", "gpio67", "gpio68"
+};
+
 static const char * const mdio_groups[] = {
 	"gpio0", "gpio1", "gpio10", "gpio11",
 };
@@ -481,6 +495,7 @@ static const char * const ps_hold_groups[] = {
 };
 
 static const struct msm_function ipq8064_functions[] = {
+	FUNCTION(gpio),
 	FUNCTION(mdio),
 	FUNCTION(ssbi),
 	FUNCTION(spmi),
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8960.c b/drivers/pinctrl/qcom/pinctrl-msm8960.c
index 564543b..3504703 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8960.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8960.c
@@ -355,7 +355,7 @@ static const unsigned int sdc3_data_pins[] = { 157 };
 		.pins = gpio##id##_pins,		\
 		.npins = ARRAY_SIZE(gpio##id##_pins),	\
 		.funcs = (int[]){			\
-			MSM_MUX_NA, /* gpio mode */	\
+			MSM_MUX_gpio,			\
 			MSM_MUX_##f1,			\
 			MSM_MUX_##f2,			\
 			MSM_MUX_##f3,			\
@@ -441,6 +441,7 @@ enum msm8960_functions {
 	MSM_MUX_gp_pdm_1b,
 	MSM_MUX_gp_pdm_2a,
 	MSM_MUX_gp_pdm_2b,
+	MSM_MUX_gpio,
 	MSM_MUX_gsbi1,
 	MSM_MUX_gsbi1_spi_cs1_n,
 	MSM_MUX_gsbi1_spi_cs2a_n,
@@ -622,6 +623,32 @@ static const char * const gp_pdm_2b_groups[] = {
 	"gpio53"
 };
 
+static const char * const gpio_groups[] = {
+	"gpio0", "gpio1", "gpio2", "gpio3", "gpio4", "gpio5", "gpio6", "gpio7",
+	"gpio8", "gpio9", "gpio10", "gpio11", "gpio12", "gpio13", "gpio14",
+	"gpio15", "gpio16", "gpio17", "gpio18", "gpio19", "gpio20", "gpio21",
+	"gpio22", "gpio23", "gpio24", "gpio25", "gpio26", "gpio27", "gpio28",
+	"gpio29", "gpio30", "gpio31", "gpio32", "gpio33", "gpio34", "gpio35",
+	"gpio36", "gpio37", "gpio38", "gpio39", "gpio40", "gpio41", "gpio42",
+	"gpio43", "gpio44", "gpio45", "gpio46", "gpio47", "gpio48", "gpio49",
+	"gpio50", "gpio51", "gpio52", "gpio53", "gpio54", "gpio55", "gpio56",
+	"gpio57", "gpio58", "gpio59", "gpio60", "gpio61", "gpio62", "gpio63",
+	"gpio64", "gpio65", "gpio66", "gpio67", "gpio68", "gpio69", "gpio70",
+	"gpio71", "gpio72", "gpio73", "gpio74", "gpio75", "gpio76", "gpio77",
+	"gpio78", "gpio79", "gpio80", "gpio81", "gpio82", "gpio83", "gpio84",
+	"gpio85", "gpio86", "gpio87", "gpio88", "gpio89", "gpio90", "gpio91",
+	"gpio92", "gpio93", "gpio94", "gpio95", "gpio96", "gpio97", "gpio98",
+	"gpio99", "gpio100", "gpio101", "gpio102", "gpio103", "gpio104",
+	"gpio105", "gpio106", "gpio107", "gpio108", "gpio109", "gpio110",
+	"gpio111", "gpio112", "gpio113", "gpio114", "gpio115", "gpio116",
+	"gpio117", "gpio118", "gpio119", "gpio120", "gpio121", "gpio122",
+	"gpio123", "gpio124", "gpio125", "gpio126", "gpio127", "gpio128",
+	"gpio129", "gpio130", "gpio131", "gpio132", "gpio133", "gpio134",
+	"gpio135", "gpio136", "gpio137", "gpio138", "gpio139", "gpio140",
+	"gpio141", "gpio142", "gpio143", "gpio144", "gpio145", "gpio146",
+	"gpio147", "gpio148", "gpio149", "gpio150", "gpio151"
+};
+
 static const char * const gsbi1_groups[] = {
 	"gpio6", "gpio7", "gpio8", "gpio9"
 };
@@ -961,6 +988,7 @@ static const struct msm_function msm8960_functions[] = {
 	FUNCTION(gp_pdm_1b),
 	FUNCTION(gp_pdm_2a),
 	FUNCTION(gp_pdm_2b),
+	FUNCTION(gpio),
 	FUNCTION(gsbi1),
 	FUNCTION(gsbi1_spi_cs1_n),
 	FUNCTION(gsbi1_spi_cs2a_n),
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8x74.c b/drivers/pinctrl/qcom/pinctrl-msm8x74.c
index 4183069..8c97201 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8x74.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8x74.c
@@ -342,7 +342,7 @@ static const unsigned int sdc2_data_pins[] = { 151 };
 		.pins = gpio##id##_pins,		\
 		.npins = ARRAY_SIZE(gpio##id##_pins),	\
 		.funcs = (int[]){			\
-			MSM_MUX_NA, /* gpio mode */	\
+			MSM_MUX_gpio,			\
 			MSM_MUX_##f1,			\
 			MSM_MUX_##f2,			\
 			MSM_MUX_##f3,			\
@@ -402,6 +402,7 @@ static const unsigned int sdc2_data_pins[] = { 151 };
  * the pingroup table below.
  */
 enum msm8x74_functions {
+	MSM_MUX_gpio,
 	MSM_MUX_cci_i2c0,
 	MSM_MUX_cci_i2c1,
 	MSM_MUX_blsp_i2c1,
@@ -509,6 +510,31 @@ enum msm8x74_functions {
 	MSM_MUX_NA,
 };
 
+static const char * const gpio_groups[] = {
+	"gpio0", "gpio1", "gpio2", "gpio3", "gpio4", "gpio5", "gpio6", "gpio7",
+	"gpio8", "gpio9", "gpio10", "gpio11", "gpio12", "gpio13", "gpio14",
+	"gpio15", "gpio16", "gpio17", "gpio18", "gpio19", "gpio20", "gpio21",
+	"gpio22", "gpio23", "gpio24", "gpio25", "gpio26", "gpio27", "gpio28",
+	"gpio29", "gpio30", "gpio31", "gpio32", "gpio33", "gpio34", "gpio35",
+	"gpio36", "gpio37", "gpio38", "gpio39", "gpio40", "gpio41", "gpio42",
+	"gpio43", "gpio44", "gpio45", "gpio46", "gpio47", "gpio48", "gpio49",
+	"gpio50", "gpio51", "gpio52", "gpio53", "gpio54", "gpio55", "gpio56",
+	"gpio57", "gpio58", "gpio59", "gpio60", "gpio61", "gpio62", "gpio63",
+	"gpio64", "gpio65", "gpio66", "gpio67", "gpio68", "gpio69", "gpio70",
+	"gpio71", "gpio72", "gpio73", "gpio74", "gpio75", "gpio76", "gpio77",
+	"gpio78", "gpio79", "gpio80", "gpio81", "gpio82", "gpio83", "gpio84",
+	"gpio85", "gpio86", "gpio87", "gpio88", "gpio89", "gpio90", "gpio91",
+	"gpio92", "gpio93", "gpio94", "gpio95", "gpio96", "gpio97", "gpio98",
+	"gpio99", "gpio100", "gpio101", "gpio102", "gpio103", "gpio104",
+	"gpio105", "gpio106", "gpio107", "gpio108", "gpio109", "gpio110",
+	"gpio111", "gpio112", "gpio113", "gpio114", "gpio115", "gpio116",
+	"gpio117", "gpio118", "gpio119", "gpio120", "gpio121", "gpio122",
+	"gpio123", "gpio124", "gpio125", "gpio126", "gpio127", "gpio128",
+	"gpio129", "gpio130", "gpio131", "gpio132", "gpio133", "gpio134",
+	"gpio135", "gpio136", "gpio137", "gpio138", "gpio139", "gpio140",
+	"gpio141", "gpio142", "gpio143", "gpio144", "gpio145"
+};
+
 static const char * const blsp_uart1_groups[] = {
 	"gpio0", "gpio1", "gpio2", "gpio3"
 };
@@ -728,6 +754,7 @@ static const char * const wlan_groups[] = {
 static const char * const slimbus_groups[] = { "gpio70", "gpio71" };
 
 static const struct msm_function msm8x74_functions[] = {
+	FUNCTION(gpio),
 	FUNCTION(cci_i2c0),
 	FUNCTION(cci_i2c1),
 	FUNCTION(uim1),
-- 
1.8.2.2

