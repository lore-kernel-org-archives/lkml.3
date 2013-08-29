Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab3H2MRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 08:17:01 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:43178 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab3H2MQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 08:16:59 -0400
MIME-Version: 1.0
In-Reply-To: <1377524753-4027-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1377524753-4027-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Thu, 29 Aug 2013 14:16:59 +0200
Message-ID: <CACRpkdZuODowd6V9WcCes6znT15C105y_kfYynhien4ZCCaoOA@mail.gmail.com>
Subject: Re: [PATCH v4] gpio: pcf857x: Add OF support
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 3:45 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:

> Add DT bindings for the pcf857x-compatible chips and parse the device
> tree node in the driver.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

First: can I get an ACK from some DT-bindings maintainer?

I think you may need to CC them all individually to get some
response.

> +++ b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> @@ -0,0 +1,71 @@
> +* PCF857x-compatible I/O expanders
> +
> +The PCF857x-compatible chips have "quasi-bidirectional" I/O pins that can be
> +driven high by a pull-up current source or driven low to ground. This combines
> +the direction and output level into a single bit per pin, which can't be read
> +back. We can't actually know at initialization time whether a pin is configured
> +(a) as output and driving the signal low/high, or (b) as input and reporting a
> +low/high value, without knowing the last value written since the chip came out
> +of reset (if any). The only reliable solution for setting up pin direction is
> +thus to do it explicitly.

Nitpick: I prefer that wrt gpio we talk about "lines" rather than "pins"
to separate it from the pin control concept. Just
s/pin/line/g

(...)
> +Optional Properties:
> +
> +  - pins-initial-state: Bitmask that specifies the initial state of each pin.
> +  When a bit is set to zero, the corresponding pin will be initialized to the
> +  input (pulled-up) state. When the  bit is set to one, the pin will be
> +  initialized the the low-level output state. If the property is not specified
> +  all pins will be initialized to the input state.

Name this lines-initial-states (pluralis).

Don't we want to do this generic if we shall do it?

Like for *any* GPIO chips we provide lines-initial state in the device
tree and some code in the gpiochip with a callback in struct gpio_chip
that can be called by the gpiolib core to set this up? Then we don't
have to reimplement this for every GPIO controller that needs it.

Sorry for not noticing this earlier...

Yours,
Linus Walleij
