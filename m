Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab3FQJFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:05:40 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:49894 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab3FQJFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:05:39 -0400
MIME-Version: 1.0
In-Reply-To: <1370527523-1030-1-git-send-email-archit@ti.com>
References: <1370527523-1030-1-git-send-email-archit@ti.com>
Date: Mon, 17 Jun 2013 11:05:38 +0200
Message-ID: <CACRpkdY-HZ4AGqKr-DA1pvfnaVYEGZoEDn_wfDr8=9Qr+6dpiw@mail.gmail.com>
Subject: Re: [PATCH] gpio: Enable pcf857x GPIO expander for Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Archit Taneja <archit@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 4:05 PM, Archit Taneja <archit@ti.com> wrote:

> Add code to parse the GPIO expander Device Tree node and extract platform data
> out of it, and populate the struct 'pcf857x_platform_data' maintained by the
> driver. This enables devices to reference the gpio expander from Device Tree.
>
> Add DT binding info in Documentation.
>
> CC: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Archit Taneja <archit@ti.com>

(...)
> +++ b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> @@ -0,0 +1,44 @@
> +PCF857x I2C based GPIO controller bindings
> +
> +Required properties:
> +- compatible:
> +  - "nxp,pca9670" for NXP PCA9670 8 bit I/O expander
> +  - "nxp,pca9672" for NXP PCA9672 8 bit I/O expander with interrupt
> +  - "nxp,pca9674" for NXP PCA9672 8 bit I/O expander with interrupt
> +  - "nxp,pca8574" for NXP PCA8574 8 bit I/O expander with interrupt
> +  - "nxp,pca8575" for NXP PCA8575 16 bit I/O expander with interrupt
> +  - "nxp,pca9671" for NXP PCA9671 16 bit I/O expander
> +  - "nxp,pca9673" for NXP PCA9673 16 bit I/O expander with interrupt
> +  - "nxp,pca9675" for NXP PCA9675 16 bit I/O expander with interrupt
> +  - "ti,pcf8574"  for TI PCF8574 8 bit I/O expander with interrupt
> +  - "ti,pcf8574a" for TI PCF8574A 8 bit I/O expander with interrupt
> +  - "ti,pcf8575"  for TI PCF8575 16 bit I/O expander with interrupt
> +  - "ti,tca9554"  for TI TCA9554 8 bit I/O expander with interrupt
> +  - "maxim,max7328" for MAXIM MAX7328 8 bit I/O expander with interrupt
> +  - "maxim,max7329" for MAXIM MAX7329 8 bit I/O expander with interrupt
> +- gpio-controller : Marks the device node as a GPIO controller.
> +- #gpio-cells : Should be two.
> +  - first cell is the pin number.
> +  - second cell is unused.

I guess you're adding this because the generic GPIO bindings use it and
of_gpio_simple_xlate() depends on this two-cell layout.

Make a reference to the generic GPIO bindings and note that the
second cell is *NOT* unused, as it is used in the GPIOlib!

> +- interrupt-controller: Mark the device node as an interrupt controller.
> +- #interrupt-cells : Should be two.
> +  - first cell is the GPIO number.

Surely it is the IRQ number and not the GPIO number.
The fact that the IRQ originates in a GPIO controller does not
matter.

> +  - second cell is unused.

So why do you add it? Usually this is used for trigger flags.
Are you planning to add this later, i.e. does the chip support this,
and if it doesn't then get rid of this flag.

> +- reg: I2C address of the chip.
> +
> +Device speific properties:
> +- n_latch:             optional bit-inverse of initial register value; if
> +                       you leave this initialized to zero the driver will act
> +                       like the chip was just reset.

Explain what happens if you do *not* leave it as zero and what the
bits mean in that case.

Yours,
Linus Walleij
