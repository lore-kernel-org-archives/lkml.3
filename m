Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592Ab3E2Piv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:38:51 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:62850 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab3E2Pit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:38:49 -0400
MIME-Version: 1.0
In-Reply-To: <1369412476-14245-10-git-send-email-james.hogan@imgtec.com>
References: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
	<1369412476-14245-10-git-send-email-james.hogan@imgtec.com>
Date: Wed, 29 May 2013 17:38:48 +0200
Message-ID: <CACRpkdZ0Gav0TKDXyD9MwaUrdcenV=+JV9oWNN1+ifsbO3uJ1w@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] gpio-tz1090-pdc: add TZ1090 PDC gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 6:21 PM, James Hogan <james.hogan@imgtec.com> wrote:

> Add a GPIO driver for the low-power Powerdown Controller GPIOs in the
> TZ1090 SoC.
(...)
> +  Values for gpio specifier:
> +  - GPIO number: a value in the range 0 to 6.
> +  - GPIO flags: bit field of flags:
> +      1: active low

Use #include <dt-bindings/gpio/gpio.h>
for flags and symbolic names.

> +Optional properties:
> +- gpio-ranges: Mapping to pin controller pins
> +
> +- interrupts: Individual syswake interrupts (other GPIOs cannot interrupt)
> +
> +
> +Example:
> +
> +       pdc_gpios: gpio-controller@02006500 {
> +               gpio-controller;
> +               #gpio-cells = <2>;
> +
> +               compatible = "img,tz1090-pdc-gpio";
> +               reg = <0x02006500 0x100>;
> +
> +               interrupt-parent = <&pdc>;
> +               interrupts =    <1 0 0>,        /* Syswake 0 */
> +                               <1 1 0>,        /* Syswake 1 */
> +                               <1 2 0>;        /* Syswake 2 */
> +       };

Interrupt flags seem to be undocumented here.

Apart from this it's looking nice.

Yours,
Linus Walleij
