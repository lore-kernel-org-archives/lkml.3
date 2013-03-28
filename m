Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab3C1QWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:22:03 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:35721 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab3C1QV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:21:59 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 2/2] ARM: ux500: 8500: add ab8500-musb pinctrl support
Date: Thu, 28 Mar 2013 17:21:09 +0100
Message-Id: <1364487669-24368-3-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364487669-24368-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364487669-24368-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@stericsson.com>

Add necessary definitions to support ab8500-musb pinctrl default and
sleep states.

Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-pins.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index 625880f..ca0649e 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -48,8 +48,12 @@ BIAS(slpm_in_nopull_wkup, PIN_SLEEPMODE_ENABLED|
 	PIN_SLPM_DIR_INPUT|PIN_SLPM_PULL_NONE|PIN_SLPM_WAKEUP_ENABLE);
 BIAS(slpm_in_wkup_pdis, PIN_SLEEPMODE_ENABLED|
 	PIN_SLPM_DIR_INPUT|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
+BIAS(slpm_in_wkup_pdis_en, PIN_SLEEPMODE_ENABLED|
+	PIN_SLPM_DIR_INPUT|PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_ENABLED);
 BIAS(slpm_wkup_pdis, PIN_SLEEPMODE_ENABLED|
 	PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_DISABLED);
+BIAS(slpm_wkup_pdis_en, PIN_SLEEPMODE_ENABLED|
+	PIN_SLPM_WAKEUP_ENABLE|PIN_SLPM_PDIS_ENABLED);
 BIAS(slpm_out_lo_pdis, PIN_SLEEPMODE_ENABLED|
 	PIN_SLPM_OUTPUT_LOW|PIN_SLPM_WAKEUP_DISABLE|PIN_SLPM_PDIS_DISABLED);
 BIAS(slpm_out_lo_wkup, PIN_SLEEPMODE_ENABLED|
@@ -306,8 +310,23 @@ static struct pinctrl_map __initdata mop500_family_pinmap[] = {
 	DB8500_PIN_SLEEP("GPIO207_AJ23", slpm_in_wkup_pdis, "sdi4"), /* DAT4 */
 
 	/* Mux in USB pins, drive STP high */
-	DB8500_MUX("usb_a_1", "usb", "musb-ux500.0"),
-	DB8500_PIN("GPIO257_AE29", out_hi, "musb-ux500.0"), /* STP */
+	/* USB default state */
+	DB8500_MUX("usb_a_1", "usb", "ab8500-usb.0"),
+	DB8500_PIN("GPIO257_AE29", out_hi, "musbux500.0"), /* STP */
+	/* USB sleep state */
+	DB8500_PIN_SLEEP("GPIO256_AF28", slpm_wkup_pdis_en, "ab8500-usb.0"), /* NXT */
+	DB8500_PIN_SLEEP("GPIO257_AE29", slpm_out_hi_wkup_pdis, "ab8500-usb.0"), /* STP */
+	DB8500_PIN_SLEEP("GPIO258_AD29", slpm_wkup_pdis_en, "ab8500-usb.0"), /* XCLK */
+	DB8500_PIN_SLEEP("GPIO259_AC29", slpm_wkup_pdis_en, "ab8500-usb.0"), /* DIR */
+	DB8500_PIN_SLEEP("GPIO260_AD28", slpm_in_wkup_pdis_en, "ab8500-usb.0"), /* DAT7 */
+	DB8500_PIN_SLEEP("GPIO261_AD26", slpm_in_wkup_pdis_en, "ab8500-usb.0"), /* DAT6 */
+	DB8500_PIN_SLEEP("GPIO262_AE26", slpm_in_wkup_pdis_en, "ab8500-usb.0"), /* DAT5 */
+	DB8500_PIN_SLEEP("GPIO263_AG29", slpm_in_wkup_pdis_en, "ab8500-usb.0"), /* DAT4 */
+	DB8500_PIN_SLEEP("GPIO264_AE27", slpm_in_wkup_pdis_en, "ab8500-usb.0"), /* DAT3 */
+	DB8500_PIN_SLEEP("GPIO265_AD27", slpm_in_wkup_pdis_en, "ab8500-usb.0"), /* DAT2 */
+	DB8500_PIN_SLEEP("GPIO266_AC28", slpm_in_wkup_pdis_en, "ab8500-usb.0"), /* DAT1 */
+	DB8500_PIN_SLEEP("GPIO267_AC27", slpm_in_wkup_pdis_en, "ab8500-usb.0"), /* DAT0 */
+
 	/* Mux in SPI2 pins on the "other C1" altfunction */
 	DB8500_MUX("spi2_oc1_2", "spi2", "spi2"),
 	DB8500_PIN("GPIO216_AG12", gpio_out_hi, "spi2"), /* FRM */
-- 
1.8.1.3

