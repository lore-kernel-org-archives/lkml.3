Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3HKQyE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:54:04 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:18222
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475Ab3HKQwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:52:09 -0400
X-IronPort-AV: E=Sophos;i="4.89,857,1367964000"; 
   d="scan'208";a="23717954"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/16] arch/arm/mach-mmp: Avoid using ARRAY_AND_SIZE(e) as a function argument
Date: Sun, 11 Aug 2013 18:51:51 +0200
Message-Id: <1376239917-15594-11-git-send-email-Julia.Lawall@lip6.fr>
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

 arch/arm/mach-mmp/aspenite.c      |    5 +++--
 arch/arm/mach-mmp/avengers_lite.c |    3 ++-
 arch/arm/mach-mmp/brownstone.c    |    5 +++--
 arch/arm/mach-mmp/clock-mmp2.c    |    2 +-
 arch/arm/mach-mmp/clock-pxa168.c  |    2 +-
 arch/arm/mach-mmp/clock-pxa910.c  |    2 +-
 arch/arm/mach-mmp/flint.c         |    2 +-
 arch/arm/mach-mmp/gplugd.c        |    5 +++--
 arch/arm/mach-mmp/jasper.c        |    5 +++--
 arch/arm/mach-mmp/tavorevb.c      |    2 +-
 arch/arm/mach-mmp/teton_bga.c     |    5 +++--
 arch/arm/mach-mmp/ttc_dkb.c       |    7 ++++---
 12 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-mmp/aspenite.c b/arch/arm/mach-mmp/aspenite.c
index 0c00209..bc6c30d 100644
--- a/arch/arm/mach-mmp/aspenite.c
+++ b/arch/arm/mach-mmp/aspenite.c
@@ -242,11 +242,12 @@ static struct mv_usb_platform_data pxa168_sph_pdata = {
 
 static void __init common_init(void)
 {
-	mfp_config(ARRAY_AND_SIZE(common_pin_config));
+	mfp_config(common_pin_config, ARRAY_SIZE(common_pin_config));
 
 	/* on-chip devices */
 	pxa168_add_uart(1);
-	pxa168_add_twsi(1, NULL, ARRAY_AND_SIZE(aspenite_i2c_info));
+	pxa168_add_twsi(1, NULL, aspenite_i2c_info,
+			ARRAY_SIZE(aspenite_i2c_info));
 	pxa168_add_ssp(1);
 	pxa168_add_nand(&aspenite_nand_info);
 	pxa168_add_fb(&aspenite_lcd_info);
diff --git a/arch/arm/mach-mmp/avengers_lite.c b/arch/arm/mach-mmp/avengers_lite.c
index a451a0f..c2a73cf 100644
--- a/arch/arm/mach-mmp/avengers_lite.c
+++ b/arch/arm/mach-mmp/avengers_lite.c
@@ -39,7 +39,8 @@ static struct pxa_gpio_platform_data pxa168_gpio_pdata = {
 
 static void __init avengers_lite_init(void)
 {
-	mfp_config(ARRAY_AND_SIZE(avengers_lite_pin_config_V16F));
+	mfp_config(avengers_lite_pin_config_V16F,
+		   ARRAY_SIZE(avengers_lite_pin_config_V16F));
 
 	/* on-chip devices */
 	pxa168_add_uart(2);
diff --git a/arch/arm/mach-mmp/brownstone.c b/arch/arm/mach-mmp/brownstone.c
index ac25544..81d325a 100644
--- a/arch/arm/mach-mmp/brownstone.c
+++ b/arch/arm/mach-mmp/brownstone.c
@@ -202,7 +202,7 @@ static struct sram_platdata mmp2_isram_platdata = {
 
 static void __init brownstone_init(void)
 {
-	mfp_config(ARRAY_AND_SIZE(brownstone_pin_config));
+	mfp_config(brownstone_pin_config, ARRAY_SIZE(brownstone_pin_config));
 
 	/* on-chip devices */
 	mmp2_add_uart(1);
@@ -210,7 +210,8 @@ static void __init brownstone_init(void)
 	platform_device_add_data(&mmp2_device_gpio, &mmp2_gpio_pdata,
 				 sizeof(struct pxa_gpio_platform_data));
 	platform_device_register(&mmp2_device_gpio);
-	mmp2_add_twsi(1, NULL, ARRAY_AND_SIZE(brownstone_twsi1_info));
+	mmp2_add_twsi(1, NULL, brownstone_twsi1_info,
+		      ARRAY_SIZE(brownstone_twsi1_info));
 	mmp2_add_sdhost(0, &mmp2_sdh_platdata_mmc0); /* SD/MMC */
 	mmp2_add_sdhost(2, &mmp2_sdh_platdata_mmc2); /* eMMC */
 	mmp2_add_asram(&mmp2_asram_platdata);
diff --git a/arch/arm/mach-mmp/clock-mmp2.c b/arch/arm/mach-mmp/clock-mmp2.c
index 53d77cb..a862d1d 100644
--- a/arch/arm/mach-mmp/clock-mmp2.c
+++ b/arch/arm/mach-mmp/clock-mmp2.c
@@ -107,5 +107,5 @@ static struct clk_lookup mmp2_clkregs[] = {
 
 void __init mmp2_clk_init(void)
 {
-	clkdev_add_table(ARRAY_AND_SIZE(mmp2_clkregs));
+	clkdev_add_table(mmp2_clkregs, ARRAY_SIZE(mmp2_clkregs));
 }
diff --git a/arch/arm/mach-mmp/clock-pxa168.c b/arch/arm/mach-mmp/clock-pxa168.c
index c572f21..7da2d77 100644
--- a/arch/arm/mach-mmp/clock-pxa168.c
+++ b/arch/arm/mach-mmp/clock-pxa168.c
@@ -87,5 +87,5 @@ static struct clk_lookup pxa168_clkregs[] = {
 
 void __init pxa168_clk_init(void)
 {
-	clkdev_add_table(ARRAY_AND_SIZE(pxa168_clkregs));
+	clkdev_add_table(pxa168_clkregs, ARRAY_SIZE(pxa168_clkregs));
 }
diff --git a/arch/arm/mach-mmp/clock-pxa910.c b/arch/arm/mach-mmp/clock-pxa910.c
index 379e1df..c01f3e1 100644
--- a/arch/arm/mach-mmp/clock-pxa910.c
+++ b/arch/arm/mach-mmp/clock-pxa910.c
@@ -63,5 +63,5 @@ static struct clk_lookup pxa910_clkregs[] = {
 
 void __init pxa910_clk_init(void)
 {
-	clkdev_add_table(ARRAY_AND_SIZE(pxa910_clkregs));
+	clkdev_add_table(pxa910_clkregs, ARRAY_SIZE(pxa910_clkregs));
 }
diff --git a/arch/arm/mach-mmp/flint.c b/arch/arm/mach-mmp/flint.c
index 6291c33..102550d 100644
--- a/arch/arm/mach-mmp/flint.c
+++ b/arch/arm/mach-mmp/flint.c
@@ -111,7 +111,7 @@ static struct platform_device smc91x_device = {
 
 static void __init flint_init(void)
 {
-	mfp_config(ARRAY_AND_SIZE(flint_pin_config));
+	mfp_config(flint_pin_config, ARRAY_SIZE(flint_pin_config));
 
 	/* on-chip devices */
 	mmp2_add_uart(1);
diff --git a/arch/arm/mach-mmp/gplugd.c b/arch/arm/mach-mmp/gplugd.c
index d81b247..a44ab84 100644
--- a/arch/arm/mach-mmp/gplugd.c
+++ b/arch/arm/mach-mmp/gplugd.c
@@ -183,14 +183,15 @@ static void __init select_disp_freq(void)
 
 static void __init gplugd_init(void)
 {
-	mfp_config(ARRAY_AND_SIZE(gplugd_pin_config));
+	mfp_config(gplugd_pin_config, ARRAY_SIZE(gplugd_pin_config));
 
 	select_disp_freq();
 
 	/* on-chip devices */
 	pxa168_add_uart(3);
 	pxa168_add_ssp(1);
-	pxa168_add_twsi(0, NULL, ARRAY_AND_SIZE(gplugd_i2c_board_info));
+	pxa168_add_twsi(0, NULL, gplugd_i2c_board_info,
+			ARRAY_SIZE(gplugd_i2c_board_info));
 	platform_device_add_data(&pxa168_device_gpio, &pxa168_gpio_pdata,
 				 sizeof(struct pxa_gpio_platform_data));
 	platform_device_register(&pxa168_device_gpio);
diff --git a/arch/arm/mach-mmp/jasper.c b/arch/arm/mach-mmp/jasper.c
index 0e9e5c0..f46549d 100644
--- a/arch/arm/mach-mmp/jasper.c
+++ b/arch/arm/mach-mmp/jasper.c
@@ -164,12 +164,13 @@ static struct sdhci_pxa_platdata mmp2_sdh_platdata_mmc0 = {
 
 static void __init jasper_init(void)
 {
-	mfp_config(ARRAY_AND_SIZE(jasper_pin_config));
+	mfp_config(jasper_pin_config, ARRAY_SIZE(jasper_pin_config));
 
 	/* on-chip devices */
 	mmp2_add_uart(1);
 	mmp2_add_uart(3);
-	mmp2_add_twsi(1, NULL, ARRAY_AND_SIZE(jasper_twsi1_info));
+	mmp2_add_twsi(1, NULL, jasper_twsi1_info,
+		      ARRAY_SIZE(jasper_twsi1_info));
 	platform_device_add_data(&mmp2_device_gpio, &mmp2_gpio_pdata,
 				 sizeof(struct pxa_gpio_platform_data));
 	platform_device_register(&mmp2_device_gpio);
diff --git a/arch/arm/mach-mmp/tavorevb.c b/arch/arm/mach-mmp/tavorevb.c
index cdfc9bf..30d597f 100644
--- a/arch/arm/mach-mmp/tavorevb.c
+++ b/arch/arm/mach-mmp/tavorevb.c
@@ -94,7 +94,7 @@ static struct platform_device smc91x_device = {
 
 static void __init tavorevb_init(void)
 {
-	mfp_config(ARRAY_AND_SIZE(tavorevb_pin_config));
+	mfp_config(tavorevb_pin_config, ARRAY_SIZE(tavorevb_pin_config));
 
 	/* on-chip devices */
 	pxa910_add_uart(1);
diff --git a/arch/arm/mach-mmp/teton_bga.c b/arch/arm/mach-mmp/teton_bga.c
index 6aa53fb..43de296 100644
--- a/arch/arm/mach-mmp/teton_bga.c
+++ b/arch/arm/mach-mmp/teton_bga.c
@@ -82,12 +82,13 @@ static struct i2c_board_info teton_bga_i2c_info[] __initdata = {
 
 static void __init teton_bga_init(void)
 {
-	mfp_config(ARRAY_AND_SIZE(teton_bga_pin_config));
+	mfp_config(teton_bga_pin_config, ARRAY_SIZE(teton_bga_pin_config));
 
 	/* on-chip devices */
 	pxa168_add_uart(1);
 	pxa168_add_keypad(&teton_bga_keypad_info);
-	pxa168_add_twsi(0, NULL, ARRAY_AND_SIZE(teton_bga_i2c_info));
+	pxa168_add_twsi(0, NULL, teton_bga_i2c_info,
+			ARRAY_SIZE(teton_bga_i2c_info));
 	platform_device_add_data(&pxa168_device_gpio, &pxa168_gpio_pdata,
 				 sizeof(struct pxa_gpio_platform_data));
 	platform_device_register(&pxa168_device_gpio);
diff --git a/arch/arm/mach-mmp/ttc_dkb.c b/arch/arm/mach-mmp/ttc_dkb.c
index 8483906..9ddb70b 100644
--- a/arch/arm/mach-mmp/ttc_dkb.c
+++ b/arch/arm/mach-mmp/ttc_dkb.c
@@ -273,7 +273,7 @@ static void __init add_disp(void)
 
 static void __init ttc_dkb_init(void)
 {
-	mfp_config(ARRAY_AND_SIZE(ttc_dkb_pin_config));
+	mfp_config(ttc_dkb_pin_config, ARRAY_SIZE(ttc_dkb_pin_config));
 
 	/* on-chip devices */
 	pxa910_add_uart(1);
@@ -282,10 +282,11 @@ static void __init ttc_dkb_init(void)
 #endif
 
 	/* off-chip devices */
-	pxa910_add_twsi(0, NULL, ARRAY_AND_SIZE(ttc_dkb_i2c_info));
+	pxa910_add_twsi(0, NULL, ttc_dkb_i2c_info,
+			ARRAY_SIZE(ttc_dkb_i2c_info));
 	platform_device_add_data(&pxa910_device_gpio, &pxa910_gpio_pdata,
 				 sizeof(struct pxa_gpio_platform_data));
-	platform_add_devices(ARRAY_AND_SIZE(ttc_dkb_devices));
+	platform_add_devices(ttc_dkb_devices, ARRAY_SIZE(ttc_dkb_devices));
 
 #ifdef CONFIG_USB_MV_UDC
 	pxa168_device_u2o.dev.platform_data = &ttc_usb_pdata;

