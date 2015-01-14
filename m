Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbbANKBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 05:01:52 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:35242 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbbANKBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 05:01:49 -0500
MIME-Version: 1.0
In-Reply-To: <1419409345-8297-2-git-send-email-thloh@altera.com>
References: <1419409345-8297-1-git-send-email-thloh@altera.com>
	<1419409345-8297-2-git-send-email-thloh@altera.com>
Date: Wed, 14 Jan 2015 11:01:49 +0100
Message-ID: <CACRpkdZue+9v2+9wfdOqZhh5rEyxCqy6BMVmADW+qkNZNi2pKw@mail.gmail.com>
Subject: Re: [PATCH v8 1/2] drivers/gpio: Altera soft IP GPIO driver device
 tree binding
From: Linus Walleij <linus.walleij@linaro.org>
To: Tien Hock Loh <thloh@altera.com>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 9:22 AM,  <thloh@altera.com> wrote:

> From: Tien Hock Loh <thloh@altera.com>
>
> Adds a new driver device tree binding for Altera soft GPIO IP
>
> Signed-off-by: Tien Hock Loh <thloh@altera.com>
> ---
>  .../devicetree/bindings/gpio/gpio-altera.txt       |   43 ++++++++++++++++++++
>  1 files changed, 43 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-altera.txt
>
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-altera.txt b/Documentation/devicetree/bindings/gpio/gpio-altera.txt
> new file mode 100644
> index 0000000..649fa02
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-altera.txt
> @@ -0,0 +1,43 @@
> +Altera GPIO controller bindings
> +
> +Required properties:
> +- compatible:
> +  - "altr,pio-1.0"
> +- reg: Physical base address and length of the controller's registers.
> +- #gpio-cells : Should be 2

Yeah.

> +  - The first cell is the gpio offset number.
> +  - The second cell is reserved and is currently unused.
> +- gpio-controller : Marks the device node as a GPIO controller.
> +- interrupt-controller: Mark the device node as an interrupt controller
> +- #interrupt-cells : Should be 1. The interrupt type is fixed in the hardware.
> +  - The first cell is the GPIO offset number within the GPIO controller.
> +- interrupts: Specify the interrupt.
> +- altr,interrupt-trigger: Specifies the interrupt trigger type the GPIO
> +  hardware is synthesized. This field is required if the Altera GPIO controller
> +  used has IRQ enabled as the interrupt type is not software controlled,
> +  but hardware synthesized. Required if GPIO is used as an interrupt
> +  controller. The value is defined in <dt-bindings/interrupt-controller/irq.h>
> +  Only the following flags are supported:
> +    IRQ_TYPE_EDGE_RISING
> +    IRQ_TYPE_EDGE_FALLING
> +    IRQ_TYPE_EDGE_BOTH
> +    IRQ_TYPE_LEVEL_HIGH
> +
> +Optional properties:
> +- altr,ngpio: Width of the GPIO bank. This defines how many pins the
> +  GPIO device has. Ranges between 1-32. Optional and defaults to 32 is not
> +  specified.
> +
> +Example:
> +
> +gpio_altr: gpio@0xff200000 {
> +       compatible = "altr,pio-1.0";
> +       reg = <0xff200000 0x10>;
> +       interrupts = <0 45 4>;
> +       altr,ngpio = <32>;
> +       altr,interrupt_trigger = <IRQ_TYPE_EDGE_RISING>;
> +       #gpio-cells = <1>;

So why is there one cell in the example?

I know the second cell will describe the interrupt type that is
anyway hardcoded but yeah, I guess it is best to work
like all other controllers.

If you actually want it onecell that is fine too.

Yours,
Linus Walleij
