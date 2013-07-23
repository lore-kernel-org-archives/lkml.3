Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934463Ab3GWUW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:22:58 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:51378 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934277Ab3GWUWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:22:00 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jul 2013 16:21:59 EDT
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: [RFC] ARM: davinci: da850: add a few pinmux definitions
Date: Tue, 23 Jul 2013 16:13:02 -0400
Message-Id: <1374610382-11204-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some pinmux definitions that we needed, such as SPI0,
SPI1 and some GPIO.

Note: I sent the patch as an RFC because I would like a confirmation for the
appropriate name for SPI*_SCS* and EMA_A_RW pinmuxes.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 arch/arm/mach-davinci/da850.c            | 77 ++++++++++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/mux.h | 80 ++++++++++++++++++++++++++++++++
 2 files changed, 157 insertions(+)

diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index a0d4f60..adefc17 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -504,6 +504,30 @@ static const struct mux_config da850_pins[] = {
 	/* I2C0 function */
 	MUX_CFG(DA850, I2C0_SDA,	4,	12,	15,	2,	false)
 	MUX_CFG(DA850, I2C0_SCL,	4,	8,	15,	2,	false)
+	/* SPI0 function */
+	MUX_CFG(DA850, SPI0_CLK,	3,	0,	15,	1,	false)
+	MUX_CFG(DA850, SPI0_ENA,	3,	4,	15,	1,	false)
+	MUX_CFG(DA850, SPI0_SOMI,	3,	8,	15,	1,	false)
+	MUX_CFG(DA850, SPI0_SIMO,	3,	12,	15,	1,	false)
+	MUX_CFG(DA850, SPI0_SCS0,	4,	4,	15,	1,	false)
+	MUX_CFG(DA850, SPI0_SCS1,	4,	0,	15,	1,	false)
+	MUX_CFG(DA850, SPI0_SCS2,	3,	28,	15,	1,	false)
+	MUX_CFG(DA850, SPI0_SCS3,	3,	24,	15,	1,	false)
+	MUX_CFG(DA850, SPI0_SCS4,	3,	20,	15,	1,	false)
+	MUX_CFG(DA850, SPI0_SCS5,	3,	16,	15,	1,	false)
+	/* SPI1 function */
+	MUX_CFG(DA850, SPI1_CLK,	5,	8,	15,	1,	false)
+	MUX_CFG(DA850, SPI1_ENA,	5,	12,	15,	1,	false)
+	MUX_CFG(DA850, SPI1_SOMI,	5,	16,	15,	1,	false)
+	MUX_CFG(DA850, SPI1_SIMO,	5,	20,	15,	1,	false)
+	MUX_CFG(DA850, SPI1_SCS0,	5,	4,	15,	1,	false)
+	MUX_CFG(DA850, SPI1_SCS1,	5,	0,	15,	1,	false)
+	MUX_CFG(DA850, SPI1_SCS2,	4,	28,	15,	1,	false)
+	MUX_CFG(DA850, SPI1_SCS3,	4,	24,	15,	1,	false)
+	MUX_CFG(DA850, SPI1_SCS4,	4,	20,	15,	1,	false)
+	MUX_CFG(DA850, SPI1_SCS5,	4,	16,	15,	1,	false)
+	MUX_CFG(DA850, SPI1_SCS6,	4,	12,	15,	1,	false)
+	MUX_CFG(DA850, SPI1_SCS7,	4,	8,	15,	1,	false)
 	/* EMAC function */
 	MUX_CFG(DA850, MII_TXEN,	2,	4,	15,	8,	false)
 	MUX_CFG(DA850, MII_TXCLK,	2,	8,	15,	8,	false)
@@ -604,6 +628,7 @@ static const struct mux_config da850_pins[] = {
 	MUX_CFG(DA850, NEMA_CS_4,	7,	8,	15,	1,	false)
 	MUX_CFG(DA850, NEMA_WE,		7,	16,	15,	1,	false)
 	MUX_CFG(DA850, NEMA_OE,		7,	20,	15,	1,	false)
+	MUX_CFG(DA850, EMA_A_RW,	7,	24,	15,	1,	false)
 	MUX_CFG(DA850, EMA_A_0,		12,	28,	15,	1,	false)
 	MUX_CFG(DA850, EMA_A_3,		12,	16,	15,	1,	false)
 	MUX_CFG(DA850, EMA_A_4,		12,	12,	15,	1,	false)
@@ -639,17 +664,69 @@ static const struct mux_config da850_pins[] = {
 	MUX_CFG(DA850, EMA_WAIT_1,	6,	24,	15,	1,	false)
 	MUX_CFG(DA850, NEMA_CS_2,	7,	0,	15,	1,	false)
 	/* GPIO function */
+	MUX_CFG(DA850, GPIO0_1,		1,	24,	15,	8,	false)
+	MUX_CFG(DA850, GPIO0_2,		1,	20,	15,	8,	false)
+	MUX_CFG(DA850, GPIO0_3,		1,	16,	15,	8,	false)
+	MUX_CFG(DA850, GPIO0_4,		1,	12,	15,	8,	false)
+	MUX_CFG(DA850, GPIO0_5,		1,	8,	15,	8,	false)
+	MUX_CFG(DA850, GPIO0_6,		1,	4,	15,	8,	false)
+	MUX_CFG(DA850, GPIO0_13,	0,	8,	15,	8,	false)
+	MUX_CFG(DA850, GPIO0_15,	0,	0,	15,	8,	false)
+	MUX_CFG(DA850, GPIO1_8,		3,	0,	15,	4,	false)
+	MUX_CFG(DA850, GPIO1_12,	2,	12,	15,	4,	false)
+	MUX_CFG(DA850, GPIO1_14,	2,	4,	15,	4,	false)
+	MUX_CFG(DA850, GPIO2_3,		6,	16,	15,	8,	false)
 	MUX_CFG(DA850, GPIO2_4,		6,	12,	15,	8,	false)
 	MUX_CFG(DA850, GPIO2_6,		6,	4,	15,	8,	false)
+	MUX_CFG(DA850, GPIO2_7,		6,	0,	15,	8,	false)
 	MUX_CFG(DA850, GPIO2_8,		5,	28,	15,	8,	false)
+	MUX_CFG(DA850, GPIO2_9,		5,	24,	15,	8,	false)
 	MUX_CFG(DA850, GPIO2_15,	5,	0,	15,	8,	false)
+	MUX_CFG(DA850, GPIO3_0,		8,	28,	15,	8,	false)
+	MUX_CFG(DA850, GPIO3_1,		8,	24,	15,	8,	false)
+	MUX_CFG(DA850, GPIO3_2,		8,	20,	15,	8,	false)
+	MUX_CFG(DA850, GPIO3_3,		8,	16,	15,	8,	false)
+	MUX_CFG(DA850, GPIO3_4,		8,	12,	15,	8,	false)
+	MUX_CFG(DA850, GPIO3_5,		8,	8,	15,	8,	false)
+	MUX_CFG(DA850, GPIO3_6,		8,	4,	15,	8,	false)
+	MUX_CFG(DA850, GPIO3_7,		8,	0,	15,	8,	false)
+	MUX_CFG(DA850, GPIO3_8,		7,	28,	15,	8,	false)
 	MUX_CFG(DA850, GPIO3_12,	7,	12,	15,	8,	false)
 	MUX_CFG(DA850, GPIO3_13,	7,	8,	15,	8,	false)
 	MUX_CFG(DA850, GPIO4_0,		10,	28,	15,	8,	false)
 	MUX_CFG(DA850, GPIO4_1,		10,	24,	15,	8,	false)
+	MUX_CFG(DA850, GPIO4_2,		10,	20,	15,	8,	false)
+	MUX_CFG(DA850, GPIO4_3,		10,	16,	15,	8,	false)
+	MUX_CFG(DA850, GPIO4_4,		10,	12,	15,	8,	false)
+	MUX_CFG(DA850, GPIO4_5,		10,	8,	15,	8,	false)
+	MUX_CFG(DA850, GPIO4_6,		10,	4,	15,	8,	false)
+	MUX_CFG(DA850, GPIO4_7,		10,	0,	15,	8,	false)
+	MUX_CFG(DA850, GPIO4_8,		9,	28,	15,	8,	false)
+	MUX_CFG(DA850, GPIO4_9,		9,	24,	15,	8,	false)
+	MUX_CFG(DA850, GPIO4_10,	9,	20,	15,	8,	false)
+	MUX_CFG(DA850, GPIO4_11,	9,	16,	15,	8,	false)
+	MUX_CFG(DA850, GPIO4_12,	9,	12,	15,	8,	false)
+	MUX_CFG(DA850, GPIO4_13,	9,	8,	15,	8,	false)
+	MUX_CFG(DA850, GPIO4_14,	9,	4,	15,	8,	false)
+	MUX_CFG(DA850, GPIO4_15,	9,	0,	15,	8,	false)
+	MUX_CFG(DA850, GPIO5_0,		12,	28,	15,	8,	false)
+	MUX_CFG(DA850, GPIO5_2,		12,	20,	15,	8,	false)
+	MUX_CFG(DA850, GPIO5_3,		12,	16,	15,	8,	false)
+	MUX_CFG(DA850, GPIO5_4,		12,	12,	15,	8,	false)
+	MUX_CFG(DA850, GPIO5_5,		12,	8,	15,	8,	false)
+	MUX_CFG(DA850, GPIO5_6,		12,	4,	15,	8,	false)
+	MUX_CFG(DA850, GPIO6_0,		19,	24,	15,	8,	false)
+	MUX_CFG(DA850, GPIO6_1,		19,	20,	15,	8,	false)
 	MUX_CFG(DA850, GPIO6_9,		13,	24,	15,	8,	false)
 	MUX_CFG(DA850, GPIO6_10,	13,	20,	15,	8,	false)
+	MUX_CFG(DA850, GPIO6_11,	13,	16,	15,	8,	false)
 	MUX_CFG(DA850, GPIO6_13,	13,	8,	15,	8,	false)
+	MUX_CFG(DA850, GPIO6_15,	13,	 0,	15,	8,	false)
+	MUX_CFG(DA850, GPIO8_5,		3,	12,	15,	4,	false)
+	MUX_CFG(DA850, GPIO8_6,		3,	 8,	15,	4,	false)
+	MUX_CFG(DA850, GPIO8_11,	18,	24,	15,	8,	false)
+	MUX_CFG(DA850, GPIO8_12,	18,	20,	15,	8,	false)
+	MUX_CFG(DA850, GPIO8_13,	18,	16,	15,	8,	false)
 	MUX_CFG(DA850, RTC_ALARM,	0,	28,	15,	2,	false)
 	/* VPIF Capture */
 	MUX_CFG(DA850, VPIF_DIN0,	15,	4,	15,	1,	false)
diff --git a/arch/arm/mach-davinci/include/mach/mux.h b/arch/arm/mach-davinci/include/mach/mux.h
index 9e95b8a..af5b34d 100644
--- a/arch/arm/mach-davinci/include/mach/mux.h
+++ b/arch/arm/mach-davinci/include/mach/mux.h
@@ -775,6 +775,32 @@ enum davinci_da850_index {
 	DA850_I2C0_SDA,
 	DA850_I2C0_SCL,
 
+	/* SPI0 function */
+	DA850_SPI0_CLK,
+	DA850_SPI0_ENA,
+	DA850_SPI0_SOMI,
+	DA850_SPI0_SIMO,
+	DA850_SPI0_SCS0,
+	DA850_SPI0_SCS1,
+	DA850_SPI0_SCS2,
+	DA850_SPI0_SCS3,
+	DA850_SPI0_SCS4,
+	DA850_SPI0_SCS5,
+
+	/* SPI1 function */
+	DA850_SPI1_CLK,
+	DA850_SPI1_ENA,
+	DA850_SPI1_SOMI,
+	DA850_SPI1_SIMO,
+	DA850_SPI1_SCS0,
+	DA850_SPI1_SCS1,
+	DA850_SPI1_SCS2,
+	DA850_SPI1_SCS3,
+	DA850_SPI1_SCS4,
+	DA850_SPI1_SCS5,
+	DA850_SPI1_SCS6,
+	DA850_SPI1_SCS7,
+
 	/* EMAC function */
 	DA850_MII_TXEN,
 	DA850_MII_TXCLK,
@@ -880,6 +906,7 @@ enum davinci_da850_index {
 	DA850_NEMA_CS_4,
 	DA850_NEMA_WE,
 	DA850_NEMA_OE,
+	DA850_EMA_A_RW,
 	DA850_EMA_D_15,
 	DA850_EMA_D_14,
 	DA850_EMA_D_13,
@@ -916,17 +943,70 @@ enum davinci_da850_index {
 	DA850_NEMA_CS_2,
 
 	/* GPIO function */
+	DA850_GPIO0_1,
+	DA850_GPIO0_2,
+	DA850_GPIO0_3,
+	DA850_GPIO0_4,
+	DA850_GPIO0_5,
+	DA850_GPIO0_6,
+	DA850_GPIO0_13,
+	DA850_GPIO0_15,
+	DA850_GPIO1_8,
+	DA850_GPIO1_12,
+	DA850_GPIO1_14,
+	DA850_GPIO2_3,
 	DA850_GPIO2_4,
 	DA850_GPIO2_6,
+	DA850_GPIO2_7,
 	DA850_GPIO2_8,
+	DA850_GPIO2_9,
 	DA850_GPIO2_15,
+	DA850_GPIO3_0,
+	DA850_GPIO3_1,
+	DA850_GPIO3_2,
+	DA850_GPIO3_3,
+	DA850_GPIO3_4,
+	DA850_GPIO3_5,
+	DA850_GPIO3_6,
+	DA850_GPIO3_7,
+	DA850_GPIO3_8,
 	DA850_GPIO3_12,
 	DA850_GPIO3_13,
 	DA850_GPIO4_0,
 	DA850_GPIO4_1,
+	DA850_GPIO4_2,
+	DA850_GPIO4_3,
+	DA850_GPIO4_4,
+	DA850_GPIO4_5,
+	DA850_GPIO4_6,
+	DA850_GPIO4_7,
+	DA850_GPIO4_8,
+	DA850_GPIO4_9,
+	DA850_GPIO4_10,
+	DA850_GPIO4_11,
+	DA850_GPIO4_12,
+	DA850_GPIO4_13,
+	DA850_GPIO4_14,
+	DA850_GPIO4_15,
+	DA850_GPIO5_0,
+	DA850_GPIO5_2,
+	DA850_GPIO5_3,
+	DA850_GPIO5_4,
+	DA850_GPIO5_5,
+	DA850_GPIO5_6,
+	DA850_GPIO6_0,
+	DA850_GPIO6_1,
 	DA850_GPIO6_9,
 	DA850_GPIO6_10,
+	DA850_GPIO6_11,
 	DA850_GPIO6_13,
+	DA850_GPIO6_15,
+	DA850_GPIO7_8,
+	DA850_GPIO8_5,
+	DA850_GPIO8_6,
+	DA850_GPIO8_11,
+	DA850_GPIO8_12,
+	DA850_GPIO8_13,
 	DA850_RTC_ALARM,
 
 	/* VPIF Capture */
-- 
1.8.3.3

