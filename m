Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3IZMJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:09:04 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52511 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab3IZMJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:09:00 -0400
MIME-Version: 1.0
In-Reply-To: <1380041605-15736-2-git-send-email-m.krawczuk@partner.samsung.com>
References: <1380041605-15736-1-git-send-email-m.krawczuk@partner.samsung.com>
	<1380041605-15736-2-git-send-email-m.krawczuk@partner.samsung.com>
Date: Thu, 26 Sep 2013 17:38:58 +0530
Message-ID: <CAKew6eUgpnqvZUCsWGpqwDXtp6ARmhd-Nw-BXiod8=MK-k0fUA@mail.gmail.com>
Subject: Re: [PATCH 2/3] clk: samsung: Add clock driver for s5pc100
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Yadwinder Singh <yadi.brar@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>, rob@landley.net,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, ijc+devicetree@hellion.org.uk,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, ben-linux@fluff.org,
        s.nawrocki@samsung.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,


After a quick view, just few things regarding coding styles.

[...]
> +#define        GENERAL_STATUS          0x0104
> +#define        CAM_MUX_SEL             0x0300
> +#define        MIXER_OUT_SEL           0x0304
> +#define        LPMP3_MODE_SEL          0x0308
> +#define MIPI_PHY_CON0          0x0400
> +#define MIPI_PHY_CON1          0x0414
> +#define HDMI_PHY_CON0          0x0420

How about aligning all above with same no. of tabs?

> +
> +/* Helper macros to define clock arrays. */
> +#define FIXED_RATE_CLOCKS(name)        \
> +               static struct samsung_fixed_rate_clock name[]
> +#define MUX_CLOCKS(name)       \
> +               static struct samsung_mux_clock name[]
> +#define DIV_CLOCKS(name)       \
> +               static struct samsung_div_clock name[]
> +#define GATE_CLOCKS(name)      \
> +               static struct samsung_gate_clock name[]
> +

These macros seems little bit odd in our common practice,
perhaps these are making code harder to read below.

> +/* Helper macros for gate types present on S5PC100. */
> +#define GATE_BUS(_id, cname, pname, o, b) \
> +               GATE(_id, cname, pname, o, b, 0, 0)
> +#define GATE_SCLK(_id, cname, pname, o, b) \
> +               GATE(_id, cname, pname, o, b, CLK_SET_RATE_PARENT, 0)
> +#define GATE_ON(_id, cname, pname, o, b) \
> +               GATE(_id, cname, pname, o, b, CLK_IGNORE_UNUSED, 0)
> +
[...]
> +PNAME(mout_hclk_2_p) = {
> +       "fout_epll",
> +       "i2scdclk0"
> +};
> +
> +PNAME(mout_i2s_2_p) = {
> +       "fout_epll",
> +       "i2scdclk0",
> +       "dout_audio0",
> +       "none"
> +};
> +

Using one line per parent isn't increasing length of file unnecessarily?

[ ... ]
> +
> +/* list of all parent clock list */
> +static struct samsung_clock_alias s5pc100_clock_aliases[] = {
> +       ALIAS(FIMC0, "s5pc100-fimc.0", "fimc"),
> +       ALIAS(FIMC1, "s5pc100-fimc.1", "fimc"),
> +       ALIAS(FIMC2, "s5pc100-fimc.2", "fimc"),
> +       ALIAS(MOUT_FIMC2, NULL, "mout_fimc2"),
> +       ALIAS(MOUT_FIMC1, NULL, "mout_fimc1"),
> +       ALIAS(MOUT_FIMC0, NULL, "mout_fimc0"),
> +       ALIAS(SCLK_FIMC0, "s5pc100-fimc.0", "sclk_fimc"),
> +       ALIAS(SCLK_FIMC1, "s5pc100-fimc.1", "sclk_fimc"),
> +       ALIAS(SCLK_FIMC2, "s5pc100-fimc.2", "sclk_fimc"),
> +
> +       ALIAS(MOUT_APLL, NULL, "mout_apll"),
> +       ALIAS(MOUT_MPLL, NULL, "mout_mpll"),
> +       ALIAS(MOUT_EPLL, NULL, "mout_epll"),
> +       ALIAS(MOUT_HPLL, NULL, "mout_hpll"),
> +       ALIAS(MOUT_HPLL, NULL, "sclk_hpll"),
> +       ALIAS(UART0, "s3c6400-uart.0", "uart"),
> +       ALIAS(UART1, "s3c6400-uart.1", "uart"),
> +       ALIAS(UART2, "s3c6400-uart.2", "uart"),
> +       ALIAS(UART3, "s3c6400-uart.3", "uart"),
> +       ALIAS(UART0, "s3c6400-uart.0", "clk_uart_baud0"),
> +       ALIAS(UART1, "s3c6400-uart.1", "clk_uart_baud0"),
> +       ALIAS(UART2, "s3c6400-uart.2", "clk_uart_baud0"),
> +       ALIAS(UART3, "s3c6400-uart.3", "clk_uart_baud0"),
> +       ALIAS(UART0, "s3c6400-uart.0", "clk_uart_baud2"),
> +       ALIAS(UART1, "s3c6400-uart.1", "clk_uart_baud2"),
> +       ALIAS(UART2, "s3c6400-uart.2", "clk_uart_baud2"),
> +       ALIAS(UART3, "s3c6400-uart.3", "clk_uart_baud2"),
> +       ALIAS(SCLK_UART, "s3c6400-uart.0", "clk_uart_baud3"),
> +       ALIAS(SCLK_UART, "s3c6400-uart.1", "clk_uart_baud3"),
> +       ALIAS(SCLK_UART, "s3c6400-uart.2", "clk_uart_baud3"),
> +       ALIAS(SCLK_UART, "s3c6400-uart.3", "clk_uart_baud3"),
> +
> +       ALIAS(HSMMC0, "s3c-sdhci.0", "hsmmc"),
> +       ALIAS(HSMMC1, "s3c-sdhci.1", "hsmmc"),
> +       ALIAS(HSMMC2, "s3c-sdhci.2", "hsmmc"),
> +       ALIAS(HSMMC0, "s3c-sdhci.0", "mmc_busclk.0"),
> +       ALIAS(HSMMC1, "s3c-sdhci.1", "mmc_busclk.0"),
> +       ALIAS(HSMMC2, "s3c-sdhci.2", "mmc_busclk.0"),
> +       ALIAS(SCLK_MMC0, "s3c-sdhci.0", "mmc_busclk.2"),
> +       ALIAS(SCLK_MMC1, "s3c-sdhci.1", "mmc_busclk.2"),
> +       ALIAS(SCLK_MMC2, "s3c-sdhci.2", "mmc_busclk.2"),
> +       ALIAS(SCLK_MMC0_48, "s3c-sdhci.0", "mmc_busclk.3"),
> +       ALIAS(SCLK_MMC1_48, "s3c-sdhci.1", "mmc_busclk.3"),
> +       ALIAS(SCLK_MMC2_48, "s3c-sdhci.2", "mmc_busclk.3"),
> +
> +       ALIAS(SPI0, "s5pc100-spi.0", "spi"),
> +       ALIAS(SPI1, "s5pc100-spi.1", "spi"),
> +       ALIAS(SPI2, "s5pc100-spi.2", "spi"),
> +       ALIAS(SPI0, "s5pc100-spi.0", "spi_busclk0"),
> +       ALIAS(SPI1, "s5pc100-spi.1", "spi_busclk0"),
> +       ALIAS(SPI2, "s5pc100-spi.2", "spi_busclk0"),
> +       ALIAS(SCLK_SPI0_48, "s5pc100-spi.0", "spi_busclk1"),
> +       ALIAS(SCLK_SPI1_48, "s5pc100-spi.1", "spi_busclk1"),
> +       ALIAS(SCLK_SPI2_48, "s5pc100-spi.2", "spi_busclk1"),
> +       ALIAS(SCLK_SPI0, "s5pc100-spi.0", "spi_busclk2"),
> +       ALIAS(SCLK_SPI1, "s5pc100-spi.1", "spi_busclk2"),
> +       ALIAS(SCLK_SPI2, "s5pc100-spi.2", "spi_busclk2"),
> +       ALIAS(PDMA0, "dma-pl330.0", "apb_pclk"),
> +       ALIAS(PDMA1, "dma-pl330.1", "apb_pclk"),
> +       ALIAS(PWM, NULL, "timers"),
> +
> +       ALIAS(JPEG, NULL, "jpeg"),
> +       ALIAS(MFC, "s5p-mfc", "mfc"),
> +       ALIAS(TV, "s5p-sdo", "dac"),
> +       ALIAS(MIXER, "s5p-mixer", "mixer"),
> +       ALIAS(VP, "s5p-mixer", "vp"),
> +       ALIAS(HDMI, "s5p-hdmi", "hdmi"),
> +       ALIAS(SCLK_HDMI, "s5p-hdmi", "hdmiphy"),
> +
> +       ALIAS(USB_OTG, NULL, "otg"),
> +       ALIAS(USB_HOST, NULL, "usb-host"),
> +       ALIAS(USB_HOST, NULL, "usbhost"),
> +       ALIAS(LCDCON, "s5pc100-fb", "lcd"),
> +       ALIAS(CFCON, NULL, "cfcon"),
> +       ALIAS(SYSTIMER, NULL, "systimer"),
> +       ALIAS(WDT, NULL, "watchdog"),
> +       ALIAS(RTC, NULL, "rtc"),
> +       ALIAS(I2C, "s3c2440-i2c.0", "i2c"),
> +       ALIAS(CCAN0, NULL, "ccan"),
> +       ALIAS(CCAN1, NULL, "ccan"),
> +       ALIAS(I2C_HDMI, "s3c2440-i2c.1", "i2c"),
> +       ALIAS(HSITX, NULL, "hsitx"),
> +       ALIAS(HSIRX, NULL, "hsirx"),
> +       ALIAS(TSADC, NULL, "adc"),
> +       ALIAS(KEYIF, "s5pc100-keypad", "keypad"),
> +       ALIAS(I2S0, "samsung-i2s.0", "iis"),
> +       ALIAS(I2S1, "samsung-i2s.1", "iis"),
> +       ALIAS(I2S2, "samsung-i2s.2", "iis"),
> +       ALIAS(SPDIF, NULL, "spdif"),
> +       ALIAS(ROTATOR, NULL, "rot"),
> +       ALIAS(DOUT_ARM, NULL, "armclk"),
> +       ALIAS(SCLK_AUDIO0, "soc-audio.0", "sclk_audio"),
> +       ALIAS(SCLK_AUDIO1, "soc-audio.1", "sclk_audio"),
> +       ALIAS(SCLK_AUDIO2, "soc-audio.2", "sclk_audio"),
> +       ALIAS(KEYIF, NULL, "keypad"),
> +
> +       ALIAS(MFC, "s5p-mfc", "sclk_mfc"),
> +       ALIAS(G2D, "s5p-g2d", "fimg2d"),
> +
> +};
> +

Any reason/hidden advantage for using a separate of ALIAS,
instead of using MUX_A/GATE_A ?

[ ... ]
> +       s5pc100_clk_register_finpll(xom);
> +
> +       /* Register PLLs. */

Why this special comment/treatment for PLLs :) ?
Others below doesn't get such treatment.

> +       samsung_clk_register_pll(s5pc100_pll_clks,
> +                               ARRAY_SIZE(s5pc100_pll_clks), reg_base);
> +
> +       samsung_clk_register_fixed_rate(s5pc100_fixed_rate_clks,
> +                       ARRAY_SIZE(s5pc100_fixed_rate_clks));
> +
>


Regards,
Yadwinder
