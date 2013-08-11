Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3HKQzV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:55:21 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:18222
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754235Ab3HKQwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:52:04 -0400
X-IronPort-AV: E=Sophos;i="4.89,857,1367964000"; 
   d="scan'208";a="23717946"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/16] arch/arm/mach-pxa: Avoid using ARRAY_AND_SIZE(e) as a function argument
Date: Sun, 11 Aug 2013 18:51:43 +0200
Message-Id: <1376239917-15594-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
arity of the called function.

The semantic match that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,f;
@@

f(...,
- ARRAY_AND_SIZE(e)
+ e,ARRAY_SIZE(e)
  ,...)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.

 arch/arm/mach-pxa/am200epd.c          |    2 +-
 arch/arm/mach-pxa/am300epd.c          |    2 +-
 arch/arm/mach-pxa/balloon3.c          |   27 ++++++++++++++++++---------
 arch/arm/mach-pxa/cm-x255.c           |    4 ++--
 arch/arm/mach-pxa/cm-x270.c           |   13 ++++++++-----
 arch/arm/mach-pxa/cm-x300.c           |   16 ++++++++++------
 arch/arm/mach-pxa/colibri-evalboard.c |    3 ++-
 arch/arm/mach-pxa/colibri-pxa270.c    |   10 ++++++----
 arch/arm/mach-pxa/colibri-pxa300.c    |   12 ++++++++----
 arch/arm/mach-pxa/colibri-pxa320.c    |   12 ++++++++----
 arch/arm/mach-pxa/corgi.c             |    8 +++++---
 arch/arm/mach-pxa/corgi_pm.c          |    2 +-
 arch/arm/mach-pxa/csb726.c            |    2 +-
 arch/arm/mach-pxa/em-x270.c           |   18 +++++++++++-------
 arch/arm/mach-pxa/eseries.c           |   20 ++++++++++----------
 arch/arm/mach-pxa/generic.c           |    2 +-
 arch/arm/mach-pxa/gumstix.c           |    2 +-
 arch/arm/mach-pxa/h5000.c             |    4 ++--
 arch/arm/mach-pxa/icontrol.c          |    8 +++++---
 arch/arm/mach-pxa/idp.c               |    2 +-
 arch/arm/mach-pxa/littleton.c         |    8 +++++---
 arch/arm/mach-pxa/lpd270.c            |    2 +-
 arch/arm/mach-pxa/lubbock.c           |    2 +-
 arch/arm/mach-pxa/magician.c          |   13 ++++++++-----
 arch/arm/mach-pxa/mainstone.c         |    3 ++-
 arch/arm/mach-pxa/mxm8x10.c           |    2 +-
 arch/arm/mach-pxa/palm27x.c           |    3 ++-
 arch/arm/mach-pxa/pcm990-baseboard.c  |    8 +++++---
 arch/arm/mach-pxa/poodle.c            |    8 +++++---
 arch/arm/mach-pxa/pxa25x.c            |    2 +-
 arch/arm/mach-pxa/pxa27x.c            |    2 +-
 arch/arm/mach-pxa/pxa300.c            |    4 ++--
 arch/arm/mach-pxa/pxa320.c            |    2 +-
 arch/arm/mach-pxa/pxa3xx.c            |    2 +-
 arch/arm/mach-pxa/raumfeld.c          |   24 ++++++++++++++++--------
 arch/arm/mach-pxa/saar.c              |   19 ++++++++++++-------
 arch/arm/mach-pxa/spitz.c             |    8 +++++---
 arch/arm/mach-pxa/spitz_pm.c          |    3 ++-
 arch/arm/mach-pxa/tavorevb.c          |   11 ++++++-----
 arch/arm/mach-pxa/tosa.c              |    2 +-
 arch/arm/mach-pxa/trizeps4.c          |    6 ++++--
 arch/arm/mach-pxa/viper.c             |    5 +++--
 arch/arm/mach-pxa/xcep.c              |    4 ++--
 arch/arm/mach-pxa/zeus.c              |    5 +++--
 arch/arm/mach-pxa/zylonite_pxa300.c   |    9 +++++----
 arch/arm/mach-pxa/zylonite_pxa320.c   |    2 +-
 46 files changed, 198 insertions(+), 130 deletions(-)

diff --git a/arch/arm/mach-pxa/am200epd.c b/arch/arm/mach-pxa/am200epd.c
index ffa6d81..9b95bce 100644
--- a/arch/arm/mach-pxa/am200epd.c
+++ b/arch/arm/mach-pxa/am200epd.c
@@ -352,7 +352,7 @@ int __init am200_init(void)
 	 * creation events */
 	fb_register_client(&am200_fb_notif);
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(am200_pin_config));
+	pxa2xx_mfp_config(am200_pin_config, ARRAY_SIZE(am200_pin_config));
 
 	/* request our platform independent driver */
 	request_module("metronomefb");
diff --git a/arch/arm/mach-pxa/am300epd.c b/arch/arm/mach-pxa/am300epd.c
index 3dfec1e..2e99184 100644
--- a/arch/arm/mach-pxa/am300epd.c
+++ b/arch/arm/mach-pxa/am300epd.c
@@ -265,7 +265,7 @@ int __init am300_init(void)
 {
 	int ret;
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(am300_pin_config));
+	pxa2xx_mfp_config(am300_pin_config, ARRAY_SIZE(am300_pin_config));
 
 	/* request our platform independent driver */
 	request_module("broadsheetfb");
diff --git a/arch/arm/mach-pxa/balloon3.c b/arch/arm/mach-pxa/balloon3.c
index 2f71b3f..2543cb2 100644
--- a/arch/arm/mach-pxa/balloon3.c
+++ b/arch/arm/mach-pxa/balloon3.c
@@ -116,7 +116,8 @@ static void __init balloon3_cf_init(void)
 	if (!balloon3_has(BALLOON3_FEATURE_CF))
 		return;
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(balloon3_cf_pin_config));
+	pxa2xx_mfp_config(balloon3_cf_pin_config,
+			  ARRAY_SIZE(balloon3_cf_pin_config));
 }
 #else
 static inline void balloon3_cf_init(void) {}
@@ -197,7 +198,8 @@ static void __init balloon3_ts_init(void)
 	if (!balloon3_has(BALLOON3_FEATURE_AUDIO))
 		return;
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(balloon3_ac97_pin_config));
+	pxa2xx_mfp_config(balloon3_ac97_pin_config,
+			  ARRAY_SIZE(balloon3_ac97_pin_config));
 	pxa_set_ac97_info(NULL);
 	platform_device_register(&balloon3_ucb1400_device);
 }
@@ -248,7 +250,8 @@ static void __init balloon3_lcd_init(void)
 	if (!balloon3_has(BALLOON3_FEATURE_TOPPOLY))
 		return;
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(balloon3_lcd_pin_config));
+	pxa2xx_mfp_config(balloon3_lcd_pin_config,
+			  ARRAY_SIZE(balloon3_lcd_pin_config));
 
 	ret = gpio_request(BALLOON3_GPIO_RUN_BACKLIGHT, "BKL-ON");
 	if (ret) {
@@ -298,7 +301,8 @@ static struct pxamci_platform_data balloon3_mci_platform_data = {
 
 static void __init balloon3_mmc_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(balloon3_mmc_pin_config));
+	pxa2xx_mfp_config(balloon3_mmc_pin_config,
+			  ARRAY_SIZE(balloon3_mmc_pin_config));
 	pxa_set_mci_info(&balloon3_mci_platform_data);
 }
 #else
@@ -371,7 +375,8 @@ static void __init balloon3_uhc_init(void)
 {
 	if (!balloon3_has(BALLOON3_FEATURE_OHCI))
 		return;
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(balloon3_uhc_pin_config));
+	pxa2xx_mfp_config(balloon3_uhc_pin_config,
+			  ARRAY_SIZE(balloon3_uhc_pin_config));
 	pxa_set_ohci_info(&balloon3_ohci_info);
 }
 #else
@@ -465,7 +470,8 @@ static struct platform_device balloon3_pcf_leds = {
 
 static void __init balloon3_leds_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(balloon3_led_pin_config));
+	pxa2xx_mfp_config(balloon3_led_pin_config,
+			  ARRAY_SIZE(balloon3_led_pin_config));
 	platform_device_register(&balloon3_leds);
 	platform_device_register(&balloon3_pcf_leds);
 }
@@ -561,7 +567,8 @@ static struct i2c_board_info __initdata balloon3_i2c_devs[] = {
 static void __init balloon3_i2c_init(void)
 {
 	pxa_set_i2c_info(NULL);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(balloon3_i2c_devs));
+	i2c_register_board_info(0, balloon3_i2c_devs,
+				ARRAY_SIZE(balloon3_i2c_devs));
 }
 #else
 static inline void balloon3_i2c_init(void) {}
@@ -768,7 +775,8 @@ static struct i2c_board_info __initdata balloon3_pi2c_board_info[] = {
 static void __init balloon3_pmic_init(void)
 {
 	pxa27x_set_i2c_power_info(NULL);
-	i2c_register_board_info(1, ARRAY_AND_SIZE(balloon3_pi2c_board_info));
+	i2c_register_board_info(1, balloon3_pi2c_board_info,
+				ARRAY_SIZE(balloon3_pi2c_board_info));
 }
 #else
 static inline void balloon3_pmic_init(void) {}
@@ -781,7 +789,8 @@ static void __init balloon3_init(void)
 {
 	ARB_CNTRL = ARB_CORE_PARK | 0x234;
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(balloon3_pin_config));
+	pxa2xx_mfp_config(balloon3_pin_config,
+			  ARRAY_SIZE(balloon3_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
diff --git a/arch/arm/mach-pxa/cm-x255.c b/arch/arm/mach-pxa/cm-x255.c
index be75147..a73492c 100644
--- a/arch/arm/mach-pxa/cm-x255.c
+++ b/arch/arm/mach-pxa/cm-x255.c
@@ -114,7 +114,7 @@ static struct spi_board_info spi_board_info[] __initdata = {
 static void __init cmx255_init_rtc(void)
 {
 	pxa2xx_set_spi_info(1, &pxa_ssp_master_info);
-	spi_register_board_info(ARRAY_AND_SIZE(spi_board_info));
+	spi_register_board_info(spi_board_info, ARRAY_SIZE(spi_board_info));
 }
 #else
 static inline void cmx255_init_rtc(void) {}
@@ -228,7 +228,7 @@ static inline void cmx255_init_nand(void) {}
 
 void __init cmx255_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(cmx255_pin_config));
+	pxa2xx_mfp_config(cmx255_pin_config, ARRAY_SIZE(cmx255_pin_config));
 
 	cmx255_init_rtc();
 	cmx255_init_nor();
diff --git a/arch/arm/mach-pxa/cm-x270.c b/arch/arm/mach-pxa/cm-x270.c
index 2503db9..f80d37c 100644
--- a/arch/arm/mach-pxa/cm-x270.c
+++ b/arch/arm/mach-pxa/cm-x270.c
@@ -213,7 +213,7 @@ static int cmx270_marathon_probe(struct fb_info *fb)
 		gpio_direction_input(gpio);
 	}
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(cmx270_marathon_on));
+	pxa2xx_mfp_config(cmx270_marathon_on, ARRAY_SIZE(cmx270_marathon_on));
 	return 0;
 }
 
@@ -221,7 +221,8 @@ static int cmx270_marathon_remove(struct fb_info *fb)
 {
 	int gpio;
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(cmx270_marathon_off));
+	pxa2xx_mfp_config(cmx270_marathon_off,
+			  ARRAY_SIZE(cmx270_marathon_off));
 
 	for (gpio = 58; gpio <= 77; gpio++)
 		gpio_free(gpio);
@@ -344,7 +345,8 @@ static int cm_x270_libertas_setup(struct spi_device *spi)
 		goto err_free_strap;
 	msleep(100);
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(cm_x270_libertas_pin_config));
+	pxa2xx_mfp_config(cm_x270_libertas_pin_config,
+			  ARRAY_SIZE(cm_x270_libertas_pin_config));
 
 	gpio_set_value(GPIO102_WLAN_RST, 1);
 	msleep(100);
@@ -390,7 +392,8 @@ static struct spi_board_info cm_x270_spi_devices[] __initdata = {
 static void __init cmx270_init_spi(void)
 {
 	pxa2xx_set_spi_info(2, &cm_x270_spi_info);
-	spi_register_board_info(ARRAY_AND_SIZE(cm_x270_spi_devices));
+	spi_register_board_info(cm_x270_spi_devices,
+				ARRAY_SIZE(cm_x270_spi_devices));
 }
 #else
 static inline void cmx270_init_spi(void) {}
@@ -398,7 +401,7 @@ static inline void cmx270_init_spi(void) {}
 
 void __init cmx270_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(cmx270_pin_config));
+	pxa2xx_mfp_config(cmx270_pin_config, ARRAY_SIZE(cmx270_pin_config));
 
 #ifdef CONFIG_PM
 	pxa27x_set_pwrmode(PWRMODE_DEEPSLEEP);
diff --git a/arch/arm/mach-pxa/cm-x300.c b/arch/arm/mach-pxa/cm-x300.c
index 8091aac..c855a8c 100644
--- a/arch/arm/mach-pxa/cm-x300.c
+++ b/arch/arm/mach-pxa/cm-x300.c
@@ -782,7 +782,8 @@ static void __init cm_x300_init_wi2wi(void)
 	}
 
 	/* Libertas and CSR reset */
-	err = gpio_request_array(ARRAY_AND_SIZE(cm_x300_wi2wi_gpios));
+	err = gpio_request_array(cm_x300_wi2wi_gpios,
+				 ARRAY_SIZE(cm_x300_wi2wi_gpios));
 	if (err) {
 		pr_err("failed to request wifi/bt gpios: %d\n", err);
 		return;
@@ -793,22 +794,25 @@ static void __init cm_x300_init_wi2wi(void)
 	udelay(10);
 	gpio_set_value(cm_x300_wi2wi_gpios[1].gpio, 1);
 
-	gpio_free_array(ARRAY_AND_SIZE(cm_x300_wi2wi_gpios));
+	gpio_free_array(cm_x300_wi2wi_gpios, ARRAY_SIZE(cm_x300_wi2wi_gpios));
 }
 
 /* MFP */
 static void __init cm_x300_init_mfp(void)
 {
 	/* board-processor specific GPIO initialization */
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(cm_x3xx_mfp_cfg));
+	pxa3xx_mfp_config(cm_x3xx_mfp_cfg, ARRAY_SIZE(cm_x3xx_mfp_cfg));
 
 	if (system_rev < 130)
-		pxa3xx_mfp_config(ARRAY_AND_SIZE(cm_x3xx_rev_lt130_mfp_cfg));
+		pxa3xx_mfp_config(cm_x3xx_rev_lt130_mfp_cfg,
+				  ARRAY_SIZE(cm_x3xx_rev_lt130_mfp_cfg));
 	else
-		pxa3xx_mfp_config(ARRAY_AND_SIZE(cm_x3xx_rev_ge130_mfp_cfg));
+		pxa3xx_mfp_config(cm_x3xx_rev_ge130_mfp_cfg,
+				  ARRAY_SIZE(cm_x3xx_rev_ge130_mfp_cfg));
 
 	if (cpu_is_pxa310())
-		pxa3xx_mfp_config(ARRAY_AND_SIZE(cm_x310_mfp_cfg));
+		pxa3xx_mfp_config(cm_x310_mfp_cfg,
+				  ARRAY_SIZE(cm_x310_mfp_cfg));
 }
 
 static void __init cm_x300_init(void)
diff --git a/arch/arm/mach-pxa/colibri-evalboard.c b/arch/arm/mach-pxa/colibri-evalboard.c
index 8404b24..c7006ea 100644
--- a/arch/arm/mach-pxa/colibri-evalboard.c
+++ b/arch/arm/mach-pxa/colibri-evalboard.c
@@ -101,7 +101,8 @@ static struct i2c_board_info __initdata colibri_i2c_devs[] = {
 static void __init colibri_rtc_init(void)
 {
 	pxa_set_i2c_info(NULL);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(colibri_i2c_devs));
+	i2c_register_board_info(0, colibri_i2c_devs,
+				ARRAY_SIZE(colibri_i2c_devs));
 }
 #else
 static inline void colibri_rtc_init(void) {}
diff --git a/arch/arm/mach-pxa/colibri-pxa270.c b/arch/arm/mach-pxa/colibri-pxa270.c
index 5f9d930..bcd9334 100644
--- a/arch/arm/mach-pxa/colibri-pxa270.c
+++ b/arch/arm/mach-pxa/colibri-pxa270.c
@@ -274,7 +274,8 @@ core_param(colibri_pxa270_baseboard, colibri_pxa270_baseboard, int, 0444);
 
 static void __init colibri_pxa270_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(colibri_pxa270_pin_config));
+	pxa2xx_mfp_config(colibri_pxa270_pin_config,
+			  ARRAY_SIZE(colibri_pxa270_pin_config));
 
 	colibri_pxa270_nor_init();
 	colibri_pxa270_eth_init();
@@ -282,12 +283,13 @@ static void __init colibri_pxa270_init(void)
 
 	switch (colibri_pxa270_baseboard) {
 	case COLIBRI_EVALBOARD:
-		pxa2xx_mfp_config(ARRAY_AND_SIZE(
-			colibri_pxa270_evalboard_pin_config));
+		pxa2xx_mfp_config(colibri_pxa270_evalboard_pin_config,
+			ARRAY_SIZE(colibri_pxa270_evalboard_pin_config));
 		colibri_evalboard_init();
 		break;
 	case COLIBRI_PXA270_INCOME:
-		pxa2xx_mfp_config(ARRAY_AND_SIZE(income_pin_config));
+		pxa2xx_mfp_config(income_pin_config,
+				  ARRAY_SIZE(income_pin_config));
 		colibri_pxa270_income_boardinit();
 		break;
 	default:
diff --git a/arch/arm/mach-pxa/colibri-pxa300.c b/arch/arm/mach-pxa/colibri-pxa300.c
index f1a1ac1..f48202a 100644
--- a/arch/arm/mach-pxa/colibri-pxa300.c
+++ b/arch/arm/mach-pxa/colibri-pxa300.c
@@ -102,7 +102,8 @@ static mfp_cfg_t colibri_pxa300_eth_pin_config[] __initdata = {
 static void __init colibri_pxa300_init_eth(void)
 {
 	colibri_pxa3xx_init_eth(&colibri_asix_platdata);
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(colibri_pxa300_eth_pin_config));
+	pxa3xx_mfp_config(colibri_pxa300_eth_pin_config,
+			  ARRAY_SIZE(colibri_pxa300_eth_pin_config));
 	platform_device_register(&asix_device);
 }
 #else
@@ -139,7 +140,8 @@ static mfp_cfg_t colibri_pxa300_lcd_pin_config[] __initdata = {
 
 static void __init colibri_pxa300_init_lcd(void)
 {
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(colibri_pxa300_lcd_pin_config));
+	pxa3xx_mfp_config(colibri_pxa300_lcd_pin_config,
+			  ARRAY_SIZE(colibri_pxa300_lcd_pin_config));
 }
 
 #else
@@ -162,7 +164,8 @@ static inline void __init colibri_pxa310_init_ac97(void)
 	if (!cpu_is_pxa310())
 		return;
 
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(colibri_pxa310_ac97_pin_config));
+	pxa3xx_mfp_config(colibri_pxa310_ac97_pin_config,
+			  ARRAY_SIZE(colibri_pxa310_ac97_pin_config));
 	pxa_set_ac97_info(NULL);
 }
 #else
@@ -178,7 +181,8 @@ void __init colibri_pxa300_init(void)
 	colibri_pxa310_init_ac97();
 
 	/* Evalboard init */
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(colibri_pxa300_evalboard_pin_config));
+	pxa3xx_mfp_config(colibri_pxa300_evalboard_pin_config,
+			  ARRAY_SIZE(colibri_pxa300_evalboard_pin_config));
 	colibri_evalboard_init();
 }
 
diff --git a/arch/arm/mach-pxa/colibri-pxa320.c b/arch/arm/mach-pxa/colibri-pxa320.c
index f6cc8b0..a2808cb 100644
--- a/arch/arm/mach-pxa/colibri-pxa320.c
+++ b/arch/arm/mach-pxa/colibri-pxa320.c
@@ -139,7 +139,8 @@ static mfp_cfg_t colibri_pxa320_eth_pin_config[] __initdata = {
 static void __init colibri_pxa320_init_eth(void)
 {
 	colibri_pxa3xx_init_eth(&colibri_asix_platdata);
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(colibri_pxa320_eth_pin_config));
+	pxa3xx_mfp_config(colibri_pxa320_eth_pin_config,
+			  ARRAY_SIZE(colibri_pxa320_eth_pin_config));
 	platform_device_register(&asix_device);
 }
 #else
@@ -212,7 +213,8 @@ static mfp_cfg_t colibri_pxa320_lcd_pin_config[] __initdata = {
 
 static void __init colibri_pxa320_init_lcd(void)
 {
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(colibri_pxa320_lcd_pin_config));
+	pxa3xx_mfp_config(colibri_pxa320_lcd_pin_config,
+			  ARRAY_SIZE(colibri_pxa320_lcd_pin_config));
 }
 #else
 static inline void colibri_pxa320_init_lcd(void) {}
@@ -231,7 +233,8 @@ static mfp_cfg_t colibri_pxa320_ac97_pin_config[] __initdata = {
 
 static inline void __init colibri_pxa320_init_ac97(void)
 {
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(colibri_pxa320_ac97_pin_config));
+	pxa3xx_mfp_config(colibri_pxa320_ac97_pin_config,
+			  ARRAY_SIZE(colibri_pxa320_ac97_pin_config));
 	pxa_set_ac97_info(NULL);
 }
 #else
@@ -248,7 +251,8 @@ void __init colibri_pxa320_init(void)
 	colibri_pxa320_init_udc();
 
 	/* Evalboard init */
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(colibri_pxa320_evalboard_pin_config));
+	pxa3xx_mfp_config(colibri_pxa320_evalboard_pin_config,
+			  ARRAY_SIZE(colibri_pxa320_evalboard_pin_config));
 	colibri_evalboard_init();
 }
 
diff --git a/arch/arm/mach-pxa/corgi.c b/arch/arm/mach-pxa/corgi.c
index f162f1b..391f0aa 100644
--- a/arch/arm/mach-pxa/corgi.c
+++ b/arch/arm/mach-pxa/corgi.c
@@ -558,7 +558,8 @@ static struct spi_board_info corgi_spi_devices[] = {
 static void __init corgi_init_spi(void)
 {
 	pxa2xx_set_spi_info(1, &corgi_spi_info);
-	spi_register_board_info(ARRAY_AND_SIZE(corgi_spi_devices));
+	spi_register_board_info(corgi_spi_devices,
+				ARRAY_SIZE(corgi_spi_devices));
 }
 #else
 static inline void corgi_init_spi(void) {}
@@ -682,7 +683,7 @@ static void __init corgi_init(void)
 	/* Stop 3.6MHz and drive HIGH to PCMCIA and CS */
 	PCFR |= PCFR_OPDE;
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(corgi_pin_config));
+	pxa2xx_mfp_config(corgi_pin_config, ARRAY_SIZE(corgi_pin_config));
 
 	/* allow wakeup from various GPIOs */
 	gpio_set_wake(CORGI_GPIO_KEY_INT, 1);
@@ -703,7 +704,8 @@ static void __init corgi_init(void)
 	pxa_set_mci_info(&corgi_mci_platform_data);
 	pxa_set_ficp_info(&corgi_ficp_platform_data);
 	pxa_set_i2c_info(NULL);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(corgi_i2c_devices));
+	i2c_register_board_info(0, corgi_i2c_devices,
+				ARRAY_SIZE(corgi_i2c_devices));
 
 	platform_scoop_config = &corgi_pcmcia_config;
 
diff --git a/arch/arm/mach-pxa/corgi_pm.c b/arch/arm/mach-pxa/corgi_pm.c
index 7a39efc..a32c516 100644
--- a/arch/arm/mach-pxa/corgi_pm.c
+++ b/arch/arm/mach-pxa/corgi_pm.c
@@ -49,7 +49,7 @@ static struct gpio charger_gpios[] = {
 
 static void corgi_charger_init(void)
 {
-	gpio_request_array(ARRAY_AND_SIZE(charger_gpios));
+	gpio_request_array(charger_gpios, ARRAY_SIZE(charger_gpios));
 }
 
 static void corgi_measure_temp(int on)
diff --git a/arch/arm/mach-pxa/csb726.c b/arch/arm/mach-pxa/csb726.c
index fadfff8..2edee1a 100644
--- a/arch/arm/mach-pxa/csb726.c
+++ b/arch/arm/mach-pxa/csb726.c
@@ -254,7 +254,7 @@ static struct platform_device *devices[] __initdata = {
 
 static void __init csb726_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(csb726_pin_config));
+	pxa2xx_mfp_config(csb726_pin_config, ARRAY_SIZE(csb726_pin_config));
 /*	__raw_writel(0x7ffc3ffc, MSC1); *//* LAN9215/EXP_CS */
 /*	__raw_writel(0x06697ff4, MSC2); *//* none/SM501 */
 	__raw_writel((__raw_readl(MSC2) & ~0xffff) | 0x7ff4, MSC2); /* SM501 */
diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index 3a3362f..7db4ce1 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -758,7 +758,8 @@ static int em_x270_libertas_setup(struct spi_device *spi)
 	gpio_direction_output(GPIO19_WLAN_STRAP, 1);
 	msleep(100);
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(em_x270_libertas_pin_config));
+	pxa2xx_mfp_config(em_x270_libertas_pin_config,
+			  ARRAY_SIZE(em_x270_libertas_pin_config));
 
 	gpio_direction_output(GPIO115_WLAN_PWEN, 0);
 	msleep(100);
@@ -822,7 +823,8 @@ static void __init em_x270_init_spi(void)
 {
 	pxa2xx_set_spi_info(1, &em_x270_spi_info);
 	pxa2xx_set_spi_info(2, &em_x270_spi_2_info);
-	spi_register_board_info(ARRAY_AND_SIZE(em_x270_spi_devices));
+	spi_register_board_info(em_x270_spi_devices,
+				ARRAY_SIZE(em_x270_spi_devices));
 }
 #else
 static inline void em_x270_init_spi(void) {}
@@ -1093,7 +1095,8 @@ static struct platform_device *em_x270_userspace_consumers[] = {
 
 static void __init em_x270_userspace_consumers_init(void)
 {
-	platform_add_devices(ARRAY_AND_SIZE(em_x270_userspace_consumers));
+	platform_add_devices(em_x270_userspace_consumers,
+			     ARRAY_SIZE(em_x270_userspace_consumers));
 }
 
 /* DA9030 related initializations */
@@ -1248,12 +1251,13 @@ static void __init em_x270_init_i2c(void)
 	pxa_set_i2c_info(&em_x270_i2c_info);
 
 	if (machine_is_exeda())
-		i2c_register_board_info(0, ARRAY_AND_SIZE(exeda_i2c_info));
+		i2c_register_board_info(0, exeda_i2c_info,
+					ARRAY_SIZE(exeda_i2c_info));
 }
 
 static void __init em_x270_module_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(em_x270_pin_config));
+	pxa2xx_mfp_config(em_x270_pin_config, ARRAY_SIZE(em_x270_pin_config));
 
 	mmc_cd = GPIO13_MMC_CD;
 	nand_rb = GPIO56_NAND_RB;
@@ -1264,7 +1268,7 @@ static void __init em_x270_module_init(void)
 
 static void __init em_x270_exeda_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(exeda_pin_config));
+	pxa2xx_mfp_config(exeda_pin_config, ARRAY_SIZE(exeda_pin_config));
 
 	mmc_cd = GPIO114_MMC_CD;
 	nand_rb = GPIO20_NAND_RB;
@@ -1275,7 +1279,7 @@ static void __init em_x270_exeda_init(void)
 
 static void __init em_x270_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(common_pin_config));
+	pxa2xx_mfp_config(common_pin_config, ARRAY_SIZE(common_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
diff --git a/arch/arm/mach-pxa/eseries.c b/arch/arm/mach-pxa/eseries.c
index 8280ebc..d8a89bc 100644
--- a/arch/arm/mach-pxa/eseries.c
+++ b/arch/arm/mach-pxa/eseries.c
@@ -183,7 +183,7 @@ static void __init e330_init(void)
 	pxa_set_stuart_info(NULL);
 	eseries_register_clks();
 	eseries_get_tmio_gpios();
-	platform_add_devices(ARRAY_AND_SIZE(e330_devices));
+	platform_add_devices(e330_devices, ARRAY_SIZE(e330_devices));
 }
 
 MACHINE_START(E330, "Toshiba e330")
@@ -234,7 +234,7 @@ static void __init e350_init(void)
 	pxa_set_stuart_info(NULL);
 	eseries_register_clks();
 	eseries_get_tmio_gpios();
-	platform_add_devices(ARRAY_AND_SIZE(e350_devices));
+	platform_add_devices(e350_devices, ARRAY_SIZE(e350_devices));
 }
 
 MACHINE_START(E350, "Toshiba e350")
@@ -350,7 +350,7 @@ static struct platform_device *e400_devices[] __initdata = {
 
 static void __init e400_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(e400_pin_config));
+	pxa2xx_mfp_config(e400_pin_config, ARRAY_SIZE(e400_pin_config));
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
@@ -358,7 +358,7 @@ static void __init e400_init(void)
 	eseries_register_clks();
 	eseries_get_tmio_gpios();
 	pxa_set_fb_info(NULL, &e400_pxafb_mach_info);
-	platform_add_devices(ARRAY_AND_SIZE(e400_devices));
+	platform_add_devices(e400_devices, ARRAY_SIZE(e400_devices));
 }
 
 MACHINE_START(E400, "Toshiba e400")
@@ -544,7 +544,7 @@ static struct platform_device *e740_devices[] __initdata = {
 
 static void __init e740_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(e740_pin_config));
+	pxa2xx_mfp_config(e740_pin_config, ARRAY_SIZE(e740_pin_config));
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
@@ -552,7 +552,7 @@ static void __init e740_init(void)
 	clk_add_alias("CLK_CK48M", e740_t7l66xb_device.name,
 			"UDCCLK", &pxa25x_device_udc.dev),
 	eseries_get_tmio_gpios();
-	platform_add_devices(ARRAY_AND_SIZE(e740_devices));
+	platform_add_devices(e740_devices, ARRAY_SIZE(e740_devices));
 	pxa_set_ac97_info(NULL);
 	pxa_set_ficp_info(&e7xx_ficp_platform_data);
 }
@@ -744,14 +744,14 @@ static struct platform_device *e750_devices[] __initdata = {
 
 static void __init e750_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(e750_pin_config));
+	pxa2xx_mfp_config(e750_pin_config, ARRAY_SIZE(e750_pin_config));
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
 	clk_add_alias("CLK_CK3P6MI", e750_tc6393xb_device.name,
 			"GPIO11_CLK", NULL),
 	eseries_get_tmio_gpios();
-	platform_add_devices(ARRAY_AND_SIZE(e750_devices));
+	platform_add_devices(e750_devices, ARRAY_SIZE(e750_devices));
 	pxa_set_ac97_info(NULL);
 	pxa_set_ficp_info(&e7xx_ficp_platform_data);
 }
@@ -957,14 +957,14 @@ static struct platform_device *e800_devices[] __initdata = {
 
 static void __init e800_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(e800_pin_config));
+	pxa2xx_mfp_config(e800_pin_config, ARRAY_SIZE(e800_pin_config));
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
 	clk_add_alias("CLK_CK3P6MI", e800_tc6393xb_device.name,
 			"GPIO11_CLK", NULL),
 	eseries_get_tmio_gpios();
-	platform_add_devices(ARRAY_AND_SIZE(e800_devices));
+	platform_add_devices(e800_devices, ARRAY_SIZE(e800_devices));
 	pxa_set_ac97_info(NULL);
 }
 
diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
index 4225417..4f08ada 100644
--- a/arch/arm/mach-pxa/generic.c
+++ b/arch/arm/mach-pxa/generic.c
@@ -93,5 +93,5 @@ static struct map_desc common_io_desc[] __initdata = {
 
 void __init pxa_map_io(void)
 {
-	iotable_init(ARRAY_AND_SIZE(common_io_desc));
+	iotable_init(common_io_desc, ARRAY_SIZE(common_io_desc));
 }
diff --git a/arch/arm/mach-pxa/gumstix.c b/arch/arm/mach-pxa/gumstix.c
index 00b92da..f884ada 100644
--- a/arch/arm/mach-pxa/gumstix.c
+++ b/arch/arm/mach-pxa/gumstix.c
@@ -218,7 +218,7 @@ static void __init carrier_board_init(void)
 
 static void __init gumstix_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(gumstix_pin_config));
+	pxa2xx_mfp_config(gumstix_pin_config, ARRAY_SIZE(gumstix_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
diff --git a/arch/arm/mach-pxa/h5000.c b/arch/arm/mach-pxa/h5000.c
index 875ec33..7a6a62e 100644
--- a/arch/arm/mach-pxa/h5000.c
+++ b/arch/arm/mach-pxa/h5000.c
@@ -194,12 +194,12 @@ static void __init h5000_init(void)
 {
 	fix_msc();
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(h5000_pin_config));
+	pxa2xx_mfp_config(h5000_pin_config, ARRAY_SIZE(h5000_pin_config));
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
 	pxa_set_udc_info(&h5000_udc_mach_info);
-	platform_add_devices(ARRAY_AND_SIZE(devices));
+	platform_add_devices(devices, ARRAY_SIZE(devices));
 }
 
 MACHINE_START(H5400, "HP iPAQ H5000")
diff --git a/arch/arm/mach-pxa/icontrol.c b/arch/arm/mach-pxa/icontrol.c
index fe31bfc..6cdec97 100644
--- a/arch/arm/mach-pxa/icontrol.c
+++ b/arch/arm/mach-pxa/icontrol.c
@@ -176,9 +176,11 @@ static mfp_cfg_t mfp_can_cfg[] __initdata = {
 
 static void __init icontrol_can_init(void)
 {
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(mfp_can_cfg));
-	platform_add_devices(ARRAY_AND_SIZE(icontrol_spi_devices));
-	spi_register_board_info(ARRAY_AND_SIZE(mcp251x_board_info));
+	pxa3xx_mfp_config(mfp_can_cfg, ARRAY_SIZE(mfp_can_cfg));
+	platform_add_devices(icontrol_spi_devices,
+			     ARRAY_SIZE(icontrol_spi_devices));
+	spi_register_board_info(mcp251x_board_info,
+				ARRAY_SIZE(mcp251x_board_info));
 }
 
 static void __init icontrol_init(void)
diff --git a/arch/arm/mach-pxa/idp.c b/arch/arm/mach-pxa/idp.c
index 343c4e3..375a148 100644
--- a/arch/arm/mach-pxa/idp.c
+++ b/arch/arm/mach-pxa/idp.c
@@ -160,7 +160,7 @@ static void __init idp_init(void)
 {
 	printk("idp_init()\n");
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(idp_pin_config));
+	pxa2xx_mfp_config(idp_pin_config, ARRAY_SIZE(idp_pin_config));
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
diff --git a/arch/arm/mach-pxa/littleton.c b/arch/arm/mach-pxa/littleton.c
index 5d66558..fca9359 100644
--- a/arch/arm/mach-pxa/littleton.c
+++ b/arch/arm/mach-pxa/littleton.c
@@ -215,7 +215,8 @@ static struct spi_board_info littleton_spi_devices[] __initdata = {
 static void __init littleton_init_spi(void)
 {
 	pxa2xx_set_spi_info(2, &littleton_spi_info);
-	spi_register_board_info(ARRAY_AND_SIZE(littleton_spi_devices));
+	spi_register_board_info(littleton_spi_devices,
+				ARRAY_SIZE(littleton_spi_devices));
 }
 #else
 static inline void littleton_init_spi(void) {}
@@ -412,7 +413,8 @@ static struct i2c_board_info littleton_i2c_info[] = {
 static void __init littleton_init_i2c(void)
 {
 	pxa_set_i2c_info(NULL);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(littleton_i2c_info));
+	i2c_register_board_info(0, littleton_i2c_info,
+				ARRAY_SIZE(littleton_i2c_info));
 }
 #else
 static inline void littleton_init_i2c(void) {}
@@ -421,7 +423,7 @@ static inline void littleton_init_i2c(void) {}
 static void __init littleton_init(void)
 {
 	/* initialize MFP configurations */
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(littleton_mfp_cfg));
+	pxa3xx_mfp_config(littleton_mfp_cfg, ARRAY_SIZE(littleton_mfp_cfg));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
diff --git a/arch/arm/mach-pxa/lpd270.c b/arch/arm/mach-pxa/lpd270.c
index 1255ee0..5965424 100644
--- a/arch/arm/mach-pxa/lpd270.c
+++ b/arch/arm/mach-pxa/lpd270.c
@@ -450,7 +450,7 @@ static struct pxaohci_platform_data lpd270_ohci_platform_data = {
 
 static void __init lpd270_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(lpd270_pin_config));
+	pxa2xx_mfp_config(lpd270_pin_config, ARRAY_SIZE(lpd270_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
diff --git a/arch/arm/mach-pxa/lubbock.c b/arch/arm/mach-pxa/lubbock.c
index d8a1be6..faa1695 100644
--- a/arch/arm/mach-pxa/lubbock.c
+++ b/arch/arm/mach-pxa/lubbock.c
@@ -508,7 +508,7 @@ static void __init lubbock_init(void)
 {
 	int flashboot = (LUB_CONF_SWITCHES & 1);
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(lubbock_pin_config));
+	pxa2xx_mfp_config(lubbock_pin_config, ARRAY_SIZE(lubbock_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
diff --git a/arch/arm/mach-pxa/magician.c b/arch/arm/mach-pxa/magician.c
index f44532f..1617640 100644
--- a/arch/arm/mach-pxa/magician.c
+++ b/arch/arm/mach-pxa/magician.c
@@ -353,7 +353,8 @@ static struct gpio magician_bl_gpios[] = {
 
 static int magician_backlight_init(struct device *dev)
 {
-	return gpio_request_array(ARRAY_AND_SIZE(magician_bl_gpios));
+	return gpio_request_array(magician_bl_gpios,
+				  ARRAY_SIZE(magician_bl_gpios));
 }
 
 static int magician_backlight_notify(struct device *dev, int brightness)
@@ -370,7 +371,7 @@ static int magician_backlight_notify(struct device *dev, int brightness)
 
 static void magician_backlight_exit(struct device *dev)
 {
-	gpio_free_array(ARRAY_AND_SIZE(magician_bl_gpios));
+	gpio_free_array(magician_bl_gpios, ARRAY_SIZE(magician_bl_gpios));
 }
 
 static struct platform_pwm_backlight_data backlight_data = {
@@ -733,8 +734,10 @@ static void __init magician_init(void)
 	int lcd_select;
 	int err;
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(magician_pin_config));
-	err = gpio_request_array(ARRAY_AND_SIZE(magician_global_gpios));
+	pxa2xx_mfp_config(magician_pin_config,
+			  ARRAY_SIZE(magician_pin_config));
+	err = gpio_request_array(magician_global_gpios,
+				 ARRAY_SIZE(magician_global_gpios));
 	if (err)
 		pr_err("magician: Failed to request GPIOs: %d\n", err);
 
@@ -742,7 +745,7 @@ static void __init magician_init(void)
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
 
-	platform_add_devices(ARRAY_AND_SIZE(devices));
+	platform_add_devices(devices, ARRAY_SIZE(devices));
 
 	pxa_set_ficp_info(&magician_ficp_info);
 	pxa27x_set_i2c_power_info(NULL);
diff --git a/arch/arm/mach-pxa/mainstone.c b/arch/arm/mach-pxa/mainstone.c
index dd70343..dfb9ff1 100644
--- a/arch/arm/mach-pxa/mainstone.c
+++ b/arch/arm/mach-pxa/mainstone.c
@@ -557,7 +557,8 @@ static void __init mainstone_init(void)
 {
 	int SW7 = 0;  /* FIXME: get from SCR (Mst doc section 3.2.1.1) */
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(mainstone_pin_config));
+	pxa2xx_mfp_config(mainstone_pin_config,
+			  ARRAY_SIZE(mainstone_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
diff --git a/arch/arm/mach-pxa/mxm8x10.c b/arch/arm/mach-pxa/mxm8x10.c
index d04ed49..787d086 100644
--- a/arch/arm/mach-pxa/mxm8x10.c
+++ b/arch/arm/mach-pxa/mxm8x10.c
@@ -466,7 +466,7 @@ static void __init mxm_8x10_i2c_init(void)
 
 void __init mxm_8x10_barebones_init(void)
 {
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(mfp_cfg));
+	pxa3xx_mfp_config(mfp_cfg, ARRAY_SIZE(mfp_cfg));
 
 	mxm_8x10_uarts_init();
 	mxm_8x10_nand_init();
diff --git a/arch/arm/mach-pxa/palm27x.c b/arch/arm/mach-pxa/palm27x.c
index 17d4c53..80f02ac 100644
--- a/arch/arm/mach-pxa/palm27x.c
+++ b/arch/arm/mach-pxa/palm27x.c
@@ -471,7 +471,8 @@ static struct i2c_pxa_platform_data palm27x_i2c_power_info = {
 
 void __init palm27x_pmic_init(void)
 {
-	i2c_register_board_info(1, ARRAY_AND_SIZE(palm27x_pi2c_board_info));
+	i2c_register_board_info(1, palm27x_pi2c_board_info,
+				ARRAY_SIZE(palm27x_pi2c_board_info));
 	pxa27x_set_i2c_power_info(&palm27x_i2c_power_info);
 }
 #endif
diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index 13e5b00..2480618 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -526,7 +526,7 @@ static struct platform_device pcm990_camera[] = {
  */
 void __init pcm990_baseboard_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(pcm990_pin_config));
+	pxa2xx_mfp_config(pcm990_pin_config, ARRAY_SIZE(pcm990_pin_config));
 
 	pcm990_cpld_base = ioremap(PCM990_CTRL_PHYS, PCM990_CTRL_SIZE);
 	if (!pcm990_cpld_base) {
@@ -552,10 +552,12 @@ void __init pcm990_baseboard_init(void)
 	pxa_set_ac97_info(NULL);
 
 #if defined(CONFIG_VIDEO_PXA27x) || defined(CONFIG_VIDEO_PXA27x_MODULE)
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(pcm990_camera_pin_config));
+	pxa2xx_mfp_config(pcm990_camera_pin_config,
+			  ARRAY_SIZE(pcm990_camera_pin_config));
 	pxa_set_camera_info(&pcm990_pxacamera_platform_data);
 
-	i2c_register_board_info(0, ARRAY_AND_SIZE(pcm990_i2c_devices));
+	i2c_register_board_info(0, pcm990_i2c_devices,
+				ARRAY_SIZE(pcm990_i2c_devices));
 
 	platform_device_register(&pcm990_camera[0]);
 	platform_device_register(&pcm990_camera[1]);
diff --git a/arch/arm/mach-pxa/poodle.c b/arch/arm/mach-pxa/poodle.c
index aedf053..3916237 100644
--- a/arch/arm/mach-pxa/poodle.c
+++ b/arch/arm/mach-pxa/poodle.c
@@ -223,7 +223,8 @@ static struct spi_board_info poodle_spi_devices[] = {
 static void __init poodle_init_spi(void)
 {
 	pxa2xx_set_spi_info(1, &poodle_spi_info);
-	spi_register_board_info(ARRAY_AND_SIZE(poodle_spi_devices));
+	spi_register_board_info(poodle_spi_devices,
+				ARRAY_SIZE(poodle_spi_devices));
 }
 #else
 static inline void poodle_init_spi(void) {}
@@ -435,7 +436,7 @@ static void __init poodle_init(void)
 
 	PCFR |= PCFR_OPDE;
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(poodle_pin_config));
+	pxa2xx_mfp_config(poodle_pin_config, ARRAY_SIZE(poodle_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
@@ -452,7 +453,8 @@ static void __init poodle_init(void)
 	pxa_set_mci_info(&poodle_mci_platform_data);
 	pxa_set_ficp_info(&poodle_ficp_platform_data);
 	pxa_set_i2c_info(NULL);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(poodle_i2c_devices));
+	i2c_register_board_info(0, poodle_i2c_devices,
+				ARRAY_SIZE(poodle_i2c_devices));
 	poodle_init_spi();
 }
 
diff --git a/arch/arm/mach-pxa/pxa25x.c b/arch/arm/mach-pxa/pxa25x.c
index f2c2897..66e667b 100644
--- a/arch/arm/mach-pxa/pxa25x.c
+++ b/arch/arm/mach-pxa/pxa25x.c
@@ -339,7 +339,7 @@ static struct map_desc pxa25x_io_desc[] __initdata = {
 void __init pxa25x_map_io(void)
 {
 	pxa_map_io();
-	iotable_init(ARRAY_AND_SIZE(pxa25x_io_desc));
+	iotable_init(pxa25x_io_desc, ARRAY_SIZE(pxa25x_io_desc));
 	pxa25x_get_clk_frequency_khz(1);
 }
 
diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
index 301471a..a3e19d7 100644
--- a/arch/arm/mach-pxa/pxa27x.c
+++ b/arch/arm/mach-pxa/pxa27x.c
@@ -415,7 +415,7 @@ static struct map_desc pxa27x_io_desc[] __initdata = {
 void __init pxa27x_map_io(void)
 {
 	pxa_map_io();
-	iotable_init(ARRAY_AND_SIZE(pxa27x_io_desc));
+	iotable_init(pxa27x_io_desc, ARRAY_SIZE(pxa27x_io_desc));
 	pxa27x_get_clk_frequency_khz(1);
 }
 
diff --git a/arch/arm/mach-pxa/pxa300.c b/arch/arm/mach-pxa/pxa300.c
index 17cbc0c..cec9181 100644
--- a/arch/arm/mach-pxa/pxa300.c
+++ b/arch/arm/mach-pxa/pxa300.c
@@ -103,12 +103,12 @@ static int __init pxa300_init(void)
 	if (cpu_is_pxa300() || cpu_is_pxa310()) {
 		mfp_init_base(io_p2v(MFPR_BASE));
 		mfp_init_addr(pxa300_mfp_addr_map);
-		clkdev_add_table(ARRAY_AND_SIZE(common_clkregs));
+		clkdev_add_table(common_clkregs, ARRAY_SIZE(common_clkregs));
 	}
 
 	if (cpu_is_pxa310()) {
 		mfp_init_addr(pxa310_mfp_addr_map);
-		clkdev_add_table(ARRAY_AND_SIZE(pxa310_clkregs));
+		clkdev_add_table(pxa310_clkregs, ARRAY_SIZE(pxa310_clkregs));
 	}
 
 	return 0;
diff --git a/arch/arm/mach-pxa/pxa320.c b/arch/arm/mach-pxa/pxa320.c
index 6dc99d4..f27694b 100644
--- a/arch/arm/mach-pxa/pxa320.c
+++ b/arch/arm/mach-pxa/pxa320.c
@@ -91,7 +91,7 @@ static int __init pxa320_init(void)
 	if (cpu_is_pxa320()) {
 		mfp_init_base(io_p2v(MFPR_BASE));
 		mfp_init_addr(pxa320_mfp_addr_map);
-		clkdev_add_table(ARRAY_AND_SIZE(pxa320_clkregs));
+		clkdev_add_table(pxa320_clkregs, ARRAY_SIZE(pxa320_clkregs));
 	}
 
 	return 0;
diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
index 87011f3..f5aa7a4 100644
--- a/arch/arm/mach-pxa/pxa3xx.c
+++ b/arch/arm/mach-pxa/pxa3xx.c
@@ -424,7 +424,7 @@ static struct map_desc pxa3xx_io_desc[] __initdata = {
 void __init pxa3xx_map_io(void)
 {
 	pxa_map_io();
-	iotable_init(ARRAY_AND_SIZE(pxa3xx_io_desc));
+	iotable_init(pxa3xx_io_desc, ARRAY_SIZE(pxa3xx_io_desc));
 	pxa3xx_get_clk_frequency_khz(1);
 }
 
diff --git a/arch/arm/mach-pxa/raumfeld.c b/arch/arm/mach-pxa/raumfeld.c
index 969b0ba..8a63b8b 100644
--- a/arch/arm/mach-pxa/raumfeld.c
+++ b/arch/arm/mach-pxa/raumfeld.c
@@ -991,7 +991,8 @@ static void __init raumfeld_audio_init(void)
 	else
 		gpio_direction_output(GPIO_MCLK_RESET, 1);
 
-	platform_add_devices(ARRAY_AND_SIZE(audio_regulator_devices));
+	platform_add_devices(audio_regulator_devices,
+			     ARRAY_SIZE(audio_regulator_devices));
 }
 
 static void __init raumfeld_common_init(void)
@@ -1035,7 +1036,8 @@ static void __init raumfeld_common_init(void)
 	else
 		gpio_direction_output(GPIO_SHUTDOWN_SUPPLY, 0);
 
-	platform_add_devices(ARRAY_AND_SIZE(raumfeld_common_devices));
+	platform_add_devices(raumfeld_common_devices,
+			     ARRAY_SIZE(raumfeld_common_devices));
 	i2c_register_board_info(1, &raumfeld_pwri2c_board_info, 1);
 }
 
@@ -1043,9 +1045,11 @@ static void __init raumfeld_controller_init(void)
 {
 	int ret;
 
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(raumfeld_controller_pin_config));
+	pxa3xx_mfp_config(raumfeld_controller_pin_config,
+			  ARRAY_SIZE(raumfeld_controller_pin_config));
 	platform_device_register(&rotary_encoder_device);
-	spi_register_board_info(ARRAY_AND_SIZE(controller_spi_devices));
+	spi_register_board_info(controller_spi_devices,
+				ARRAY_SIZE(controller_spi_devices));
 	i2c_register_board_info(0, &raumfeld_controller_i2c_board_info, 1);
 
 	ret = gpio_request(GPIO_SHUTDOWN_BATT, "battery shutdown");
@@ -1062,8 +1066,10 @@ static void __init raumfeld_controller_init(void)
 
 static void __init raumfeld_connector_init(void)
 {
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(raumfeld_connector_pin_config));
-	spi_register_board_info(ARRAY_AND_SIZE(connector_spi_devices));
+	pxa3xx_mfp_config(raumfeld_connector_pin_config,
+			  ARRAY_SIZE(raumfeld_connector_pin_config));
+	spi_register_board_info(connector_spi_devices,
+				ARRAY_SIZE(connector_spi_devices));
 	i2c_register_board_info(0, &raumfeld_connector_i2c_board_info, 1);
 
 	platform_device_register(&smc91x_device);
@@ -1074,8 +1080,10 @@ static void __init raumfeld_connector_init(void)
 
 static void __init raumfeld_speaker_init(void)
 {
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(raumfeld_speaker_pin_config));
-	spi_register_board_info(ARRAY_AND_SIZE(speaker_spi_devices));
+	pxa3xx_mfp_config(raumfeld_speaker_pin_config,
+			  ARRAY_SIZE(raumfeld_speaker_pin_config));
+	spi_register_board_info(speaker_spi_devices,
+				ARRAY_SIZE(speaker_spi_devices));
 	i2c_register_board_info(0, &raumfeld_connector_i2c_board_info, 1);
 
 	platform_device_register(&smc91x_device);
diff --git a/arch/arm/mach-pxa/saar.c b/arch/arm/mach-pxa/saar.c
index 710c493..06afcd3 100644
--- a/arch/arm/mach-pxa/saar.c
+++ b/arch/arm/mach-pxa/saar.c
@@ -427,11 +427,15 @@ static void ltm022a97a_lcd_power(int on, struct fb_var_screeninfo *var)
 		gpio_set_value(GPIO_LCD_RESET, 0); msleep(100);
 		gpio_set_value(GPIO_LCD_RESET, 1); msleep(10);
 
-		pxafb_smart_queue(info, ARRAY_AND_SIZE(lcd_power_on));
-		pxafb_smart_queue(info, ARRAY_AND_SIZE(lcd_panel_on));
+		pxafb_smart_queue(info, lcd_power_on,
+				  ARRAY_SIZE(lcd_power_on));
+		pxafb_smart_queue(info, lcd_panel_on,
+				  ARRAY_SIZE(lcd_panel_on));
 	} else {
-		pxafb_smart_queue(info, ARRAY_AND_SIZE(lcd_panel_off));
-		pxafb_smart_queue(info, ARRAY_AND_SIZE(lcd_power_off));
+		pxafb_smart_queue(info, lcd_panel_off,
+				  ARRAY_SIZE(lcd_panel_off));
+		pxafb_smart_queue(info, lcd_power_off,
+				  ARRAY_SIZE(lcd_power_off));
 	}
 
 	err = pxafb_smart_flush(info);
@@ -441,7 +445,8 @@ static void ltm022a97a_lcd_power(int on, struct fb_var_screeninfo *var)
 
 static void ltm022a97a_update(struct fb_info *info)
 {
-	pxafb_smart_queue(info, ARRAY_AND_SIZE(update_framedata));
+	pxafb_smart_queue(info, update_framedata,
+			  ARRAY_SIZE(update_framedata));
 	pxafb_smart_flush(info);
 }
 
@@ -509,7 +514,7 @@ static struct i2c_board_info saar_i2c_info[] = {
 static void __init saar_init_i2c(void)
 {
 	pxa_set_i2c_info(NULL);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(saar_i2c_info));
+	i2c_register_board_info(0, saar_i2c_info, ARRAY_SIZE(saar_i2c_info));
 }
 #else
 static inline void saar_init_i2c(void) {}
@@ -581,7 +586,7 @@ static void __init saar_init_onenand(void) {}
 static void __init saar_init(void)
 {
 	/* initialize MFP configurations */
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(saar_mfp_cfg));
+	pxa3xx_mfp_config(saar_mfp_cfg, ARRAY_SIZE(saar_mfp_cfg));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
index 4c29173..19a3ac6 100644
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -584,7 +584,8 @@ static void __init spitz_spi_init(void)
 	}
 
 	pxa2xx_set_spi_info(2, &spitz_spi_info);
-	spi_register_board_info(ARRAY_AND_SIZE(spitz_spi_devices));
+	spi_register_board_info(spitz_spi_devices,
+				ARRAY_SIZE(spitz_spi_devices));
 }
 #else
 static inline void spitz_spi_init(void) {}
@@ -916,7 +917,8 @@ static void __init spitz_i2c_init(void)
 	pxa_set_i2c_info(NULL);
 	pxa27x_set_i2c_power_info(NULL);
 	i2c_register_board_info(0, spitz_i2c_devs, size);
-	i2c_register_board_info(1, ARRAY_AND_SIZE(spitz_pi2c_devs));
+	i2c_register_board_info(1, spitz_pi2c_devs,
+				ARRAY_SIZE(spitz_pi2c_devs));
 }
 #else
 static inline void spitz_i2c_init(void) {}
@@ -950,7 +952,7 @@ static void __init spitz_init(void)
 	/* Stop 3.6MHz and drive HIGH to PCMCIA and CS */
 	PCFR |= PCFR_OPDE;
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(spitz_pin_config));
+	pxa2xx_mfp_config(spitz_pin_config, ARRAY_SIZE(spitz_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
diff --git a/arch/arm/mach-pxa/spitz_pm.c b/arch/arm/mach-pxa/spitz_pm.c
index e191f99..aedd4e9 100644
--- a/arch/arm/mach-pxa/spitz_pm.c
+++ b/arch/arm/mach-pxa/spitz_pm.c
@@ -50,7 +50,8 @@ static struct gpio spitz_charger_gpios[] = {
 
 static void spitz_charger_init(void)
 {
-	gpio_request_array(ARRAY_AND_SIZE(spitz_charger_gpios));
+	gpio_request_array(spitz_charger_gpios,
+			   ARRAY_SIZE(spitz_charger_gpios));
 }
 
 static void spitz_measure_temp(int on)
diff --git a/arch/arm/mach-pxa/tavorevb.c b/arch/arm/mach-pxa/tavorevb.c
index 4680efe..8046211 100644
--- a/arch/arm/mach-pxa/tavorevb.c
+++ b/arch/arm/mach-pxa/tavorevb.c
@@ -424,10 +424,10 @@ static void ltm020d550_lcd_power(int on, struct fb_var_screeninfo *var)
 	struct fb_info *info = container_of(var, struct fb_info, var);
 
 	if (on) {
-		pxafb_smart_queue(info, ARRAY_AND_SIZE(panel_init));
-		pxafb_smart_queue(info, ARRAY_AND_SIZE(panel_on));
+		pxafb_smart_queue(info, panel_init, ARRAY_SIZE(panel_init));
+		pxafb_smart_queue(info, panel_on, ARRAY_SIZE(panel_on));
 	} else {
-		pxafb_smart_queue(info, ARRAY_AND_SIZE(panel_off));
+		pxafb_smart_queue(info, panel_off, ARRAY_SIZE(panel_off));
 	}
 
 	if (pxafb_smart_flush(info))
@@ -436,7 +436,8 @@ static void ltm020d550_lcd_power(int on, struct fb_var_screeninfo *var)
 
 static void ltm020d550_update(struct fb_info *info)
 {
-	pxafb_smart_queue(info, ARRAY_AND_SIZE(update_framedata));
+	pxafb_smart_queue(info, update_framedata,
+			  ARRAY_SIZE(update_framedata));
 	pxafb_smart_flush(info);
 }
 
@@ -479,7 +480,7 @@ static inline void tavorevb_init_lcd(void) {}
 static void __init tavorevb_init(void)
 {
 	/* initialize MFP configurations */
-	pxa3xx_mfp_config(ARRAY_AND_SIZE(tavorevb_mfp_cfg));
+	pxa3xx_mfp_config(tavorevb_mfp_cfg, ARRAY_SIZE(tavorevb_mfp_cfg));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
diff --git a/arch/arm/mach-pxa/tosa.c b/arch/arm/mach-pxa/tosa.c
index 0206b91..f60cf2e 100644
--- a/arch/arm/mach-pxa/tosa.c
+++ b/arch/arm/mach-pxa/tosa.c
@@ -928,7 +928,7 @@ static void tosa_restart(enum reboot_mode mode, const char *cmd)
 
 static void __init tosa_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(tosa_pin_config));
+	pxa2xx_mfp_config(tosa_pin_config, ARRAY_SIZE(tosa_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
diff --git a/arch/arm/mach-pxa/trizeps4.c b/arch/arm/mach-pxa/trizeps4.c
index c580434..6080103 100644
--- a/arch/arm/mach-pxa/trizeps4.c
+++ b/arch/arm/mach-pxa/trizeps4.c
@@ -501,9 +501,11 @@ static struct pxafb_mach_info toshiba_lcd = {
 
 static void __init trizeps4_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(trizeps4_pin_config));
+	pxa2xx_mfp_config(trizeps4_pin_config,
+			  ARRAY_SIZE(trizeps4_pin_config));
 	if (machine_is_trizeps4wl()) {
-		pxa2xx_mfp_config(ARRAY_AND_SIZE(trizeps4wl_pin_config));
+		pxa2xx_mfp_config(trizeps4wl_pin_config,
+				  ARRAY_SIZE(trizeps4wl_pin_config));
 		platform_add_devices(trizeps4wl_devices,
 					ARRAY_SIZE(trizeps4wl_devices));
 	} else {
diff --git a/arch/arm/mach-pxa/viper.c b/arch/arm/mach-pxa/viper.c
index 9c363c0..67d6b1e 100644
--- a/arch/arm/mach-pxa/viper.c
+++ b/arch/arm/mach-pxa/viper.c
@@ -923,7 +923,7 @@ static void __init viper_init(void)
 
 	pm_power_off = viper_power_off;
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(viper_pin_config));
+	pxa2xx_mfp_config(viper_pin_config, ARRAY_SIZE(viper_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
@@ -960,7 +960,8 @@ static void __init viper_init(void)
 		pr_info("viper: No version register.\n");
 	}
 
-	i2c_register_board_info(1, ARRAY_AND_SIZE(viper_i2c_devices));
+	i2c_register_board_info(1, viper_i2c_devices,
+				ARRAY_SIZE(viper_i2c_devices));
 
 	viper_tpm_init();
 	pxa_set_ac97_info(NULL);
diff --git a/arch/arm/mach-pxa/xcep.c b/arch/arm/mach-pxa/xcep.c
index 13b1d45..29b36c9 100644
--- a/arch/arm/mach-pxa/xcep.c
+++ b/arch/arm/mach-pxa/xcep.c
@@ -161,7 +161,7 @@ static mfp_cfg_t xcep_pin_config[] __initdata = {
 
 static void __init xcep_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(xcep_pin_config));
+	pxa2xx_mfp_config(xcep_pin_config, ARRAY_SIZE(xcep_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
@@ -174,7 +174,7 @@ static void __init xcep_init(void)
 	/* Set RDF and RDN to appropriate values (chip select 5 (fpga)) */
 	__raw_writel((__raw_readl(MSC2) & 0xffff) | 0x72A00000, MSC2);
 
-	platform_add_devices(ARRAY_AND_SIZE(devices));
+	platform_add_devices(devices, ARRAY_SIZE(devices));
 	pxa_set_i2c_info(&xcep_i2c_platform_data);
 }
 
diff --git a/arch/arm/mach-pxa/zeus.c b/arch/arm/mach-pxa/zeus.c
index f5d4364..cabf8c2 100644
--- a/arch/arm/mach-pxa/zeus.c
+++ b/arch/arm/mach-pxa/zeus.c
@@ -839,7 +839,7 @@ static void __init zeus_init(void)
 	pm_power_off = zeus_power_off;
 	zeus_setup_apm();
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(zeus_pin_config));
+	pxa2xx_mfp_config(zeus_pin_config, ARRAY_SIZE(zeus_pin_config));
 
 	platform_add_devices(zeus_devices, ARRAY_SIZE(zeus_devices));
 
@@ -854,7 +854,8 @@ static void __init zeus_init(void)
 	pxa_set_udc_info(&zeus_udc_info);
 	pxa_set_ac97_info(&zeus_ac97_info);
 	pxa_set_i2c_info(NULL);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(zeus_i2c_devices));
+	i2c_register_board_info(0, zeus_i2c_devices,
+				ARRAY_SIZE(zeus_i2c_devices));
 	pxa2xx_set_spi_info(3, &pxa2xx_spi_ssp3_master_info);
 	spi_register_board_info(zeus_spi_board_info, ARRAY_SIZE(zeus_spi_board_info));
 }
diff --git a/arch/arm/mach-pxa/zylonite_pxa300.c b/arch/arm/mach-pxa/zylonite_pxa300.c
index 86e59c0..c41f075 100644
--- a/arch/arm/mach-pxa/zylonite_pxa300.c
+++ b/arch/arm/mach-pxa/zylonite_pxa300.c
@@ -243,7 +243,8 @@ static struct i2c_board_info zylonite_i2c_board_info[] = {
 static void __init zylonite_init_i2c(void)
 {
 	pxa_set_i2c_info(NULL);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(zylonite_i2c_board_info));
+	i2c_register_board_info(0, zylonite_i2c_board_info,
+				ARRAY_SIZE(zylonite_i2c_board_info));
 }
 #else
 static inline void zylonite_init_i2c(void) {}
@@ -253,7 +254,7 @@ void __init zylonite_pxa300_init(void)
 {
 	if (cpu_is_pxa300() || cpu_is_pxa310()) {
 		/* initialize MFP */
-		pxa3xx_mfp_config(ARRAY_AND_SIZE(common_mfp_cfg));
+		pxa3xx_mfp_config(common_mfp_cfg, ARRAY_SIZE(common_mfp_cfg));
 
 		/* detect LCD panel */
 		zylonite_detect_lcd_panel();
@@ -265,12 +266,12 @@ void __init zylonite_pxa300_init(void)
 	}
 
 	if (cpu_is_pxa300()) {
-		pxa3xx_mfp_config(ARRAY_AND_SIZE(pxa300_mfp_cfg));
+		pxa3xx_mfp_config(pxa300_mfp_cfg, ARRAY_SIZE(pxa300_mfp_cfg));
 		gpio_eth_irq = mfp_to_gpio(MFP_PIN_GPIO99);
 	}
 
 	if (cpu_is_pxa310()) {
-		pxa3xx_mfp_config(ARRAY_AND_SIZE(pxa310_mfp_cfg));
+		pxa3xx_mfp_config(pxa310_mfp_cfg, ARRAY_SIZE(pxa310_mfp_cfg));
 		gpio_eth_irq = mfp_to_gpio(MFP_PIN_GPIO102);
 	}
 
diff --git a/arch/arm/mach-pxa/zylonite_pxa320.c b/arch/arm/mach-pxa/zylonite_pxa320.c
index 9942bac..0a005f8 100644
--- a/arch/arm/mach-pxa/zylonite_pxa320.c
+++ b/arch/arm/mach-pxa/zylonite_pxa320.c
@@ -199,7 +199,7 @@ void __init zylonite_pxa320_init(void)
 {
 	if (cpu_is_pxa320()) {
 		/* initialize MFP */
-		pxa3xx_mfp_config(ARRAY_AND_SIZE(mfp_cfg));
+		pxa3xx_mfp_config(mfp_cfg, ARRAY_SIZE(mfp_cfg));
 
 		/* detect LCD panel */
 		zylonite_detect_lcd_panel();

