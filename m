Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbaGDRw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:52:56 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25458 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759518AbaGDRtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:49:04 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-d9-53b6e90eb062
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 19/19] clk: samsung: s5pv210: Remove legacy board support
Date: Fri, 04 Jul 2014 19:48:19 +0200
Message-id: <1404496099-26708-20-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xy7p8L7cFGyw8ZWbxd9IxdoupD5+w
	Wfx/9JrVonfBVTaLTY+vsVpc3jWHzWLG+X1MFmuP3GW3OHX9M5vFql1/GB24PH7/msTosXPW
	XXaPTas62Tw2L6n3uHKiidWjb8sqRo/t1+Yxe3zeJBfAEcVlk5Kak1mWWqRvl8CV8f7NS7aC
	26YVnasWszUwHtXrYuTgkBAwkZjTaNjFyAlkiklcuLeerYuRi0NIYCmjxLwzn1ggnD4mielf
	p7GAVLEJqEl8bnjEBmKLCKhKfG5bwA4yiFngNpNEqzBIWFjAU2LlnheMIDYLUMmMszOZQGxe
	AWeJeZ9/sUIsk5Po3faGGcTmBIpPXHcBrEZIwEniz//5LBMYeRcwMqxiFE0tTS4oTkrPNdIr
	TswtLs1L10vOz93ECAnGrzsYlx6zOsQowMGoxMPb0LItWIg1say4MvcQowQHs5II759VQCHe
	lMTKqtSi/Pii0pzU4kOMTBycUg2M7ezt747Nddtv+nnKghqtq8td5vvOq1y99sgS1x0JnyeL
	11V1556+s+VPYcV/k+v9VxYzR8/imN/6ZtfXk7fOSNiaTP1Q4HlBPypY6/SzPs6VPI5fek6+
	F7lbEyZQ6/xhf+ztzczLE6zCGbb871f8ev5bcvQURf0dyVav6mfLpqUf+e4nL/PshhJLcUai
	oRZzUXEiAGilCDskAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is no more support for board files, this patch removes
legacy non-DT support from the clock driver as well, including
unnecessary clkdev aliases.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/samsung/clk-s5pv210.c | 122 +-------------------------------------
 1 file changed, 1 insertion(+), 121 deletions(-)

diff --git a/drivers/clk/samsung/clk-s5pv210.c b/drivers/clk/samsung/clk-s5pv210.c
index 509779a..d270a20 100644
--- a/drivers/clk/samsung/clk-s5pv210.c
+++ b/drivers/clk/samsung/clk-s5pv210.c
@@ -503,15 +503,6 @@ static struct samsung_mux_clock s5p6442_mux_clks[] __initdata = {
 	MUX(MOUT_CLKSEL, "mout_clksel", mout_clksel_6442_p, CLK_OUT, 12, 5),
 };
 
-/*
- * Common fixed rate clocks generated outside the SoC.
- * NOTE: Needed only to support legacy board files.
- */
-static struct samsung_fixed_rate_clock ext_clks[] __initdata = {
-	[xxti] = FRATE(0, "xxti", NULL, CLK_IS_ROOT, 0),
-	[xusbxti] = FRATE(0, "xusbxti", NULL, CLK_IS_ROOT, 0),
-};
-
 /* S5PV210-specific fixed rate clocks generated inside the SoC. */
 static struct samsung_fixed_rate_clock s5pv210_frate_clks[] __initdata = {
 	FRATE(SCLK_HDMI27M, "sclk_hdmi27m", NULL, CLK_IS_ROOT, 27000000),
@@ -758,103 +749,10 @@ static struct samsung_gate_clock s5p6442_gate_clks[] __initdata = {
  * NOTE: Needed only to support legacy board files.
  */
 static struct samsung_clock_alias s5pv210_aliases[] = {
-	ALIAS(CLK_FIMC0, "s5pv210-fimc.0", "fimc"),
-	ALIAS(CLK_FIMC1, "s5pv210-fimc.1", "fimc"),
-	ALIAS(CLK_FIMC2, "s5pv210-fimc.2", "fimc"),
-	ALIAS(SCLK_FIMC0, "s5pv210-fimc.0", "sclk_fimc"),
-	ALIAS(SCLK_FIMC1, "s5pv210-fimc.1", "sclk_fimc"),
-	ALIAS(SCLK_FIMC2, "s5pv210-fimc.2", "sclk_fimc"),
 	ALIAS(DOUT_APLL, NULL, "armclk"),
 	ALIAS(DOUT_HCLKM, NULL, "hclk_msys"),
 	ALIAS(MOUT_DMC0, NULL, "sclk_dmc0"),
-	ALIAS(CLK_UART0, "s5pv210-uart.0", "uart"),
-	ALIAS(CLK_UART1, "s5pv210-uart.1", "uart"),
-	ALIAS(CLK_UART2, "s5pv210-uart.2", "uart"),
-	ALIAS(CLK_UART3, "s5pv210-uart.3", "uart"),
-	ALIAS(CLK_UART0, "s5pv210-uart.0", "clk_uart_baud0"),
-	ALIAS(CLK_UART1, "s5pv210-uart.1", "clk_uart_baud0"),
-	ALIAS(CLK_UART2, "s5pv210-uart.2", "clk_uart_baud0"),
-	ALIAS(CLK_UART3, "s5pv210-uart.3", "clk_uart_baud0"),
-	ALIAS(SCLK_UART0, "s5pv210-uart.0", "clk_uart_baud1"),
-	ALIAS(SCLK_UART1, "s5pv210-uart.1", "clk_uart_baud1"),
-	ALIAS(SCLK_UART2, "s5pv210-uart.2", "clk_uart_baud1"),
-	ALIAS(SCLK_UART3, "s5pv210-uart.3", "clk_uart_baud1"),
-	ALIAS(CLK_HSMMC0, "s3c-sdhci.0", "hsmmc"),
-	ALIAS(CLK_HSMMC1, "s3c-sdhci.1", "hsmmc"),
-	ALIAS(CLK_HSMMC2, "s3c-sdhci.2", "hsmmc"),
-	ALIAS(CLK_HSMMC3, "s3c-sdhci.3", "hsmmc"),
-	ALIAS(CLK_HSMMC0, "s3c-sdhci.0", "mmc_busclk.0"),
-	ALIAS(CLK_HSMMC1, "s3c-sdhci.1", "mmc_busclk.0"),
-	ALIAS(CLK_HSMMC2, "s3c-sdhci.2", "mmc_busclk.0"),
-	ALIAS(CLK_HSMMC3, "s3c-sdhci.3", "mmc_busclk.0"),
-	ALIAS(SCLK_MMC0, "s3c-sdhci.0", "mmc_busclk.2"),
-	ALIAS(SCLK_MMC1, "s3c-sdhci.1", "mmc_busclk.2"),
-	ALIAS(SCLK_MMC2, "s3c-sdhci.2", "mmc_busclk.2"),
-	ALIAS(SCLK_MMC3, "s3c-sdhci.3", "mmc_busclk.2"),
-	ALIAS(CLK_SPI0, "s5pv210-spi.0", "spi_busclk0"),
-	ALIAS(CLK_SPI1, "s5pv210-spi.1", "spi_busclk0"),
-	ALIAS(SCLK_SPI0, "s5pv210-spi.0", "spi_busclk1"),
-	ALIAS(SCLK_SPI1, "s5pv210-spi.1", "spi_busclk1"),
-	ALIAS(CLK_PDMA0, "dma-pl330.0", "apb_pclk"),
-	ALIAS(CLK_PDMA1, "dma-pl330.1", "apb_pclk"),
-	ALIAS(CLK_PWM, NULL, "timers"),
-	ALIAS(CLK_NANDXL, "s5pc110-onenand", "gate"),
-	ALIAS(CLK_JPEG, NULL, "jpeg"),
-	ALIAS(CLK_MFC, "s5p-mfc", "mfc"),
-	ALIAS(CLK_TVENC, "s5p-sdo", "dac"),
-	ALIAS(CLK_MIXER, "s5p-mixer", "mixer"),
-	ALIAS(CLK_VP, "s5p-mixer", "vp"),
-	ALIAS(CLK_HDMI, "s5p-hdmi", "hdmi"),
-	ALIAS(SCLK_HDMI, "s5p-hdmi", "hdmiphy"),
-	ALIAS(SCLK_DAC, NULL, "sclk_dac"),
-	ALIAS(CLK_USB_OTG, NULL, "usbotg"),
-	ALIAS(CLK_USB_OTG, NULL, "otg"),
-	ALIAS(CLK_USB_HOST, NULL, "usb-host"),
-	ALIAS(CLK_USB_HOST, NULL, "usbhost"),
-	ALIAS(CLK_FIMD, "s5pv210-fb", "lcd"),
-	ALIAS(CLK_CFCON, "s5pv210-pata.0", "cfcon"),
-	ALIAS(CLK_WDT, NULL, "watchdog"),
-	ALIAS(CLK_RTC, NULL, "rtc"),
-	ALIAS(CLK_I2C0, "s3c2440-i2c.0", "i2c"),
-	ALIAS(CLK_I2C1, "s3c2440-i2c.1", "i2c"),
-	ALIAS(CLK_I2C2, "s3c2440-i2c.2", "i2c"),
-	ALIAS(CLK_I2C_HDMI_PHY, "s3c2440-hdmiphy-i2c", "i2c"),
-	ALIAS(CLK_TSADC, NULL, "adc"),
-	ALIAS(CLK_KEYIF, "s5pv210-keypad", "keypad"),
-	ALIAS(CLK_I2S0, "samsung-i2s.0", "iis"),
-	ALIAS(CLK_I2S1, "samsung-i2s.1", "iis"),
-	ALIAS(CLK_I2S2, "samsung-i2s.2", "iis"),
-	ALIAS(CLK_SPDIF, NULL, "spdif"),
-	ALIAS(SCLK_AUDIO0, "soc-audio.0", "sclk_audio"),
-	ALIAS(SCLK_AUDIO1, "soc-audio.1", "sclk_audio"),
-	ALIAS(SCLK_AUDIO2, "soc-audio.2", "sclk_audio"),
-	ALIAS(CLK_MFC, "s5p-mfc", "sclk_mfc"),
-	ALIAS(SCLK_CAM0, "sclk_cam0", "sclk_cam0"),
-	ALIAS(SCLK_CAM1, "sclk_cam1", "sclk_cam1"),
-	ALIAS(CLK_G2D, "s5p-g2d", "fimg2d"),
-	ALIAS(DOUT_G2D, "s5p-g2d", "sclk_fimg2d"),
-	ALIAS(CLK_CSIS, "s5p-mipi-csis", "csis"),
-	ALIAS(SCLK_CSIS, "s5p-mipi-csis", "sclk_csis"),
-	ALIAS(SCLK_PWM, "samsung-pwm", "pwm-tclk0"),
-	ALIAS(SCLK_PWM, "samsung-pwm", "pwm-tclk1"),
-	ALIAS(SCLK_FIMD, NULL, "sclk_fimd"),
-	ALIAS(MOUT_CAM0, NULL, "mout_cam0"),
-	ALIAS(MOUT_CAM1, NULL, "mout_cam1"),
-	ALIAS(MOUT_CSIS, NULL, "mout_csis"),
-	ALIAS(MOUT_VPLL, NULL, "sclk_vpll"),
-	ALIAS(SCLK_MIXER, NULL, "sclk_mixer"),
-	ALIAS(SCLK_HDMI, NULL, "sclk_hdmi"),
-};
-
-static void __init s5pv210_clk_register_fixed_ext(
-					struct samsung_clk_provider *ctx,
-					unsigned long xxti_f,
-					unsigned long xusbxti_f)
-{
-	ext_clks[xxti].fixed_rate = xxti_f;
-	ext_clks[xusbxti].fixed_rate = xusbxti_f;
-	samsung_clk_register_fixed_rate(ctx, ext_clks, ARRAY_SIZE(ext_clks));
-}
+};
 
 /* S5PV210-specific PLLs. */
 static struct samsung_pll_clock s5pv210_pll_clks[] __initdata = {
@@ -891,10 +789,6 @@ static void __init __s5pv210_clk_init(struct device_node *np,
 	if (!ctx)
 		panic("%s: unable to allocate context.\n", __func__);
 
-	/* Register external clocks (needed by board files). */
-	if (!np)
-		s5pv210_clk_register_fixed_ext(ctx, xxti_f, xusbxti_f);
-
 	samsung_clk_register_mux(ctx, early_mux_clks,
 					ARRAY_SIZE(early_mux_clks));
 
@@ -941,20 +835,6 @@ static void __init __s5pv210_clk_init(struct device_node *np,
 		_get_rate("mout_epll"), _get_rate("mout_vpll"));
 }
 
-/**
- * s5pv210_clk_init
- * @xxti_f: Rate of XXTI input clock.
- * @xusbxti_f: Rate of XUSBXTI input clock.
- * @base:
- */
-void __init s5pv210_clk_init(unsigned long xxti_f, unsigned long xusbxti_f,
-			     void __iomem *base)
-{
-	reg_base = base;
-
-	__s5pv210_clk_init(NULL, xxti_f, xusbxti_f, false);
-}
-
 static void __init s5pv210_clk_dt_init(struct device_node *np)
 {
 	reg_base = of_iomap(np, 0);
-- 
1.9.3

