Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab3IBJrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:47:36 -0400
Received: from smtp1.goneo.de ([212.90.139.80]:45914 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306Ab3IBJrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:47:32 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.719
From: Lars Poeschel <poeschel@lemonage.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
Date: Mon, 02 Sep 2013 11:43:26 +0200
Message-ID: <1414118.3oldKCk0TC@lem-wkst-02>
User-Agent: KMail/4.10.5 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5220FBC9.1070602@wwwdotorg.org>
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de> <CACRpkdYz7Kn-y8LHpNBV3YyYFhyaU6N592BJE1newUZJpUMNfA@mail.gmail.com> <5220FBC9.1070602@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 30. August 2013, 14:08:41 schrieb Stephen Warren:
> On 08/29/2013 01:00 PM, Linus Walleij wrote:
> > On Fri, Aug 23, 2013 at 9:52 PM, Stephen Warren <swarren@wwwdotorg.org> 
wrote:
> >> On 08/23/2013 12:45 PM, Linus Walleij wrote:
> >>> This is a perfectly OK thing to do as long as it is done like
> >>> this:
> >>> 
> >>> request_gpio(gpio);
> >>> gpio_direction_input(gpio);
> >>> request_irq(gpio_to_irq(gpio));
> >> 
> >> But I'm not aware that there's a rule saying it's illegal to:
> >> 
> >> request_irq(gpio_to_irq(gpio));
> >> request_gpio(gpio);
> >> gpio_direction_input(gpio);
> > 
> > No but I think there should be one ... maybe I'm an oddball
> > but it seems natural to request a GPIO before tying
> > IRQs to fire off it.
> 
> What if there is no GPIO?

If there is no GPIO there is no gpio-controller and there is no problem.

> There are plenty of chips with dedicated IRQ input pins that can't be
> read as GPIOs, or treated as GPIOs in any way.
> 
> If a driver only needs IRQ input functionality, it should just request
> an IRQ and be done with it. There should be no need at all for the
> driver to know that the IRQ might be routed into a GPIO controller, and
> hence that the driver may (or may not) need to additionally request the
> GPIO before requesting the IRQ.

Yes, you're right, but reality is different. Legacy drivers / board-files do:

request_gpio(gpio);
gpio_direction_input(gpio);
request_irq(gpio_to_irq(gpio));
 
> In other words, request_irq() must do everything necessary for the input
> signal to operate as an IRQ input, irrespective of whether it might be
> possible to use that input signal as a GPIO.

