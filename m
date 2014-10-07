Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaJGKEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:04:20 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:56697 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbaJGKES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:04:18 -0400
MIME-Version: 1.0
In-Reply-To: <1412606822-3406-1-git-send-email-muth@cypress.com>
References: <1412606822-3406-1-git-send-email-muth@cypress.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 7 Oct 2014 19:03:56 +0900
Message-ID: <CAAVeFu+vBZ49ciZT+-dnKXks201_psy_NtYsTjw0ptOkx2es7Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO adapter
To: Muthu Mani <muth@cypress.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rajaram Regupathy <rera@cypress.com>, Johan Hovold <johan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 6, 2014 at 11:47 PM, Muthu Mani <muth@cypress.com> wrote:
> +
> +static int cy_gpio_direction_input(struct gpio_chip *chip,
> +                                       unsigned offset)
> +{
> +       return 0;
> +}
> +
> +static int cy_gpio_direction_output(struct gpio_chip *chip,
> +                                       unsigned offset, int value)
> +{
> +       return 0;
> +}

If that chip is capable of both output and input, shouldn't these
functions be implemented? I think this has already been pointed out in
a previous version but you did not reply.

> +
> +static int cyusbs23x_gpio_probe(struct platform_device *pdev)
> +{
> +       struct cyusbs23x *cyusbs;
> +       struct cyusbs_gpio *cy_gpio;
> +       int ret = 0;
> +
> +       dev_dbg(&pdev->dev, "%s\n", __func__);

> +
> +       cyusbs = dev_get_drvdata(pdev->dev.parent);
> +
> +       cy_gpio = devm_kzalloc(&pdev->dev, sizeof(*cy_gpio), GFP_KERNEL);
> +       if (cy_gpio == NULL)
> +               return -ENOMEM;
> +
> +       cy_gpio->cyusbs = cyusbs;
> +       /* registering gpio */
> +       cy_gpio->gpio.label = dev_name(&pdev->dev);
> +       cy_gpio->gpio.dev = &pdev->dev;
> +       cy_gpio->gpio.owner = THIS_MODULE;
> +       cy_gpio->gpio.base = -1;
> +       cy_gpio->gpio.ngpio = 12; /* total GPIOs */

Isn't there a way to get the number of GPIOs from a reliable source?
If not, please at least use a macro here.
