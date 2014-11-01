Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbaKAAv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 20:51:58 -0400
Received: from smtprelay0129.hostedemail.com ([216.40.44.129]:59553 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753560AbaKAAv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 20:51:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:69:327:355:379:541:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2196:2199:2393:2538:2559:2562:2734:2828:2896:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:4250:4321:4385:4605:5007:6119:6261:7874:7903:8957:9038:9040:10004:10848:10954:11026:11233:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:12683:13972:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: voice75_10723400cd33b
X-Filterd-Recvd-Size: 20335
Message-ID: <1414803111.13647.13.camel@perches.com>
Subject: [PATCH] davinci: Use standard logging styles
From: Joe Perches <joe@perches.com>
To: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 31 Oct 2014 17:51:51 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printks to pr_<level> and pr_warning to pr_warn.

Other miscellanea:

o Coalesce formats
o Realign arguments
o Use %s, __func__ instead of embedded function names
o Add pr_fmt to mityomapl138 and mux

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-davinci/board-da830-evm.c    | 89 +++++++++++++-----------------
 arch/arm/mach-davinci/board-dm644x-evm.c   | 10 ++--
 arch/arm/mach-davinci/board-mityomapl138.c | 45 ++++++++-------
 arch/arm/mach-davinci/board-neuros-osd2.c  |  5 +-
 arch/arm/mach-davinci/clock.c              |  2 +-
 arch/arm/mach-davinci/mux.c                | 15 +++--
 arch/arm/mach-davinci/time.c               | 13 ++---
 7 files changed, 81 insertions(+), 98 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index 5623131..f8f62fb 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -80,8 +80,8 @@ static int da830_evm_usb_ocic_notify(da8xx_ocic_handler_t handler)
 				    IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 				    "OHCI over-current indicator", NULL);
 		if (error)
-			printk(KERN_ERR "%s: could not request IRQ to watch "
-			       "over-current indicator changes\n", __func__);
+			pr_err("%s: could not request IRQ to watch over-current indicator changes\n",
+			       __func__);
 	} else
 		free_irq(irq, NULL);
 
@@ -145,8 +145,7 @@ static __init void da830_evm_usb_init(void)
 	/* USB_REFCLKIN is not used. */
 	ret = davinci_cfg_reg(DA830_USB0_DRVVBUS);
 	if (ret)
-		pr_warning("%s: USB 2.0 PinMux setup failed: %d\n",
-			   __func__, ret);
+		pr_warn("%s: USB 2.0 PinMux setup failed: %d\n", __func__, ret);
 	else {
 		/*
 		 * TPS2065 switch @ 5V supplies 1 A (sustains 1.5 A),
@@ -154,37 +153,35 @@ static __init void da830_evm_usb_init(void)
 		 */
 		ret = da8xx_register_usb20(1000, 3);
 		if (ret)
-			pr_warning("%s: USB 2.0 registration failed: %d\n",
-				   __func__, ret);
+			pr_warn("%s: USB 2.0 registration failed: %d\n",
+				__func__, ret);
 	}
 
 	ret = davinci_cfg_reg_list(da830_evm_usb11_pins);
 	if (ret) {
-		pr_warning("%s: USB 1.1 PinMux setup failed: %d\n",
-			   __func__, ret);
+		pr_warn("%s: USB 1.1 PinMux setup failed: %d\n", __func__, ret);
 		return;
 	}
 
 	ret = gpio_request(ON_BD_USB_DRV, "ON_BD_USB_DRV");
 	if (ret) {
-		printk(KERN_ERR "%s: failed to request GPIO for USB 1.1 port "
-		       "power control: %d\n", __func__, ret);
+		pr_err("%s: failed to request GPIO for USB 1.1 port power control: %d\n",
+		       __func__, ret);
 		return;
 	}
 	gpio_direction_output(ON_BD_USB_DRV, 0);
 
 	ret = gpio_request(ON_BD_USB_OVC, "ON_BD_USB_OVC");
 	if (ret) {
-		printk(KERN_ERR "%s: failed to request GPIO for USB 1.1 port "
-		       "over-current indicator: %d\n", __func__, ret);
+		pr_err("%s: failed to request GPIO for USB 1.1 port over-current indicator: %d\n",
+		       __func__, ret);
 		return;
 	}
 	gpio_direction_input(ON_BD_USB_OVC);
 
 	ret = da8xx_register_usb11(&da830_evm_usb11_pdata);
 	if (ret)
-		pr_warning("%s: USB 1.1 registration failed: %d\n",
-			   __func__, ret);
+		pr_warn("%s: USB 1.1 registration failed: %d\n", __func__, ret);
 }
 
 static const short da830_evm_mcasp1_pins[] = {
@@ -252,31 +249,29 @@ static inline void da830_evm_init_mmc(void)
 
 	ret = davinci_cfg_reg_list(da830_evm_mmc_sd_pins);
 	if (ret) {
-		pr_warning("da830_evm_init: mmc/sd mux setup failed: %d\n",
-				ret);
+		pr_warn("%s: mmc/sd mux setup failed: %d\n", __func__, ret);
 		return;
 	}
 
 	ret = gpio_request(DA830_MMCSD_WP_PIN, "MMC WP");
 	if (ret) {
-		pr_warning("da830_evm_init: can not open GPIO %d\n",
-			   DA830_MMCSD_WP_PIN);
+		pr_warn("%s: can not open GPIO %d\n",
+			__func__, DA830_MMCSD_WP_PIN);
 		return;
 	}
 	gpio_direction_input(DA830_MMCSD_WP_PIN);
 
 	ret = gpio_request(DA830_MMCSD_CD_PIN, "MMC CD\n");
 	if (ret) {
-		pr_warning("da830_evm_init: can not open GPIO %d\n",
-			   DA830_MMCSD_CD_PIN);
+		pr_warn("%s: can not open GPIO %d\n",
+			__func__, DA830_MMCSD_CD_PIN);
 		return;
 	}
 	gpio_direction_input(DA830_MMCSD_CD_PIN);
 
 	ret = da8xx_register_mmcsd0(&da830_evm_mmc_config);
 	if (ret) {
-		pr_warning("da830_evm_init: mmc/sd registration failed: %d\n",
-				ret);
+		pr_warn("%s: mmc/sd registration failed: %d\n", __func__, ret);
 		gpio_free(DA830_MMCSD_WP_PIN);
 	}
 }
@@ -404,23 +399,21 @@ static inline void da830_evm_init_nand(int mux_mode)
 	int ret;
 
 	if (HAS_MMC) {
-		pr_warning("WARNING: both MMC/SD and NAND are "
-				"enabled, but they share AEMIF pins.\n"
-				"\tDisable MMC/SD for NAND support.\n");
+		pr_warn("WARNING: both MMC/SD and NAND are enabled, but they share AEMIF pins\n"
+			"\tDisable MMC/SD for NAND support\n");
 		return;
 	}
 
 	ret = davinci_cfg_reg_list(da830_evm_emif25_pins);
 	if (ret)
-		pr_warning("da830_evm_init: emif25 mux setup failed: %d\n",
-				ret);
+		pr_warn("%s: emif25 mux setup failed: %d\n", __func__, ret);
 
 	ret = platform_device_register(&da830_evm_nand_device);
 	if (ret)
-		pr_warning("da830_evm_init: NAND device not registered.\n");
+		pr_warn("%s: NAND device not registered\n", __func__);
 
 	if (davinci_aemif_setup(&da830_evm_nand_device))
-		pr_warn("%s: Cannot configure AEMIF.\n", __func__);
+		pr_warn("%s: Cannot configure AEMIF\n", __func__);
 
 	gpio_direction_output(mux_mode, 1);
 }
@@ -435,12 +428,11 @@ static inline void da830_evm_init_lcdc(int mux_mode)
 
 	ret = davinci_cfg_reg_list(da830_lcdcntl_pins);
 	if (ret)
-		pr_warning("da830_evm_init: lcdcntl mux setup failed: %d\n",
-				ret);
+		pr_warn("%s: lcdcntl mux setup failed: %d\n", __func__, ret);
 
 	ret = da8xx_register_lcdc(&sharp_lcd035q3dg01_pdata);
 	if (ret)
-		pr_warning("da830_evm_init: lcd setup failed: %d\n", ret);
+		pr_warn("%s: lcd setup failed: %d\n", __func__, ret);
 
 	gpio_direction_output(mux_mode, 0);
 }
@@ -598,22 +590,19 @@ static __init void da830_evm_init(void)
 
 	ret = da830_register_gpio();
 	if (ret)
-		pr_warn("da830_evm_init: GPIO init failed: %d\n", ret);
+		pr_warn("%s: GPIO init failed: %d\n", __func__, ret);
 
 	ret = da830_register_edma(da830_edma_rsv);
 	if (ret)
-		pr_warning("da830_evm_init: edma registration failed: %d\n",
-				ret);
+		pr_warn("%s: edma registration failed: %d\n", __func__, ret);
 
 	ret = davinci_cfg_reg_list(da830_i2c0_pins);
 	if (ret)
-		pr_warning("da830_evm_init: i2c0 mux setup failed: %d\n",
-				ret);
+		pr_warn("%s: i2c0 mux setup failed: %d\n", __func__, ret);
 
 	ret = da8xx_register_i2c(0, &da830_evm_i2c_0_pdata);
 	if (ret)
-		pr_warning("da830_evm_init: i2c0 registration failed: %d\n",
-				ret);
+		pr_warn("%s: i2c0 registration failed: %d\n", __func__, ret);
 
 	da830_evm_usb_init();
 
@@ -622,18 +611,16 @@ static __init void da830_evm_init(void)
 
 	ret = davinci_cfg_reg_list(da830_cpgmac_pins);
 	if (ret)
-		pr_warning("da830_evm_init: cpgmac mux setup failed: %d\n",
-				ret);
+		pr_warn("%s: cpgmac mux setup failed: %d\n", __func__, ret);
 
 	ret = da8xx_register_emac();
 	if (ret)
-		pr_warning("da830_evm_init: emac registration failed: %d\n",
-				ret);
+		pr_warn("%s: emac registration failed: %d\n", __func__, ret);
 
 	ret = da8xx_register_watchdog();
 	if (ret)
-		pr_warning("da830_evm_init: watchdog registration failed: %d\n",
-				ret);
+		pr_warn("%s: watchdog registration failed: %d\n",
+			__func__, ret);
 
 	davinci_serial_init(da8xx_serial_device);
 	i2c_register_board_info(1, da830_evm_i2c_devices,
@@ -641,8 +628,7 @@ static __init void da830_evm_init(void)
 
 	ret = davinci_cfg_reg_list(da830_evm_mcasp1_pins);
 	if (ret)
-		pr_warning("da830_evm_init: mcasp1 mux setup failed: %d\n",
-				ret);
+		pr_warn("%s: mcasp1 mux setup failed: %d\n", __func__, ret);
 
 	da8xx_register_mcasp(1, &da830_evm_snd_data);
 
@@ -650,18 +636,17 @@ static __init void da830_evm_init(void)
 
 	ret = da8xx_register_rtc();
 	if (ret)
-		pr_warning("da830_evm_init: rtc setup failed: %d\n", ret);
+		pr_warn("%s: rtc setup failed: %d\n", __func__, ret);
 
 	ret = spi_register_board_info(da830evm_spi_info,
 				      ARRAY_SIZE(da830evm_spi_info));
 	if (ret)
-		pr_warn("%s: spi info registration failed: %d\n", __func__,
-			ret);
+		pr_warn("%s: spi info registration failed: %d\n",
+			__func__, ret);
 
 	ret = da8xx_register_spi_bus(0, ARRAY_SIZE(da830evm_spi_info));
 	if (ret)
-		pr_warning("da830_evm_init: spi 0 registration failed: %d\n",
-			   ret);
+		pr_warn("%s: spi 0 registration failed: %d\n", __func__, ret);
 }
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index e583e58..1a0898c 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -767,9 +767,8 @@ static __init void davinci_evm_init(void)
 
 	if (HAS_ATA) {
 		if (HAS_NAND || HAS_NOR)
-			pr_warning("WARNING: both IDE and Flash are "
-				"enabled, but they share AEMIF pins.\n"
-				"\tDisable IDE for NAND/NOR support.\n");
+			pr_warn("WARNING: both IDE and Flash are enabled, but they share AEMIF pins\n"
+				"\tDisable IDE for NAND/NOR support\n");
 		davinci_init_ide();
 	} else if (HAS_NAND || HAS_NOR) {
 		davinci_cfg_reg(DM644X_HPIEN_DISABLE);
@@ -780,13 +779,12 @@ static __init void davinci_evm_init(void)
 			platform_device_register(&davinci_evm_nandflash_device);
 
 			if (davinci_aemif_setup(&davinci_evm_nandflash_device))
-				pr_warn("%s: Cannot configure AEMIF.\n",
+				pr_warn("%s: Cannot configure AEMIF\n",
 					__func__);
 
 			evm_leds[7].default_trigger = "nand-disk";
 			if (HAS_NOR)
-				pr_warning("WARNING: both NAND and NOR flash "
-					"are enabled; disable one of them.\n");
+				pr_warn("WARNING: both NAND and NOR flash are enabled; disable one of them.\n");
 		} else if (HAS_NOR)
 			platform_device_register(&davinci_evm_norflash_device);
 	}
diff --git a/arch/arm/mach-davinci/board-mityomapl138.c b/arch/arm/mach-davinci/board-mityomapl138.c
index 96fc00a..8cfbfe0 100644
--- a/arch/arm/mach-davinci/board-mityomapl138.c
+++ b/arch/arm/mach-davinci/board-mityomapl138.c
@@ -8,6 +8,8 @@
  * any kind, whether express or implied.
  */
 
+#define pr_fmt(fmt) "MityOMAPL138: " fmt
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/console.h>
@@ -107,7 +109,7 @@ static void mityomapl138_cpufreq_init(const char *partnum)
 
 	ret = da850_register_cpufreq("pll0_sysclk3");
 	if (ret)
-		pr_warning("cpufreq registration failed: %d\n", ret);
+		pr_warn("cpufreq registration failed: %d\n", ret);
 }
 #else
 static void mityomapl138_cpufreq_init(const char *partnum) { }
@@ -121,33 +123,31 @@ static void read_factory_config(struct memory_accessor *a, void *context)
 
 	ret = a->read(a, (char *)&factory_config, 0, sizeof(factory_config));
 	if (ret != sizeof(struct factory_config)) {
-		pr_warning("MityOMAPL138: Read Factory Config Failed: %d\n",
-				ret);
+		pr_warn("Read Factory Config Failed: %d\n", ret);
 		goto bad_config;
 	}
 
 	if (factory_config.magic != FACTORY_CONFIG_MAGIC) {
-		pr_warning("MityOMAPL138: Factory Config Magic Wrong (%X)\n",
-				factory_config.magic);
+		pr_warn("Factory Config Magic Wrong (%X)\n",
+			factory_config.magic);
 		goto bad_config;
 	}
 
 	if (factory_config.version != FACTORY_CONFIG_VERSION) {
-		pr_warning("MityOMAPL138: Factory Config Version Wrong (%X)\n",
-				factory_config.version);
+		pr_warn("Factory Config Version Wrong (%X)\n",
+			factory_config.version);
 		goto bad_config;
 	}
 
-	pr_info("MityOMAPL138: Found MAC = %pM\n", factory_config.mac);
+	pr_info("Found MAC = %pM\n", factory_config.mac);
 	if (is_valid_ether_addr(factory_config.mac))
 		memcpy(soc_info->emac_pdata->mac_addr,
 			factory_config.mac, ETH_ALEN);
 	else
-		pr_warning("MityOMAPL138: Invalid MAC found "
-				"in factory config block\n");
+		pr_warn("Invalid MAC found in factory config block\n");
 
 	partnum = factory_config.partnum;
-	pr_info("MityOMAPL138: Part Number = %s\n", partnum);
+	pr_info("Part Number = %s\n", partnum);
 
 bad_config:
 	/* default maximum speed is valid for all platforms */
@@ -435,7 +435,7 @@ static void __init mityomapl138_setup_nand(void)
 				 ARRAY_SIZE(mityomapl138_devices));
 
 	if (davinci_aemif_setup(&mityomapl138_nandflash_device))
-		pr_warn("%s: Cannot configure AEMIF.\n", __func__);
+		pr_warn("%s: Cannot configure AEMIF\n", __func__);
 }
 
 static const short mityomap_mii_pins[] = {
@@ -478,7 +478,7 @@ static void __init mityomapl138_config_emac(void)
 	}
 
 	if (ret) {
-		pr_warning("mii/rmii mux setup failed: %d\n", ret);
+		pr_warn("mii/rmii mux setup failed: %d\n", ret);
 		return;
 	}
 
@@ -489,7 +489,7 @@ static void __init mityomapl138_config_emac(void)
 
 	ret = da8xx_register_emac();
 	if (ret)
-		pr_warning("emac registration failed: %d\n", ret);
+		pr_warn("emac registration failed: %d\n", ret);
 }
 
 static struct davinci_pm_config da850_pm_pdata = {
@@ -511,21 +511,21 @@ static void __init mityomapl138_init(void)
 	/* for now, no special EDMA channels are reserved */
 	ret = da850_register_edma(NULL);
 	if (ret)
-		pr_warning("edma registration failed: %d\n", ret);
+		pr_warn("edma registration failed: %d\n", ret);
 
 	ret = da8xx_register_watchdog();
 	if (ret)
-		pr_warning("watchdog registration failed: %d\n", ret);
+		pr_warn("watchdog registration failed: %d\n", ret);
 
 	davinci_serial_init(da8xx_serial_device);
 
 	ret = da8xx_register_i2c(0, &mityomap_i2c_0_pdata);
 	if (ret)
-		pr_warning("i2c0 registration failed: %d\n", ret);
+		pr_warn("i2c0 registration failed: %d\n", ret);
 
 	ret = pmic_tps65023_init();
 	if (ret)
-		pr_warning("TPS65023 PMIC init failed: %d\n", ret);
+		pr_warn("TPS65023 PMIC init failed: %d\n", ret);
 
 	mityomapl138_setup_nand();
 
@@ -537,22 +537,21 @@ static void __init mityomapl138_init(void)
 	ret = da8xx_register_spi_bus(1,
 				     ARRAY_SIZE(mityomapl138_spi_flash_info));
 	if (ret)
-		pr_warning("spi 1 registration failed: %d\n", ret);
+		pr_warn("spi 1 registration failed: %d\n", ret);
 
 	mityomapl138_config_emac();
 
 	ret = da8xx_register_rtc();
 	if (ret)
-		pr_warning("rtc setup failed: %d\n", ret);
+		pr_warn("rtc setup failed: %d\n", ret);
 
 	ret = da8xx_register_cpuidle();
 	if (ret)
-		pr_warning("cpuidle registration failed: %d\n", ret);
+		pr_warn("cpuidle registration failed: %d\n", ret);
 
 	ret = da850_register_pm(&da850_pm_device);
 	if (ret)
-		pr_warning("da850_evm_init: suspend registration failed: %d\n",
-				ret);
+		pr_warn("suspend registration failed: %d\n", ret);
 }
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index bb680af..8fcdcf8 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -183,9 +183,8 @@ static __init void davinci_ntosd2_init(void)
 
 	if (HAS_ATA) {
 		if (HAS_NAND)
-			pr_warning("WARNING: both IDE and Flash are "
-				"enabled, but they share AEMIF pins.\n"
-				"\tDisable IDE for NAND/NOR support.\n");
+			pr_warn("WARNING: both IDE and Flash are enabled, but they share AEMIF pins\n"
+				"\tDisable IDE for NAND/NOR support\n");
 		davinci_init_ide();
 	} else if (HAS_NAND) {
 		davinci_cfg_reg(DM644X_HPIEN_DISABLE);
diff --git a/arch/arm/mach-davinci/clock.c b/arch/arm/mach-davinci/clock.c
index 985e5fd..c70bb0a 100644
--- a/arch/arm/mach-davinci/clock.c
+++ b/arch/arm/mach-davinci/clock.c
@@ -564,7 +564,7 @@ int davinci_set_refclk_rate(unsigned long rate)
 
 	refclk = clk_get(NULL, "ref");
 	if (IS_ERR(refclk)) {
-		pr_err("%s: failed to get reference clock.\n", __func__);
+		pr_err("%s: failed to get reference clock\n", __func__);
 		return PTR_ERR(refclk);
 	}
 
diff --git a/arch/arm/mach-davinci/mux.c b/arch/arm/mach-davinci/mux.c
index f34a8dc..a8eb909 100644
--- a/arch/arm/mach-davinci/mux.c
+++ b/arch/arm/mach-davinci/mux.c
@@ -15,6 +15,9 @@
  *
  * Copyright (C) 2008 Texas Instruments.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
@@ -46,7 +49,7 @@ int __init_or_module davinci_cfg_reg(const unsigned long index)
 	}
 
 	if (index >= soc_info->pinmux_pins_num) {
-		printk(KERN_ERR "Invalid pin mux index: %lu (%lu)\n",
+		pr_err("Invalid pin mux index: %lu (%lu)\n",
 		       index, soc_info->pinmux_pins_num);
 		dump_stack();
 		return -ENODEV;
@@ -55,7 +58,7 @@ int __init_or_module davinci_cfg_reg(const unsigned long index)
 	cfg = &soc_info->pinmux_pins[index];
 
 	if (cfg->name == NULL) {
-		printk(KERN_ERR "No entry for the specified index\n");
+		pr_err("No entry for the specified index\n");
 		return -ENODEV;
 	}
 
@@ -82,15 +85,15 @@ int __init_or_module davinci_cfg_reg(const unsigned long index)
 
 	if (warn) {
 #ifdef CONFIG_DAVINCI_MUX_WARNINGS
-		printk(KERN_WARNING "MUX: initialized %s\n", cfg->name);
+		pr_warn("initialized %s\n", cfg->name);
 #endif
 	}
 
 #ifdef CONFIG_DAVINCI_MUX_DEBUG
 	if (cfg->debug || warn) {
-		printk(KERN_WARNING "MUX: Setting register %s\n", cfg->name);
-		printk(KERN_WARNING "	   %s (0x%08x) = 0x%08x -> 0x%08x\n",
-		       cfg->mux_reg_name, cfg->mux_reg, reg_orig, reg);
+		pr_warn("Setting register %s\n", cfg->name);
+		pr_warn("   %s (0x%08x) = 0x%08x -> 0x%08x\n",
+			cfg->mux_reg_name, cfg->mux_reg, reg_orig, reg);
 	}
 #endif
 
diff --git a/arch/arm/mach-davinci/time.c b/arch/arm/mach-davinci/time.c
index 24ad30f..160c960 100644
--- a/arch/arm/mach-davinci/time.c
+++ b/arch/arm/mach-davinci/time.c
@@ -342,8 +342,6 @@ void __init davinci_timer_init(void)
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
 	unsigned int clockevent_id;
 	unsigned int clocksource_id;
-	static char err[] __initdata = KERN_ERR
-		"%s: can't register clocksource!\n";
 	int i;
 
 	clockevent_id = soc_info->timer_info->clockevent_id;
@@ -364,12 +362,12 @@ void __init davinci_timer_init(void)
 
 		/* Only bottom timers can use compare regs */
 		if (IS_TIMER_TOP(clockevent_id))
-			pr_warning("davinci_timer_init: Invalid use"
-				" of system timers.  Results unpredictable.\n");
+			pr_warn("%s: Invalid use of system timers.  Results unpredictable.\n",
+				__func__);
 		else if ((dtip[event_timer].cmp_off == 0)
 				|| (dtip[event_timer].cmp_irq == 0))
-			pr_warning("davinci_timer_init:  Invalid timer instance"
-				" setup.  Results unpredictable.\n");
+			pr_warn("%s: Invalid timer instance setup.  Results unpredictable.\n",
+				__func__);
 		else {
 			timers[TID_CLOCKEVENT].opts |= TIMER_OPTS_USE_COMPARE;
 			clockevent_davinci.features = CLOCK_EVT_FEAT_ONESHOT;
@@ -389,7 +387,8 @@ void __init davinci_timer_init(void)
 	clocksource_davinci.name = id_to_name[clocksource_id];
 	if (clocksource_register_hz(&clocksource_davinci,
 				    davinci_clock_tick_rate))
-		printk(err, clocksource_davinci.name);
+		pr_err("%s: can't register clocksource!\n",
+		       clocksource_davinci.name);
 
 	sched_clock_register(davinci_read_sched_clock, 32,
 			  davinci_clock_tick_rate);


