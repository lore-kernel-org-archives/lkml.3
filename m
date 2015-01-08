Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbbAHBqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:46:03 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46987 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbbAHBp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:45:59 -0500
MIME-Version: 1.0
In-Reply-To: <1420621722-7428-4-git-send-email-oliver+list@schinagl.nl>
References: <1420621722-7428-1-git-send-email-oliver+list@schinagl.nl> <1420621722-7428-4-git-send-email-oliver+list@schinagl.nl>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 7 Jan 2015 19:45:37 -0600
Message-ID: <CAL_JsqL_bkn3xUQfn2yt96O29yJwVeLjbkm+cDJTge0JwA9YkQ@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] leds: Let the binding document example for
 leds-gpio follow the gpio bindings
To: Olliver Schinagl <oliver+list@schinagl.nl>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Olliver Schinagl <oliver@schinagl.nl>,
        Robin Gong <b38343@freescale.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Alexander Shiyan <shc_work@mail.ru>,
        Jingoo Han <jg1.han@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        linux-leds@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 3:08 AM, Olliver Schinagl
<oliver+list@schinagl.nl> wrote:
> From: Olliver Schinagl <oliver@schinagl.nl>
>
> In the gpio bindings documents it is requested to use the marco's in
> include/dt-bindings/gpio/gpio.h whenever possible. The gpios in the led
> drivers don't seem to form an exception, so update the example in the
> document bindings.
>
> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>

The example isn't exactly wrong, so I'd question how much this is
really needed, but:

Acked-by: Rob Herring <robh@kernel.org>

> ---
>  Documentation/devicetree/bindings/leds/leds-gpio.txt | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/leds/leds-gpio.txt b/Documentation/devicetree/bindings/leds/leds-gpio.txt
> index f77148f..d544cf1 100644
> --- a/Documentation/devicetree/bindings/leds/leds-gpio.txt
> +++ b/Documentation/devicetree/bindings/leds/leds-gpio.txt
> @@ -26,16 +26,18 @@ LED sub-node properties:
>
>  Examples:
>
> +#include <dt-bindings/gpio/gpio.h>
> +
>  leds {
>         compatible = "gpio-leds";
>         hdd {
>                 label = "IDE Activity";
> -               gpios = <&mcu_pio 0 1>; /* Active low */
> +               gpios = <&mcu_pio 0 GPIO_ACTIVE_LOW>;
>                 linux,default-trigger = "ide-disk";
>         };
>
>         fault {
> -               gpios = <&mcu_pio 1 0>;
> +               gpios = <&mcu_pio 1 GPIO_ACTIVE_HIGH>;
>                 /* Keep LED on if BIOS detected hardware fault */
>                 default-state = "keep";
>         };
> @@ -44,11 +46,11 @@ leds {
>  run-control {
>         compatible = "gpio-leds";
>         red {
> -               gpios = <&mpc8572 6 0>;
> +               gpios = <&mpc8572 6 GPIO_ACTIVE_HIHG>;
>                 default-state = "off";
>         };
>         green {
> -               gpios = <&mpc8572 7 0>;
> +               gpios = <&mpc8572 7 GPIO_ACTIVE_HIGH>;
>                 default-state = "on";
>         };
>  };
> @@ -57,7 +59,7 @@ leds {
>         compatible = "gpio-leds";
>
>         charger-led {
> -               gpios = <&gpio1 2 0>;
> +               gpios = <&gpio1 2 GPIO_ACTIVE_HIGH>;
>                 linux,default-trigger = "max8903-charger-charging";
>                 retain-state-suspended;
>         };
> --
> 2.1.4
>
