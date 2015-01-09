Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbbAILDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:03:42 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:41897 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507AbbAILDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:03:40 -0500
MIME-Version: 1.0
In-Reply-To: <1417131990-17954-3-git-send-email-rjui@broadcom.com>
References: <rjui@broadcom.com>
	<1417131990-17954-1-git-send-email-rjui@broadcom.com>
	<1417131990-17954-3-git-send-email-rjui@broadcom.com>
Date: Fri, 9 Jan 2015 12:03:39 +0100
Message-ID: <CACRpkdbZx1hcvd-q9AL3FPQRqU+wJjeSV8AdSno5PVr+fqhpRQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: cygnus: add initial pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Ray Jui <rjui@broadcom.com>, Sherman Yin <syin@broadcom.com>,
        Simon Arlott <simon@fire.lp0.eu>, Chris Boot <bootc@bootc.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Scott Branden <sbranden@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 12:46 AM, Ray Jui <rjui@broadcom.com> wrote:

> This adds the initial driver support for the Broadcom Cygnus pinctrl
> controller. The Cygnus pinctrl controller supports group based
> alternate function configuration
>
> Signed-off-by: Ray Jui <rjui@broadcom.com>
> Reviewed-by: Scott Branden <sbranden@broadcom.com>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  drivers/pinctrl/Kconfig              |    7 +
>  drivers/pinctrl/Makefile             |    1 +
>  drivers/pinctrl/pinctrl-bcm-cygnus.c |  753 ++++++++++++++++++++++++++++++++++

With the proliferation of Broadcom drivers, please first send a
patch moving pinctrl-bcm281xx.c and pinctrl-bcm2835.c to
drivers/pinctrl/broadcom or something, so we can collect them
there.

I don't know if the hardware has any similarity though, so invite
the authors of the previous drivers to review this code.

> +config PINCTRL_BCM_CYGNUS
> +       bool "Broadcom Cygnus pinctrl driver"
> +       depends on (ARCH_BCM_CYGNUS || COMPILE_TEST)
> +       select PINMUX
> +       select PINCONF
> +       select GENERIC_PINCONF

Nice that you use GENERIC_PINCONF! :)

> +/*
> + * Cygnus pinctrl core
> + *
> + * @pctl: pointer to pinctrl_dev
> + * @dev: pointer to the device
> + * @base: I/O register base for Cygnus pinctrl configuration
> + *
> + */
> +struct cygnus_pinctrl {
> +       struct pinctrl_dev *pctl;
> +       struct device *dev;
> +       void __iomem *base;
> +
> +       const struct pinctrl_pin_desc *pins;
> +       unsigned num_pins;

Why is this not simply just a part of struct pinctrl_desc?
Why does it have to be multiplied here?

> +/*
> + * List of groups of pins
> + */
> +static const unsigned gpio0_pins[] = { 12 };
> +static const unsigned gpio1_pins[] = { 13 };
> +static const unsigned gpio2_pins[] = { 14 };
> +static const unsigned gpio3_pins[] = { 15 };
> +static const unsigned gpio4_pins[] = { 16 };
> +static const unsigned gpio5_pins[] = { 17 };
> +static const unsigned gpio6_pins[] = { 18 };
> +static const unsigned gpio7_pins[] = { 19 };
> +static const unsigned gpio8_pins[] = { 20 };
> +static const unsigned gpio9_pins[] = { 21 };
> +static const unsigned gpio10_pins[] = { 22 };
> +static const unsigned gpio11_pins[] = { 23 };
> +static const unsigned gpio12_pins[] = { 24 };
> +static const unsigned gpio13_pins[] = { 25 };
> +static const unsigned gpio14_pins[] = { 26 };
> +static const unsigned gpio15_pins[] = { 27 };
> +static const unsigned gpio16_pins[] = { 28 };
> +static const unsigned gpio17_pins[] = { 29 };
> +static const unsigned gpio18_pins[] = { 30 };
> +static const unsigned gpio19_pins[] = { 31 };
> +static const unsigned gpio20_pins[] = { 32 };
> +static const unsigned gpio21_pins[] = { 33 };
> +static const unsigned gpio22_pins[] = { 34 };
> +static const unsigned gpio23_pins[] = { 35 };

Have you considered implementing .gpio_request_enable()
and .gpio_disable_free() to get around having to have one
group for each GPIO line?

> +static const unsigned pwm0_pins[] = { 38 };
> +static const unsigned pwm1_pins[] = { 39 };
> +static const unsigned pwm2_pins[] = { 40 };
> +static const unsigned pwm3_pins[] = { 41 };
> +static const unsigned sdio0_pins[] = { 94, 95, 96, 97, 98, 99 };
> +static const unsigned smart_card0_pins[] = { 42, 43, 44, 46, 47 };
> +static const unsigned smart_card1_pins[] = { 48, 49, 50, 52, 53 };
> +static const unsigned spi0_pins[] = { 54, 55, 56, 57 };
> +static const unsigned spi1_pins[] = { 58, 59, 60, 61 };
> +static const unsigned spi2_pins[] = { 62, 63, 64, 65 };
> +static const unsigned spi3_pins[] = { 66, 67, 68, 69 };
> +static const unsigned d1w_pins[] = { 10, 11 };
> +static const unsigned lcd_pins[] = { 126, 127, 128, 129, 130, 131, 132,        133,
> +       134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147,
> +       148, 149, 150, 151, 152, 153, 154, 155 };
> +static const unsigned uart0_pins[] = { 70, 71, 72, 73 };
> +static const unsigned uart1_dte_pins[] = { 75, 76, 77, 78 };
> +static const unsigned uart1_pins[] = { 74, 79, 80, 81 };
> +static const unsigned uart3_pins[] = { 82, 83 };
> +static const unsigned qspi_pins[] = { 104, 105, 106, 107 };
> +static const unsigned nand_pins[] = { 110, 111, 112, 113, 114, 115, 116, 117,
> +       118, 119, 120, 121, 122, 123, 124, 125 };
> +static const unsigned sdio0_cd_pins[] = { 103 };
> +static const unsigned sdio0_mmc_pins[] = { 100, 101, 102 };
> +static const unsigned can0_spi4_pins[] = { 86, 87 };
> +static const unsigned can1_spi4_pins[] = { 88, 89 };
> +static const unsigned sdio1_cd_pins[] = { 93 };
> +static const unsigned sdio1_led_pins[] = { 84, 85 };
> +static const unsigned sdio1_mmc_pins[] = { 90, 91, 92 };
> +static const unsigned camera_led_pins[] = { 156, 157, 158, 159, 160 };
> +static const unsigned camera_rgmii_pins[] = { 169, 170, 171, 169, 170, 171,
> +       172, 173 };
> +static const unsigned camera_sram_rgmii_pins[] = { 161, 162, 163, 164, 165,
> +       166, 167, 168 };
> +static const unsigned qspi_gpio_pins[] = { 108, 109 };
> +static const unsigned smart_card0_fcb_pins[] = { 45 };
> +static const unsigned smart_card1_fcb_pins[] = { 51 };
> +static const unsigned gpio0_3p3_pins[] = { 176 };
> +static const unsigned gpio1_3p3_pins[] = { 177 };
> +static const unsigned gpio2_3p3_pins[] = { 178 };

Looks good...

> +/*
> + * List of groups names. Need to match the order in cygnus_pin_groups
> + */
> +static const char * const cygnus_pin_group_names[] = {
> +       "gpio0",
> +       "gpio1",
> +       "gpio2",
> +       "gpio3",
> +       "gpio4",
> +       "gpio5",
> +       "gpio6",
> +       "gpio7",
> +       "gpio8",
> +       "gpio9",
> +       "gpio10",
> +       "gpio11",
> +       "gpio12",
> +       "gpio13",
> +       "gpio14",
> +       "gpio15",
> +       "gpio16",
> +       "gpio17",
> +       "gpio18",
> +       "gpio19",
> +       "gpio20",
> +       "gpio21",
> +       "gpio22",
> +       "gpio23",
> +       "pwm0",
> +       "pwm1",
> +       "pwm2",
> +       "pwm3",
> +       "sdio0",
> +       "smart_card0",
> +       "smart_card1",
> +       "spi0",
> +       "spi1",
> +       "spi2",
> +       "spi3",
> +       "d1w",
> +       "lcd",
> +       "uart0",
> +       "uart1_dte",
> +       "uart1",
> +       "uart3",
> +       "qspi",
> +       "nand",
> +       "sdio0_cd",
> +       "sdio0_mmc",
> +       "can0_spi4",
> +       "can1_spi4",
> +       "sdio1_cd",
> +       "sdio1_led",
> +       "sdio1_mmc",
> +       "camera_led",
> +       "camera_rgmii",
> +       "camera_sram_rgmii",
> +       "qspi_gpio",
> +       "smart_card0_fcb",
> +       "smart_card1_fcb",
> +       "gpio0_3p3",
> +       "gpio1_3p3",
> +       "gpio2_3p3",
> +};

This looks very much like function names as noted in the binding.
I would say, suffix every group with _grp or something so it's not
as confusing. Remember, spi0 is a function of the SoC,
pins {1,2} is just a group of pins that it may appear on.

> +#define CYGNUS_PIN_FUNCTION(fcn_name, mux_val)                 \
> +{                                                              \
> +       .name = #fcn_name,                                      \
> +       .group_names = cygnus_pin_group_names,                  \
> +       .num_groups = ARRAY_SIZE(cygnus_pin_group_names),       \
> +       .mux = mux_val,                                         \
> +}
> +
> +/*
> + * Cygnus has 4 alternate functions. All groups can be configured to any of
> + * the 4 alternate functions
> + */
> +static const struct cygnus_pin_function cygnus_pin_functions[] = {
> +       CYGNUS_PIN_FUNCTION(alt1, 0),
> +       CYGNUS_PIN_FUNCTION(alt2, 1),
> +       CYGNUS_PIN_FUNCTION(alt3, 2),
> +       CYGNUS_PIN_FUNCTION(alt4, 3),
> +};

These are not functions. These are per-pin mux ways.

Re-read the documentation of what a function is: it is not something
abstract like "alternative something" but something very direct like
uart0 or spi0.

> +static int cygnus_dt_node_to_map(struct pinctrl_dev *pctrl_dev,
> +               struct device_node *np, struct pinctrl_map **map,
> +               unsigned *num_maps)
> +{

After Sören Brinkmanns patches youy should be able to use core
functions for this and avoid this code altogether.

> +       num_groups = of_property_count_strings(np, "brcm,groups");

As mentioned, just "groups".

> +       ret = of_property_read_string(np, "brcm,function", &function_name);

As mentioned, just "function".

> +       ret = pinctrl_utils_reserve_map(pctrl_dev, map, &reserved_maps,
> +                       num_maps, num_groups);

Good use of utilities!

Apart from this things look nice.

The main comment to address is the definition of functions.

Yours,
Linus Walleij
