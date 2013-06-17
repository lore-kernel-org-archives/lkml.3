Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab3FQIMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:12:50 -0400
Received: from mail.abilis.ch ([195.70.19.74]:12998 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab3FQIMp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:12:45 -0400
Date: Mon, 17 Jun 2013 10:11:58 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: update GPIO range doc
Message-ID: <20130617081158.GA19380@ab42.lan>
References: <1371377909-5921-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1371377909-5921-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 12:18:29PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This updates the GPIO range documentation with the API changes
> for sparse/random/arbitrary pin-to-GPIO mappings.

Oops, sorry, I should have thought of updating this with my previous
patch. Thanks for stepping in.

Reviewed-by: Christian Ruppert <christian.ruppert@abilis.com>

> Cc: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  Documentation/pinctrl.txt | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index f6e664b..4548743 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt
> @@ -350,6 +350,23 @@ chip b:
>   - GPIO range : [48 .. 55]
>   - pin range  : [64 .. 71]
>  
> +The above examples assume the mapping between the GPIOs and pins is
> +linear. If the mapping is sparse or haphazard, an array of arbitrary pin
> +numbers can be encoded in the range like this:
> +
> +static const unsigned range_pins[] = { 14, 1, 22, 17, 10, 8, 6, 2 };
> +
> +static struct pinctrl_gpio_range gpio_range = {
> +	.name = "chip",
> +	.id = 0,
> +	.base = 32,
> +	.pins = &range_pins,
> +	.npins = ARRAY_SIZE(range_pins),
> +	.gc = &chip;
> +};
> +
> +In this case the pin_base property will be ignored.
> +
>  When GPIO-specific functions in the pin control subsystem are called, these
>  ranges will be used to look up the appropriate pin controller by inspecting
>  and matching the pin to the pin ranges across all controllers. When a
> @@ -357,9 +374,9 @@ pin controller handling the matching range is found, GPIO-specific functions
>  will be called on that specific pin controller.
>  
>  For all functionalities dealing with pin biasing, pin muxing etc, the pin
> -controller subsystem will subtract the range's .base offset from the passed
> -in gpio number, and add the ranges's .pin_base offset to retrive a pin number.
> -After that, the subsystem passes it on to the pin control driver, so the driver
> +controller subsystem will look up the corresponding pin number from the passed
> +in gpio number, and use the ranges internals to retrive a pin number. After
> +that, the subsystem passes it on to the pin control driver, so the driver
>  will get an pin number into its handled number range. Further it is also passed
>  the range ID value, so that the pin controller knows which range it should
>  deal with.
> @@ -368,6 +385,7 @@ Calling pinctrl_add_gpio_range from pinctrl driver is DEPRECATED. Please see
>  section 2.1 of Documentation/devicetree/bindings/gpio/gpio.txt on how to bind
>  pinctrl and gpio drivers.
>  
> +
>  PINMUX interfaces
>  =================
>  
> -- 
> 1.7.11.3
> 

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
