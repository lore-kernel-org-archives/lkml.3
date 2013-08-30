Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3H3AET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 20:04:19 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:57539 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3H3AES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 20:04:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v4] gpio: pcf857x: Add OF support
Date: Fri, 30 Aug 2013 02:05:41 +0200
Message-ID: <32047086.JjfkHtWF69@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CACRpkdZuODowd6V9WcCes6znT15C105y_kfYynhien4ZCCaoOA@mail.gmail.com>
References: <1377524753-4027-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CACRpkdZuODowd6V9WcCes6znT15C105y_kfYynhien4ZCCaoOA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thursday 29 August 2013 14:16:59 Linus Walleij wrote:
> On Mon, Aug 26, 2013 at 3:45 PM, Laurent Pinchart wrote:
> > Add DT bindings for the pcf857x-compatible chips and parse the device
> > tree node in the driver.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> First: can I get an ACK from some DT-bindings maintainer?
> 
> I think you may need to CC them all individually to get some response.

I'll make sure to get an ACK for v6 (or a more recent version). Reviewers are 
probably busy with the merge window about to open, delaying this patch to 
v3.13 should help.

I'll post v6 after receiving your answer to the comment below, as well as to 
the issue raised by Tomasz on v5.

> > +++ b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> > @@ -0,0 +1,71 @@
> > +* PCF857x-compatible I/O expanders
> > +
> > +The PCF857x-compatible chips have "quasi-bidirectional" I/O pins that can
> > be +driven high by a pull-up current source or driven low to ground. This
> > combines +the direction and output level into a single bit per pin, which
> > can't be read +back. We can't actually know at initialization time
> > whether a pin is configured +(a) as output and driving the signal
> > low/high, or (b) as input and reporting a +low/high value, without
> > knowing the last value written since the chip came out +of reset (if
> > any). The only reliable solution for setting up pin direction is +thus to
> > do it explicitly.
> 
> Nitpick: I prefer that wrt gpio we talk about "lines" rather than "pins"
> to separate it from the pin control concept. Just
> s/pin/line/g

OK.

> (...)
> 
> > +Optional Properties:
> > +
> > +  - pins-initial-state: Bitmask that specifies the initial state of each
> > pin. +  When a bit is set to zero, the corresponding pin will be
> > initialized to the +  input (pulled-up) state. When the  bit is set to
> > one, the pin will be +  initialized the the low-level output state. If
> > the property is not specified +  all pins will be initialized to the
> > input state.
> 
> Name this lines-initial-states (pluralis).

OK.

> Don't we want to do this generic if we shall do it?
> 
> Like for *any* GPIO chips we provide lines-initial state in the device
> tree and some code in the gpiochip with a callback in struct gpio_chip
> that can be called by the gpiolib core to set this up? Then we don't
> have to reimplement this for every GPIO controller that needs it.

Most GPIO chips will provide a way to read back the current state. The initial 
state only needs to be provided for write-only chips. This is (luckily) rather 
an exception, so I don't think we should implement it in the core, at least 
not yet. We can always refactor the code later if needed, the proposed DT 
binding is generic enough.

> Sorry for not noticing this earlier...

No worries.

-- 
Regards,

Laurent Pinchart

