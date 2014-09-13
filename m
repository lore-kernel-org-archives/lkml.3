Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaIMScK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 14:32:10 -0400
Received: from smtprelay0011.hostedemail.com ([216.40.44.11]:53405 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752306AbaIMScD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 14:32:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:2:41:69:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1461:1535:1605:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2895:2901:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:4051:4120:4250:4321:4385:4605:5007:6117:6119:6261:8957:9040:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:12688:12737:13972:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sleep56_11726de00a25d
X-Filterd-Recvd-Size: 9418
From: Joe Perches <joe@perches.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] arm: mach-pxa: Convert pr_warning to pr_warn
Date: Sat, 13 Sep 2014 11:31:18 -0700
Message-Id: <70f104441791b08aadef9d7b72018161e9e773b0.1410632835.git.joe@perches.com>
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
 arch/arm/mach-pxa/em-x270.c     |  4 ++--
 arch/arm/mach-pxa/gumstix.c     |  3 +--
 arch/arm/mach-pxa/mfp-pxa2xx.c  | 12 +++++-------
 arch/arm/mach-pxa/poodle.c      |  2 +-
 arch/arm/mach-pxa/pxa3xx-ulpi.c |  6 +++---
 arch/arm/mach-pxa/raumfeld.c    | 26 +++++++++++++-------------
 6 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index 6915a9f..51531ec 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -378,7 +378,7 @@ static void __init em_x270_init_nand(void)
 
 	err = gpio_request(GPIO11_NAND_CS, "NAND CS");
 	if (err) {
-		pr_warning("EM-X270: failed to request NAND CS gpio\n");
+		pr_warn("EM-X270: failed to request NAND CS gpio\n");
 		return;
 	}
 
@@ -386,7 +386,7 @@ static void __init em_x270_init_nand(void)
 
 	err = gpio_request(nand_rb, "NAND R/B");
 	if (err) {
-		pr_warning("EM-X270: failed to request NAND R/B gpio\n");
+		pr_warn("EM-X270: failed to request NAND R/B gpio\n");
 		gpio_free(GPIO11_NAND_CS);
 		return;
 	}
diff --git a/arch/arm/mach-pxa/gumstix.c b/arch/arm/mach-pxa/gumstix.c
index 00b92da..f6c76a3 100644
--- a/arch/arm/mach-pxa/gumstix.c
+++ b/arch/arm/mach-pxa/gumstix.c
@@ -140,8 +140,7 @@ static void gumstix_setup_bt_clock(void)
 	int timeout = 500;
 
 	if (!(OSCC & OSCC_OOK))
-		pr_warning("32kHz clock was not on. Bootloader may need to "
-				"be updated\n");
+		pr_warn("32kHz clock was not on. Bootloader may need to be updated\n");
 	else
 		return;
 
diff --git a/arch/arm/mach-pxa/mfp-pxa2xx.c b/arch/arm/mach-pxa/mfp-pxa2xx.c
index ef0426a..666b789 100644
--- a/arch/arm/mach-pxa/mfp-pxa2xx.c
+++ b/arch/arm/mach-pxa/mfp-pxa2xx.c
@@ -93,8 +93,8 @@ static int __mfp_config_gpio(unsigned gpio, unsigned long c)
 		break;
 	default:
 		/* warning and fall through, treat as MFP_LPM_DEFAULT */
-		pr_warning("%s: GPIO%d: unsupported low power mode\n",
-				__func__, gpio);
+		pr_warn("%s: GPIO%d: unsupported low power mode\n",
+			__func__, gpio);
 		break;
 	}
 
@@ -107,14 +107,12 @@ static int __mfp_config_gpio(unsigned gpio, unsigned long c)
 	 * configurations of those pins not able to wakeup
 	 */
 	if ((c & MFP_LPM_CAN_WAKEUP) && !gpio_desc[gpio].can_wakeup) {
-		pr_warning("%s: GPIO%d unable to wakeup\n",
-				__func__, gpio);
+		pr_warn("%s: GPIO%d unable to wakeup\n", __func__, gpio);
 		return -EINVAL;
 	}
 
 	if ((c & MFP_LPM_CAN_WAKEUP) && is_out) {
-		pr_warning("%s: output GPIO%d unable to wakeup\n",
-				__func__, gpio);
+		pr_warn("%s: output GPIO%d unable to wakeup\n", __func__, gpio);
 		return -EINVAL;
 	}
 
@@ -126,7 +124,7 @@ static inline int __mfp_validate(int mfp)
 	int gpio = mfp_to_gpio(mfp);
 
 	if ((mfp > MFP_PIN_GPIO127) || !gpio_desc[gpio].valid) {
-		pr_warning("%s: GPIO%d is invalid pin\n", __func__, gpio);
+		pr_warn("%s: GPIO%d is invalid pin\n", __func__, gpio);
 		return -1;
 	}
 
diff --git a/arch/arm/mach-pxa/poodle.c b/arch/arm/mach-pxa/poodle.c
index 1319916..29019be 100644
--- a/arch/arm/mach-pxa/poodle.c
+++ b/arch/arm/mach-pxa/poodle.c
@@ -446,7 +446,7 @@ static void __init poodle_init(void)
 
 	ret = platform_add_devices(devices, ARRAY_SIZE(devices));
 	if (ret)
-		pr_warning("poodle: Unable to register LoCoMo device\n");
+		pr_warn("poodle: Unable to register LoCoMo device\n");
 
 	pxa_set_fb_info(&poodle_locomo_device.dev, &poodle_fb_info);
 	pxa_set_udc_info(&udc_info);
diff --git a/arch/arm/mach-pxa/pxa3xx-ulpi.c b/arch/arm/mach-pxa/pxa3xx-ulpi.c
index e329cce..614003e 100644
--- a/arch/arm/mach-pxa/pxa3xx-ulpi.c
+++ b/arch/arm/mach-pxa/pxa3xx-ulpi.c
@@ -74,7 +74,7 @@ static int pxa310_ulpi_poll(void)
 		cpu_relax();
 	}
 
-	pr_warning("%s: ULPI access timed out!\n", __func__);
+	pr_warn("%s: ULPI access timed out!\n", __func__);
 
 	return -ETIMEDOUT;
 }
@@ -84,7 +84,7 @@ static int pxa310_ulpi_read(struct usb_phy *otg, u32 reg)
 	int err;
 
 	if (pxa310_ulpi_get_phymode() != SYNCH) {
-		pr_warning("%s: PHY is not in SYNCH mode!\n", __func__);
+		pr_warn("%s: PHY is not in SYNCH mode!\n", __func__);
 		return -EBUSY;
 	}
 
@@ -101,7 +101,7 @@ static int pxa310_ulpi_read(struct usb_phy *otg, u32 reg)
 static int pxa310_ulpi_write(struct usb_phy *otg, u32 val, u32 reg)
 {
 	if (pxa310_ulpi_get_phymode() != SYNCH) {
-		pr_warning("%s: PHY is not in SYNCH mode!\n", __func__);
+		pr_warn("%s: PHY is not in SYNCH mode!\n", __func__);
 		return -EBUSY;
 	}
 
diff --git a/arch/arm/mach-pxa/raumfeld.c b/arch/arm/mach-pxa/raumfeld.c
index 8386dc3..a762b23 100644
--- a/arch/arm/mach-pxa/raumfeld.c
+++ b/arch/arm/mach-pxa/raumfeld.c
@@ -521,7 +521,7 @@ static void __init raumfeld_w1_init(void)
 				"W1 external pullup enable");
 
 	if (ret < 0)
-		pr_warning("Unable to request GPIO_W1_PULLUP_ENABLE\n");
+		pr_warn("Unable to request GPIO_W1_PULLUP_ENABLE\n");
 	else
 		gpio_direction_output(GPIO_W1_PULLUP_ENABLE, 0);
 
@@ -600,7 +600,7 @@ static void __init raumfeld_lcd_init(void)
 
 	ret = gpio_request(GPIO_TFT_VA_EN, "display VA enable");
 	if (ret < 0)
-		pr_warning("Unable to request GPIO_TFT_VA_EN\n");
+		pr_warn("Unable to request GPIO_TFT_VA_EN\n");
 	else
 		gpio_direction_output(GPIO_TFT_VA_EN, 1);
 
@@ -608,7 +608,7 @@ static void __init raumfeld_lcd_init(void)
 
 	ret = gpio_request(GPIO_DISPLAY_ENABLE, "display enable");
 	if (ret < 0)
-		pr_warning("Unable to request GPIO_DISPLAY_ENABLE\n");
+		pr_warn("Unable to request GPIO_DISPLAY_ENABLE\n");
 	else
 		gpio_direction_output(GPIO_DISPLAY_ENABLE, 1);
 
@@ -814,17 +814,17 @@ static void __init raumfeld_power_init(void)
 	/* Set PEN2 high to enable maximum charge current */
 	ret = gpio_request(GPIO_CHRG_PEN2, "CHRG_PEN2");
 	if (ret < 0)
-		pr_warning("Unable to request GPIO_CHRG_PEN2\n");
+		pr_warn("Unable to request GPIO_CHRG_PEN2\n");
 	else
 		gpio_direction_output(GPIO_CHRG_PEN2, 1);
 
 	ret = gpio_request(GPIO_CHARGE_DC_OK, "CABLE_DC_OK");
 	if (ret < 0)
-		pr_warning("Unable to request GPIO_CHARGE_DC_OK\n");
+		pr_warn("Unable to request GPIO_CHARGE_DC_OK\n");
 
 	ret = gpio_request(GPIO_CHARGE_USB_SUSP, "CHARGE_USB_SUSP");
 	if (ret < 0)
-		pr_warning("Unable to request GPIO_CHARGE_USB_SUSP\n");
+		pr_warn("Unable to request GPIO_CHARGE_USB_SUSP\n");
 	else
 		gpio_direction_output(GPIO_CHARGE_USB_SUSP, 0);
 
@@ -976,19 +976,19 @@ static void __init raumfeld_audio_init(void)
 
 	ret = gpio_request(GPIO_CODEC_RESET, "cs4270 reset");
 	if (ret < 0)
-		pr_warning("unable to request GPIO_CODEC_RESET\n");
+		pr_warn("unable to request GPIO_CODEC_RESET\n");
 	else
 		gpio_direction_output(GPIO_CODEC_RESET, 1);
 
 	ret = gpio_request(GPIO_SPDIF_RESET, "ak4104 s/pdif reset");
 	if (ret < 0)
-		pr_warning("unable to request GPIO_SPDIF_RESET\n");
+		pr_warn("unable to request GPIO_SPDIF_RESET\n");
 	else
 		gpio_direction_output(GPIO_SPDIF_RESET, 1);
 
 	ret = gpio_request(GPIO_MCLK_RESET, "MCLK reset");
 	if (ret < 0)
-		pr_warning("unable to request GPIO_MCLK_RESET\n");
+		pr_warn("unable to request GPIO_MCLK_RESET\n");
 	else
 		gpio_direction_output(GPIO_MCLK_RESET, 1);
 
@@ -1019,20 +1019,20 @@ static void __init raumfeld_common_init(void)
 
 	ret = gpio_request(GPIO_W2W_RESET, "Wi2Wi reset");
 	if (ret < 0)
-		pr_warning("Unable to request GPIO_W2W_RESET\n");
+		pr_warn("Unable to request GPIO_W2W_RESET\n");
 	else
 		gpio_direction_output(GPIO_W2W_RESET, 0);
 
 	ret = gpio_request(GPIO_W2W_PDN, "Wi2Wi powerup");
 	if (ret < 0)
-		pr_warning("Unable to request GPIO_W2W_PDN\n");
+		pr_warn("Unable to request GPIO_W2W_PDN\n");
 	else
 		gpio_direction_output(GPIO_W2W_PDN, 0);
 
 	/* this can be used to switch off the device */
 	ret = gpio_request(GPIO_SHUTDOWN_SUPPLY, "supply shutdown");
 	if (ret < 0)
-		pr_warning("Unable to request GPIO_SHUTDOWN_SUPPLY\n");
+		pr_warn("Unable to request GPIO_SHUTDOWN_SUPPLY\n");
 	else
 		gpio_direction_output(GPIO_SHUTDOWN_SUPPLY, 0);
 
@@ -1051,7 +1051,7 @@ static void __init raumfeld_controller_init(void)
 
 	ret = gpio_request(GPIO_SHUTDOWN_BATT, "battery shutdown");
 	if (ret < 0)
-		pr_warning("Unable to request GPIO_SHUTDOWN_BATT\n");
+		pr_warn("Unable to request GPIO_SHUTDOWN_BATT\n");
 	else
 		gpio_direction_output(GPIO_SHUTDOWN_BATT, 0);
 
-- 
1.8.1.2.459.gbcd45b4.dirty

