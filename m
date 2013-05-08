Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab3EHJKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 05:10:10 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:64911 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3EHJKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 05:10:07 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Mark Brown <broonie@kernel.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] ARM: ux500: update MSP1 pinctrl defintions
Date: Wed,  8 May 2013 11:09:53 +0200
Message-Id: <1368004193-21213-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update MSP1 pinctrl definitions in mop500_family_pinmap by removing
sleep state and setting default ones as pin hogs, as those are used by
both ux500-msp-i2s.1 and ux500-msp-i2s.3.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-pins.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index 947bd9e..3f92308 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -174,17 +174,12 @@ static struct pinctrl_map __initdata mop500_family_pinmap[] = {
 	DB8500_PIN_SLEEP("GPIO4_AH6", slpm_in_wkup_pdis, "uart1"),
 	DB8500_PIN_SLEEP("GPIO5_AG6", slpm_out_wkup_pdis, "uart1"),
 	/* MSP1 for ALSA codec */
-	DB8500_MUX("msp1txrx_a_1", "msp1", "ux500-msp-i2s.1"),
-	DB8500_MUX("msp1_a_1", "msp1", "ux500-msp-i2s.1"),
-	DB8500_PIN("GPIO33_AF2", out_lo_slpm_nowkup, "ux500-msp-i2s.1"),
-	DB8500_PIN("GPIO34_AE1", in_nopull_slpm_nowkup, "ux500-msp-i2s.1"),
-	DB8500_PIN("GPIO35_AE2", in_nopull_slpm_nowkup, "ux500-msp-i2s.1"),
-	DB8500_PIN("GPIO36_AG2", in_nopull_slpm_nowkup, "ux500-msp-i2s.1"),
-	/* MSP1 sleep state */
-	DB8500_PIN_SLEEP("GPIO33_AF2", slpm_out_lo_wkup, "ux500-msp-i2s.1"),
-	DB8500_PIN_SLEEP("GPIO34_AE1", slpm_in_nopull_wkup, "ux500-msp-i2s.1"),
-	DB8500_PIN_SLEEP("GPIO35_AE2", slpm_in_nopull_wkup, "ux500-msp-i2s.1"),
-	DB8500_PIN_SLEEP("GPIO36_AG2", slpm_in_nopull_wkup, "ux500-msp-i2s.1"),
+	DB8500_MUX_HOG("msp1txrx_a_1", "msp1"),
+	DB8500_MUX_HOG("msp1_a_1", "msp1"),
+	DB8500_PIN_HOG("GPIO33_AF2", out_lo_slpm_nowkup),
+	DB8500_PIN_HOG("GPIO34_AE1", in_nopull_slpm_nowkup),
+	DB8500_PIN_HOG("GPIO35_AE2", in_nopull_slpm_nowkup),
+	DB8500_PIN_HOG("GPIO36_AG2", in_nopull_slpm_nowkup),
 	/* Mux in LCD data lines 8 thru 11 and LCDA CLK for MCDE TVOUT */
 	DB8500_MUX("lcd_d8_d11_a_1", "lcd", "mcde-tvout"),
 	DB8500_MUX("lcdaclk_b_1", "lcda", "mcde-tvout"),
-- 
1.8.2

