Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaIXNJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:09:33 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:50426 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbaIXNJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:09:31 -0400
Message-ID: <1411564172.18580.69.camel@iivanov-dev>
Subject: Re: [PATCH v4 3/4] pinctrl: Qualcomm SPMI PMIC GPIO pin controller
 driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        David Collins <collinsd@codeaurora.org>,
        Wu Fenglin <fenglinw@qti.qualcomm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Date: Wed, 24 Sep 2014 16:09:32 +0300
In-Reply-To: <20140924041852.GO10179@sonymobile.com>
References: <1410792254-24126-1-git-send-email-iivanov@mm-sol.com>
	 <1410792254-24126-4-git-send-email-iivanov@mm-sol.com>
	 <20140924041852.GO10179@sonymobile.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 21:18 -0700, Bjorn Andersson wrote:
> On Mon 15 Sep 07:44 PDT 2014, Ivan T. Ivanov wrote:
> 

<snip>

> > +static int pmic_gpio_of_xlate(struct gpio_chip *chip,
> > +                             const struct of_phandle_args *gpio_desc,
> > +                             u32 *flags)
> > +{
> > +       if (chip->of_gpio_n_cells < 2)
> > +               return -EINVAL;
> > +
> > +       if (flags)
> > +               *flags = gpio_desc->args[1];
> > +
> > +       return gpio_desc->args[0] - PMIC_GPIO_PHYSICAL_OFFSET;
> > +}
> 
> If you change:
>  gpiochip_add_pin_range(&state->chip, dev_name(dev), 0, 0, npins);
> to:
>  gpiochip_add_pin_range(&state->chip, dev_name(dev), 1, 0, npins);
> 
> And you treat the gpio functions as taking the gpio number instead of pinctrl
> number (i.e. subtract 1 in those), then gpiolib will provide this function for
> you.
> 

I am unable to make this work. of_gpio_simple_xlate() didn't know that
GPIO range is offset with 1. Requesting last GPIO return error. And
debug output looks weird, for example:

# cat /sys/kernel/debug/gpio
...
GPIOs 220-255, platform/0.c000.gpios, 0.c000.gpios:
...

# cat /sys/kernel/debug/pinctrl/0.c000.gpios/gpio-ranges 
GPIO ranges handled:
1: 0.c000.gpios GPIOS [221 - 256] PINS [0 - 35]

Advice, please.

> [..]
> > +
> > +static const struct of_device_id pmic_gpio_of_match[] = {
> > +       { .compatible = "qcom,spmi-pmic-gpio" },
> 
> I think this should be more specific, because hopefully the spmi specification
> will outlive the current pmic gpio block.
> 
> So I think you need to list the pmic blocks here (e.g. "qcom,pm8941-gpio").

I can rename this to lovely "qcom,qpnp-gpio" :-), in this way driver
can outlive bus on which device is connected this time.

Regards,
Ivan


