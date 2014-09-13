Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaIMSbs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 14:31:48 -0400
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:53393 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752195AbaIMSbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 14:31:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:1:41:69:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:2196:2199:2393:2559:2562:2640:2896:3138:3139:3140:3141:3142:3865:3866:3868:3870:3871:4250:4321:4385:4605:5007:6119:6261:7874:7903:8957:9038:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:12683:13972:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: frogs82_f18beaa9d245
X-Filterd-Recvd-Size: 14892
From: Joe Perches <joe@perches.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] arm: mach-davinci: Convert pr_warning to pr_warn
Date: Sat, 13 Sep 2014 11:31:13 -0700
Message-Id: <29dd26b101f1eca0e115117bac85893f577a46dd.1410632835.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1410632834.git.joe@perches.com>
References: <cover.1410632834.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more common pr_warn.

Other miscellanea:

o Coalesce formats
o Realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-davinci/board-da830-evm.c    | 76 +++++++++++++-----------------
 arch/arm/mach-davinci/board-dm644x-evm.c   |  6 +--
 arch/arm/mach-davinci/board-mityomapl138.c | 38 +++++++--------
 arch/arm/mach-davinci/board-neuros-osd2.c  |  3 +-
 arch/arm/mach-davinci/time.c               |  6 +--
 5 files changed, 55 insertions(+), 74 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index 5623131..c73cd88 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
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
@@ -154,14 +153,14 @@ static __init void da830_evm_usb_init(void)
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
+		pr_warn("%s: USB 1.1 PinMux setup failed: %d\n",
+			__func__, ret);
 		return;
 	}
 
@@ -183,8 +182,8 @@ static __init void da830_evm_usb_init(void)
 
 	ret = da8xx_register_usb11(&da830_evm_usb11_pdata);
 	if (ret)
-		pr_warning("%s: USB 1.1 registration failed: %d\n",
-			   __func__, ret);
+		pr_warn("%s: USB 1.1 registration failed: %d\n",
+			__func__, ret);
 }
 
 static const short da830_evm_mcasp1_pins[] = {
@@ -252,31 +251,30 @@ static inline void da830_evm_init_mmc(void)
 
 	ret = davinci_cfg_reg_list(da830_evm_mmc_sd_pins);
 	if (ret) {
-		pr_warning("da830_evm_init: mmc/sd mux setup failed: %d\n",
-				ret);
+		pr_warn("da830_evm_init: mmc/sd mux setup failed: %d\n", ret);
 		return;
 	}
 
 	ret = gpio_request(DA830_MMCSD_WP_PIN, "MMC WP");
 	if (ret) {
-		pr_warning("da830_evm_init: can not open GPIO %d\n",
-			   DA830_MMCSD_WP_PIN);
+		pr_warn("da830_evm_init: can not open GPIO %d\n",
+			DA830_MMCSD_WP_PIN);
 		return;
 	}
 	gpio_direction_input(DA830_MMCSD_WP_PIN);
 
 	ret = gpio_request(DA830_MMCSD_CD_PIN, "MMC CD\n");
 	if (ret) {
-		pr_warning("da830_evm_init: can not open GPIO %d\n",
-			   DA830_MMCSD_CD_PIN);
+		pr_warn("da830_evm_init: can not open GPIO %d\n",
+			DA830_MMCSD_CD_PIN);
 		return;
 	}
 	gpio_direction_input(DA830_MMCSD_CD_PIN);
 
 	ret = da8xx_register_mmcsd0(&da830_evm_mmc_config);
 	if (ret) {
-		pr_warning("da830_evm_init: mmc/sd registration failed: %d\n",
-				ret);
+		pr_warn("da830_evm_init: mmc/sd registration failed: %d\n",
+			ret);
 		gpio_free(DA830_MMCSD_WP_PIN);
 	}
 }
@@ -404,20 +402,18 @@ static inline void da830_evm_init_nand(int mux_mode)
 	int ret;
 
 	if (HAS_MMC) {
-		pr_warning("WARNING: both MMC/SD and NAND are "
-				"enabled, but they share AEMIF pins.\n"
-				"\tDisable MMC/SD for NAND support.\n");
+		pr_warn("WARNING: both MMC/SD and NAND are enabled, but they share AEMIF pins.\n"
+			"\tDisable MMC/SD for NAND support.\n");
 		return;
 	}
 
 	ret = davinci_cfg_reg_list(da830_evm_emif25_pins);
 	if (ret)
-		pr_warning("da830_evm_init: emif25 mux setup failed: %d\n",
-				ret);
+		pr_warn("da830_evm_init: emif25 mux setup failed: %d\n", ret);
 
 	ret = platform_device_register(&da830_evm_nand_device);
 	if (ret)
-		pr_warning("da830_evm_init: NAND device not registered.\n");
+		pr_warn("da830_evm_init: NAND device not registered.\n");
 
 	if (davinci_aemif_setup(&da830_evm_nand_device))
 		pr_warn("%s: Cannot configure AEMIF.\n", __func__);
@@ -435,12 +431,11 @@ static inline void da830_evm_init_lcdc(int mux_mode)
 
 	ret = davinci_cfg_reg_list(da830_lcdcntl_pins);
 	if (ret)
-		pr_warning("da830_evm_init: lcdcntl mux setup failed: %d\n",
-				ret);
+		pr_warn("da830_evm_init: lcdcntl mux setup failed: %d\n", ret);
 
 	ret = da8xx_register_lcdc(&sharp_lcd035q3dg01_pdata);
 	if (ret)
-		pr_warning("da830_evm_init: lcd setup failed: %d\n", ret);
+		pr_warn("da830_evm_init: lcd setup failed: %d\n", ret);
 
 	gpio_direction_output(mux_mode, 0);
 }
@@ -602,18 +597,15 @@ static __init void da830_evm_init(void)
 
 	ret = da830_register_edma(da830_edma_rsv);
 	if (ret)
-		pr_warning("da830_evm_init: edma registration failed: %d\n",
-				ret);
+		pr_warn("da830_evm_init: edma registration failed: %d\n", ret);
 
 	ret = davinci_cfg_reg_list(da830_i2c0_pins);
 	if (ret)
-		pr_warning("da830_evm_init: i2c0 mux setup failed: %d\n",
-				ret);
+		pr_warn("da830_evm_init: i2c0 mux setup failed: %d\n", ret);
 
 	ret = da8xx_register_i2c(0, &da830_evm_i2c_0_pdata);
 	if (ret)
-		pr_warning("da830_evm_init: i2c0 registration failed: %d\n",
-				ret);
+		pr_warn("da830_evm_init: i2c0 registration failed: %d\n", ret);
 
 	da830_evm_usb_init();
 
@@ -622,18 +614,16 @@ static __init void da830_evm_init(void)
 
 	ret = davinci_cfg_reg_list(da830_cpgmac_pins);
 	if (ret)
-		pr_warning("da830_evm_init: cpgmac mux setup failed: %d\n",
-				ret);
+		pr_warn("da830_evm_init: cpgmac mux setup failed: %d\n", ret);
 
 	ret = da8xx_register_emac();
 	if (ret)
-		pr_warning("da830_evm_init: emac registration failed: %d\n",
-				ret);
+		pr_warn("da830_evm_init: emac registration failed: %d\n", ret);
 
 	ret = da8xx_register_watchdog();
 	if (ret)
-		pr_warning("da830_evm_init: watchdog registration failed: %d\n",
-				ret);
+		pr_warn("da830_evm_init: watchdog registration failed: %d\n",
+			ret);
 
 	davinci_serial_init(da8xx_serial_device);
 	i2c_register_board_info(1, da830_evm_i2c_devices,
@@ -641,8 +631,7 @@ static __init void da830_evm_init(void)
 
 	ret = davinci_cfg_reg_list(da830_evm_mcasp1_pins);
 	if (ret)
-		pr_warning("da830_evm_init: mcasp1 mux setup failed: %d\n",
-				ret);
+		pr_warn("da830_evm_init: mcasp1 mux setup failed: %d\n", ret);
 
 	da8xx_register_mcasp(1, &da830_evm_snd_data);
 
@@ -650,18 +639,17 @@ static __init void da830_evm_init(void)
 
 	ret = da8xx_register_rtc();
 	if (ret)
-		pr_warning("da830_evm_init: rtc setup failed: %d\n", ret);
+		pr_warn("da830_evm_init: rtc setup failed: %d\n", ret);
 
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
+		pr_warn("da830_evm_init: spi 0 registration failed: %d\n", ret);
 }
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index e583e58..139848b 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -767,8 +767,7 @@ static __init void davinci_evm_init(void)
 
 	if (HAS_ATA) {
 		if (HAS_NAND || HAS_NOR)
-			pr_warning("WARNING: both IDE and Flash are "
-				"enabled, but they share AEMIF pins.\n"
+			pr_warn("WARNING: both IDE and Flash are enabled, but they share AEMIF pins.\n"
 				"\tDisable IDE for NAND/NOR support.\n");
 		davinci_init_ide();
 	} else if (HAS_NAND || HAS_NOR) {
@@ -785,8 +784,7 @@ static __init void davinci_evm_init(void)
 
 			evm_leds[7].default_trigger = "nand-disk";
 			if (HAS_NOR)
-				pr_warning("WARNING: both NAND and NOR flash "
-					"are enabled; disable one of them.\n");
+				pr_warn("WARNING: both NAND and NOR flash are enabled; disable one of them.\n");
 		} else if (HAS_NOR)
 			platform_device_register(&davinci_evm_norflash_device);
 	}
diff --git a/arch/arm/mach-davinci/board-mityomapl138.c b/arch/arm/mach-davinci/board-mityomapl138.c
index 96fc00a..64fa927 100644
--- a/arch/arm/mach-davinci/board-mityomapl138.c
+++ b/arch/arm/mach-davinci/board-mityomapl138.c
@@ -107,7 +107,7 @@ static void mityomapl138_cpufreq_init(const char *partnum)
 
 	ret = da850_register_cpufreq("pll0_sysclk3");
 	if (ret)
-		pr_warning("cpufreq registration failed: %d\n", ret);
+		pr_warn("cpufreq registration failed: %d\n", ret);
 }
 #else
 static void mityomapl138_cpufreq_init(const char *partnum) { }
@@ -121,20 +121,19 @@ static void read_factory_config(struct memory_accessor *a, void *context)
 
 	ret = a->read(a, (char *)&factory_config, 0, sizeof(factory_config));
 	if (ret != sizeof(struct factory_config)) {
-		pr_warning("MityOMAPL138: Read Factory Config Failed: %d\n",
-				ret);
+		pr_warn("MityOMAPL138: Read Factory Config Failed: %d\n", ret);
 		goto bad_config;
 	}
 
 	if (factory_config.magic != FACTORY_CONFIG_MAGIC) {
-		pr_warning("MityOMAPL138: Factory Config Magic Wrong (%X)\n",
-				factory_config.magic);
+		pr_warn("MityOMAPL138: Factory Config Magic Wrong (%X)\n",
+			factory_config.magic);
 		goto bad_config;
 	}
 
 	if (factory_config.version != FACTORY_CONFIG_VERSION) {
-		pr_warning("MityOMAPL138: Factory Config Version Wrong (%X)\n",
-				factory_config.version);
+		pr_warn("MityOMAPL138: Factory Config Version Wrong (%X)\n",
+			factory_config.version);
 		goto bad_config;
 	}
 
@@ -143,8 +142,7 @@ static void read_factory_config(struct memory_accessor *a, void *context)
 		memcpy(soc_info->emac_pdata->mac_addr,
 			factory_config.mac, ETH_ALEN);
 	else
-		pr_warning("MityOMAPL138: Invalid MAC found "
-				"in factory config block\n");
+		pr_warn("MityOMAPL138: Invalid MAC found in factory config block\n");
 
 	partnum = factory_config.partnum;
 	pr_info("MityOMAPL138: Part Number = %s\n", partnum);
@@ -478,7 +476,7 @@ static void __init mityomapl138_config_emac(void)
 	}
 
 	if (ret) {
-		pr_warning("mii/rmii mux setup failed: %d\n", ret);
+		pr_warn("mii/rmii mux setup failed: %d\n", ret);
 		return;
 	}
 
@@ -489,7 +487,7 @@ static void __init mityomapl138_config_emac(void)
 
 	ret = da8xx_register_emac();
 	if (ret)
-		pr_warning("emac registration failed: %d\n", ret);
+		pr_warn("emac registration failed: %d\n", ret);
 }
 
 static struct davinci_pm_config da850_pm_pdata = {
@@ -511,21 +509,21 @@ static void __init mityomapl138_init(void)
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
 
@@ -537,22 +535,22 @@ static void __init mityomapl138_init(void)
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
+		pr_warn("da850_evm_init: suspend registration failed: %d\n",
+			ret);
 }
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index bb680af..6a51c79 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -183,8 +183,7 @@ static __init void davinci_ntosd2_init(void)
 
 	if (HAS_ATA) {
 		if (HAS_NAND)
-			pr_warning("WARNING: both IDE and Flash are "
-				"enabled, but they share AEMIF pins.\n"
+			pr_warn("WARNING: both IDE and Flash are enabled, but they share AEMIF pins.\n"
 				"\tDisable IDE for NAND/NOR support.\n");
 		davinci_init_ide();
 	} else if (HAS_NAND) {
diff --git a/arch/arm/mach-davinci/time.c b/arch/arm/mach-davinci/time.c
index 24ad30f..709ff8f 100644
--- a/arch/arm/mach-davinci/time.c
+++ b/arch/arm/mach-davinci/time.c
@@ -364,12 +364,10 @@ void __init davinci_timer_init(void)
 
 		/* Only bottom timers can use compare regs */
 		if (IS_TIMER_TOP(clockevent_id))
-			pr_warning("davinci_timer_init: Invalid use"
-				" of system timers.  Results unpredictable.\n");
+			pr_warn("davinci_timer_init: Invalid use of system timers.  Results unpredictable.\n");
 		else if ((dtip[event_timer].cmp_off == 0)
 				|| (dtip[event_timer].cmp_irq == 0))
-			pr_warning("davinci_timer_init:  Invalid timer instance"
-				" setup.  Results unpredictable.\n");
+			pr_warn("davinci_timer_init:  Invalid timer instance setup.  Results unpredictable.\n");
 		else {
 			timers[TID_CLOCKEVENT].opts |= TIMER_OPTS_USE_COMPARE;
 			clockevent_davinci.features = CLOCK_EVT_FEAT_ONESHOT;
-- 
1.8.1.2.459.gbcd45b4.dirty

