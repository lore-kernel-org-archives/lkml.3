Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaAMKjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:39:53 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:60984 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaAMKjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:39:51 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 2/2] pwm: imx: support polarity inversion
Date: Mon, 13 Jan 2014 11:29:48 +0100
Message-Id: <1389608988-10981-3-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1389608988-10981-1-git-send-email-LW@KARO-electronics.de>
References: <1389608988-10981-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i.MX PWM controller supports inverting the polarity of the PWM
output. Make this feature available in the pxm-imx driver.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 arch/arm/boot/dts/imx25.dtsi              |    7 ++++---
 arch/arm/boot/dts/imx27.dtsi              |    2 +-
 arch/arm/boot/dts/imx50.dtsi              |    4 ++--
 arch/arm/boot/dts/imx51.dtsi              |    4 ++--
 arch/arm/boot/dts/imx53-m53evk.dts        |    2 +-
 arch/arm/boot/dts/imx53-mba53.dts         |    2 +-
 arch/arm/boot/dts/imx53.dtsi              |    4 ++--
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi |    4 ++--
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi  |    4 ++--
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi    |    2 +-
 arch/arm/boot/dts/imx6qdl.dtsi            |    8 ++++----
 arch/arm/boot/dts/imx6sl.dtsi             |    8 ++++----
 drivers/pwm/pwm-imx.c                     |   29 +++++++++++++++++++++++++++++
 13 files changed, 55 insertions(+), 25 deletions(-)

diff --git a/arch/arm/boot/dts/imx25.dtsi b/arch/arm/boot/dts/imx25.dtsi
index 9e9e3b8..dcce08c 100644
--- a/arch/arm/boot/dts/imx25.dtsi
+++ b/arch/arm/boot/dts/imx25.dtsi
@@ -360,7 +360,7 @@
 
 			pwm2: pwm@53fa0000 {
 				compatible = "fsl,imx25-pwm", "fsl,imx27-pwm";
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				reg = <0x53fa0000 0x4000>;
 				clocks = <&clks 106>, <&clks 36>;
 				clock-names = "ipg", "per";
@@ -379,7 +379,7 @@
 
 			pwm3: pwm@53fa8000 {
 				compatible = "fsl,imx25-pwm", "fsl,imx27-pwm";
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				reg = <0x53fa8000 0x4000>;
 				clocks = <&clks 107>, <&clks 36>;
 				clock-names = "ipg", "per";
@@ -421,6 +421,7 @@
 
 			pwm4: pwm@53fc8000 {
 				compatible = "fsl,imx25-pwm", "fsl,imx27-pwm";
+				#pwm-cells = <3>;
 				reg = <0x53fc8000 0x4000>;
 				clocks = <&clks 108>, <&clks 36>;
 				clock-names = "ipg", "per";
@@ -467,7 +468,7 @@
 
 			pwm1: pwm@53fe0000 {
 				compatible = "fsl,imx25-pwm", "fsl,imx27-pwm";
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				reg = <0x53fe0000 0x4000>;
 				clocks = <&clks 105>, <&clks 36>;
 				clock-names = "ipg", "per";
diff --git a/arch/arm/boot/dts/imx27.dtsi b/arch/arm/boot/dts/imx27.dtsi
index 7e98966..be4c9bc 100644
--- a/arch/arm/boot/dts/imx27.dtsi
+++ b/arch/arm/boot/dts/imx27.dtsi
@@ -126,7 +126,7 @@
 			};
 
 			pwm: pwm@10006000 {
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				compatible = "fsl,imx27-pwm";
 				reg = <0x10006000 0x1000>;
 				interrupts = <23>;
diff --git a/arch/arm/boot/dts/imx50.dtsi b/arch/arm/boot/dts/imx50.dtsi
index 01c0499..e3647a8 100644
--- a/arch/arm/boot/dts/imx50.dtsi
+++ b/arch/arm/boot/dts/imx50.dtsi
@@ -273,7 +273,7 @@
 			};
 
 			pwm1: pwm@53fb4000 {
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				compatible = "fsl,imx50-pwm", "fsl,imx27-pwm";
 				reg = <0x53fb4000 0x4000>;
 				clocks = <&clks IMX5_CLK_PWM1_IPG_GATE>,
@@ -283,7 +283,7 @@
 			};
 
 			pwm2: pwm@53fb8000 {
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				compatible = "fsl,imx50-pwm", "fsl,imx27-pwm";
 				reg = <0x53fb8000 0x4000>;
 				clocks = <&clks IMX5_CLK_PWM2_IPG_GATE>,
diff --git a/arch/arm/boot/dts/imx51.dtsi b/arch/arm/boot/dts/imx51.dtsi
index 61a2552..c752ca2 100644
--- a/arch/arm/boot/dts/imx51.dtsi
+++ b/arch/arm/boot/dts/imx51.dtsi
@@ -339,7 +339,7 @@
 			};
 
 			pwm1: pwm@73fb4000 {
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				compatible = "fsl,imx51-pwm", "fsl,imx27-pwm";
 				reg = <0x73fb4000 0x4000>;
 				clocks = <&clks IMX5_CLK_PWM1_IPG_GATE>,
@@ -349,7 +349,7 @@
 			};
 
 			pwm2: pwm@73fb8000 {
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				compatible = "fsl,imx51-pwm", "fsl,imx27-pwm";
 				reg = <0x73fb8000 0x4000>;
 				clocks = <&clks IMX5_CLK_PWM2_IPG_GATE>,
diff --git a/arch/arm/boot/dts/imx53-m53evk.dts b/arch/arm/boot/dts/imx53-m53evk.dts
index c623774..65b9989 100644
--- a/arch/arm/boot/dts/imx53-m53evk.dts
+++ b/arch/arm/boot/dts/imx53-m53evk.dts
@@ -48,7 +48,7 @@
 
 	backlight {
 		compatible = "pwm-backlight";
-		pwms = <&pwm1 0 3000>;
+		pwms = <&pwm1 0 3000 0>;
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
 		power-supply = <&reg_backlight>;
diff --git a/arch/arm/boot/dts/imx53-mba53.dts b/arch/arm/boot/dts/imx53-mba53.dts
index 0358366..b09382a 100644
--- a/arch/arm/boot/dts/imx53-mba53.dts
+++ b/arch/arm/boot/dts/imx53-mba53.dts
@@ -19,7 +19,7 @@
 
 	backlight {
 		compatible = "pwm-backlight";
-		pwms = <&pwm2 0 50000>;
+		pwms = <&pwm2 0 50000 0>;
 		brightness-levels = <0 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100>;
 		default-brightness-level = <10>;
 		enable-gpios = <&gpio7 7 0>;
diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index 6407526..9011181 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -380,7 +380,7 @@
 			};
 
 			pwm1: pwm@53fb4000 {
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				compatible = "fsl,imx53-pwm", "fsl,imx27-pwm";
 				reg = <0x53fb4000 0x4000>;
 				clocks = <&clks IMX5_CLK_PWM1_IPG_GATE>,
@@ -390,7 +390,7 @@
 			};
 
 			pwm2: pwm@53fb8000 {
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				compatible = "fsl,imx53-pwm", "fsl,imx27-pwm";
 				reg = <0x53fb8000 0x4000>;
 				clocks = <&clks IMX5_CLK_PWM2_IPG_GATE>,
diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
index e83ffc7..9c3ef80 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
@@ -111,7 +111,7 @@
 
 	backlight_lcd {
 		compatible = "pwm-backlight";
-		pwms = <&pwm1 0 5000000>;
+		pwms = <&pwm1 0 5000000 0>;
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <7>;
 		power-supply = <&reg_3p3v>;
@@ -120,7 +120,7 @@
 
 	backlight_lvds {
 		compatible = "pwm-backlight";
-		pwms = <&pwm4 0 5000000>;
+		pwms = <&pwm4 0 5000000 0>;
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <7>;
 		power-supply = <&reg_3p3v>;
diff --git a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
index e8cbcd7..8833329 100644
--- a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
@@ -110,7 +110,7 @@
 
 	backlight_lcd {
 		compatible = "pwm-backlight";
-		pwms = <&pwm1 0 5000000>;
+		pwms = <&pwm1 0 5000000 0>;
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <7>;
 		power-supply = <&reg_3p3v>;
@@ -119,7 +119,7 @@
 
 	backlight_lvds {
 		compatible = "pwm-backlight";
-		pwms = <&pwm4 0 5000000>;
+		pwms = <&pwm4 0 5000000 0>;
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <7>;
 		power-supply = <&reg_3p3v>;
diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index c072d46..ae487bee 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -99,7 +99,7 @@
 
 	backlight {
 		compatible = "pwm-backlight";
-		pwms = <&pwm1 0 5000000>;
+		pwms = <&pwm1 0 5000000 0>;
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <7>;
 		status = "okay";
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index da0d843..e10c7b7 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -306,7 +306,7 @@
 			};
 
 			pwm1: pwm@02080000 {
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				compatible = "fsl,imx6q-pwm", "fsl,imx27-pwm";
 				reg = <0x02080000 0x4000>;
 				interrupts = <0 83 IRQ_TYPE_LEVEL_HIGH>;
@@ -315,7 +315,7 @@
 			};
 
 			pwm2: pwm@02084000 {
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				compatible = "fsl,imx6q-pwm", "fsl,imx27-pwm";
 				reg = <0x02084000 0x4000>;
 				interrupts = <0 84 IRQ_TYPE_LEVEL_HIGH>;
@@ -324,7 +324,7 @@
 			};
 
 			pwm3: pwm@02088000 {
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				compatible = "fsl,imx6q-pwm", "fsl,imx27-pwm";
 				reg = <0x02088000 0x4000>;
 				interrupts = <0 85 IRQ_TYPE_LEVEL_HIGH>;
@@ -333,7 +333,7 @@
 			};
 
 			pwm4: pwm@0208c000 {
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				compatible = "fsl,imx6q-pwm", "fsl,imx27-pwm";
 				reg = <0x0208c000 0x4000>;
 				interrupts = <0 86 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index fcefa1c..9862ee2 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -289,7 +289,7 @@
 			};
 
 			pwm1: pwm@02080000 {
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				compatible = "fsl,imx6sl-pwm", "fsl,imx27-pwm";
 				reg = <0x02080000 0x4000>;
 				interrupts = <0 83 IRQ_TYPE_LEVEL_HIGH>;
@@ -299,7 +299,7 @@
 			};
 
 			pwm2: pwm@02084000 {
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				compatible = "fsl,imx6sl-pwm", "fsl,imx27-pwm";
 				reg = <0x02084000 0x4000>;
 				interrupts = <0 84 IRQ_TYPE_LEVEL_HIGH>;
@@ -309,7 +309,7 @@
 			};
 
 			pwm3: pwm@02088000 {
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				compatible = "fsl,imx6sl-pwm", "fsl,imx27-pwm";
 				reg = <0x02088000 0x4000>;
 				interrupts = <0 85 IRQ_TYPE_LEVEL_HIGH>;
@@ -319,7 +319,7 @@
 			};
 
 			pwm4: pwm@0208c000 {
-				#pwm-cells = <2>;
+				#pwm-cells = <3>;
 				compatible = "fsl,imx6sl-pwm", "fsl,imx27-pwm";
 				reg = <0x0208c000 0x4000>;
 				interrupts = <0 86 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 3b00a82..75a0d14 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -36,6 +36,7 @@
 #define MX3_PWMCR_DOZEEN		(1 << 24)
 #define MX3_PWMCR_WAITEN		(1 << 23)
 #define MX3_PWMCR_DBGEN			(1 << 22)
+#define MX3_PWMCR_POUTC			(1 << 18)
 #define MX3_PWMCR_CLKSRC_IPG_HIGH	(2 << 16)
 #define MX3_PWMCR_CLKSRC_IPG		(1 << 16)
 #define MX3_PWMCR_EN			(1 << 0)
@@ -138,6 +139,9 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
 	if (test_bit(PWMF_ENABLED, &pwm->flags))
 		cr |= MX3_PWMCR_EN;
 
+	if (pwm->polarity == PWM_POLARITY_INVERSED)
+		cr |= MX3_PWMCR_POUTC;
+
 	writel(cr, imx->mmio_base + MX3_PWMCR);
 
 	return 0;
@@ -155,6 +159,11 @@ static void imx_pwm_set_enable_v2(struct pwm_chip *chip, bool enable)
 	else
 		val &= ~MX3_PWMCR_EN;
 
+	if (chip->pwms[0].polarity == PWM_POLARITY_INVERSED)
+		val |= MX3_PWMCR_POUTC;
+	else
+		val &= ~MX3_PWMCR_POUTC;
+
 	writel(val, imx->mmio_base + MX3_PWMCR);
 }
 
@@ -198,6 +207,17 @@ static void imx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	clk_disable_unprepare(imx->clk_per);
 }
 
+static int imx_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
+				enum pwm_polarity polarity)
+{
+	struct imx_chip *imx = to_imx_chip(chip);
+
+	dev_info(imx->chip.dev, "%s: polarity set to %s\n", __func__,
+		polarity == PWM_POLARITY_INVERSED ? "inverted" : "normal");
+
+	return 0;
+}
+
 static struct pwm_ops imx_pwm_ops = {
 	.enable = imx_pwm_enable,
 	.disable = imx_pwm_disable,
@@ -209,6 +229,7 @@ struct imx_pwm_data {
 	int (*config)(struct pwm_chip *chip,
 		struct pwm_device *pwm, int duty_ns, int period_ns);
 	void (*set_enable)(struct pwm_chip *chip, bool enable);
+	unsigned output_polarity:1;
 };
 
 static struct imx_pwm_data imx_pwm_data_v1 = {
@@ -219,6 +240,7 @@ static struct imx_pwm_data imx_pwm_data_v1 = {
 static struct imx_pwm_data imx_pwm_data_v2 = {
 	.config = imx_pwm_config_v2,
 	.set_enable = imx_pwm_set_enable_v2,
+	.output_polarity = 1,
 };
 
 static const struct of_device_id imx_pwm_dt_ids[] = {
@@ -271,6 +293,13 @@ static int imx_pwm_probe(struct platform_device *pdev)
 		return PTR_ERR(imx->mmio_base);
 
 	data = of_id->data;
+	if (data->output_polarity) {
+		dev_info(&pdev->dev, "PWM supports inversion\n");
+		imx_pwm_ops.set_polarity = imx_pwm_set_polarity;
+		imx->chip.of_xlate = of_pwm_xlate_with_flags;
+		imx->chip.of_pwm_n_cells = 3;
+	}
+
 	imx->config = data->config;
 	imx->set_enable = data->set_enable;
 
-- 
1.7.2.5

