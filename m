Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaGGOpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:45:33 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:49600 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaGGOpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:45:32 -0400
MIME-Version: 1.0
In-Reply-To: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
References: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
Date: Mon, 7 Jul 2014 16:45:28 +0200
Message-ID: <CACRpkdbc=NDmmjLi_FKvXaQ7H6gY+xHWso=Vi=tgubME4JUfyg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] gpio: Add driver for Zynq GPIO controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Harini Katakam <harinik@xilinx.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Harini Katakam <harinikatakamlinux@gmail.com>,
        Harini Katakam <harini.katakam@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 1:39 PM, Harini Katakam <harinik@xilinx.com> wrote:

> From: Harini Katakam <harini.katakam@xilinx.com>
>
> Add support for GPIO controller used by Xilinx Zynq.
>
> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>
> v2 changes:
>  - convert to pm_runtime_force_(suspend|resume)
>  - add pm_runtime_set_active in probe()
>  - also (un)prepare clocks when they are dis-/enabled
>  - add some missing calls to pm_runtime_get()
>  - use pm_runtime_put() instead of sync variant
>  - remove gpio chip in driver remove()
>  - remove redundant type casts
>  - directly use IO helpers
>  - use BIT macro to set/clear bits
>  - migrate to GPIOLIB_IRQCHIP

This is a great improvement! Only small stuff remains.

> +#include <linux/bitops.h>
> +#include <linux/clk.h>
> +#include <linux/gpio.h>

This should be:
#include <linux/gpio/driver.h>

If that doesn't work ... why?

> +/**
> + * struct zynq_gpio - gpio device private data structure
> + * @chip:      instance of the gpio_chip
> + * @base_addr: base address of the GPIO device
> + * @irq:       irq associated with the controller
> + * @clk:       clock resource for this controller
> + */
> +struct zynq_gpio {
> +       struct gpio_chip chip;
> +       void __iomem *base_addr;
> +       int irq;

Why is irq kept around in this struct? It looks like it could just
be a local variable in probe()?

> +       struct clk *clk;
> +};

Apart from that this nitpicking the driver looks very nice.

Yours,
Linus Walleij
