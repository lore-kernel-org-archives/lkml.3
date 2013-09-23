Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab3IWIGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:06:10 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:51423 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3IWIGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:06:07 -0400
MIME-Version: 1.0
In-Reply-To: <1379680214-9143-4-git-send-email-ldewangan@nvidia.com>
References: <1379680214-9143-1-git-send-email-ldewangan@nvidia.com>
	<1379680214-9143-4-git-send-email-ldewangan@nvidia.com>
Date: Mon, 23 Sep 2013 10:06:07 +0200
Message-ID: <CACRpkdbJ6N-5RET+cmF=14jKVDnuAZtZwjcKym75ySER2gCpBQ@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH V2 3/5] gpio: add support for AMS AS3722 gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: rtc-linux@googlegroups.com
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Landley <rob@landley.net>,
        ijc+devicetree@hellion.org.uk, Grant Likely <grant.likely@linaro.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Florian Lobmaier <florian.lobmaier@ams.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 2:30 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> The AS3722 is a compact system PMU suitable for mobile phones, tablets etc.
>
> Add a driver to support accessing the 8 GPIOs found on the AMS AS3722
> PMIC using gpiolib.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>

OK...

> +Required subnode properties:
> +---------------------------
> +reg: The GPIO number on which the properties need to be applied.
> +
> +Optional subnode properties:
> +---------------------------
> +bias-pull-up: The Pull-up for the pin to be enable.
> +bias-pull-down: Pull down of the pins to be enable.
> +bias-high-impedance: High impedance of the pin to be enable.
> +open-drain: Pin is open drain type.
> +function: IO functionality of the pins. The valid options are:
> +       gpio, intrrupt-output, vsup-vbat-low-undeb, interrupt-input,
> +       pwm-input, voltage-stby, oc-powergood-sd0, powergood-output,
> +       clk32k-output, watchdog-input, soft-reset-input, pwm-output,
> +       vsup-vbat-low-deb, oc-powergood-sd6
> +    Missing the function property will set the pin in GPIO mode.

This is pin control. Do not try to shoehorn pin control drivers into
the GPIO subsystem. Take a good day off, read through
Documentation/pinctrl.txt and come back with a thoroughly rewritten
driver in drivers/pinctrl/pinctrl-as3722.c.

We already have generic device tree bindings for all of the above
properties, and a library for generic pin config in the pin control
subsystem to handle them. Look at recent drivers for
inspiration.

> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig

Move this driver to the pinctrl subsystem.

> index b6ed304..544a612 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -368,6 +368,12 @@ config GPIO_ARIZONA
>         help
>           Support for GPIOs on Wolfson Arizona class devices.
>
> +config GPIO_AS3722
> +       bool "AMS AS3722 PMICs GPIO"
> +       depends on MFD_AS3722
> +       help
> +         Select this option to enable GPIO driver for the AMS AS3722 PMIC.

It should
select PINMUX
select GENERIC_PINCONF

> +static char const *as3722_gpio_iosf[] = {
> +       "gpio",
> +       "intrrupt-output",

intrrupt?

Yours,
Linus Walleij
