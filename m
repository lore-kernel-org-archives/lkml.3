Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3F0KIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:08:42 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:48569 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab3F0KIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:08:41 -0400
MIME-Version: 1.0
In-Reply-To: <51CA08A2.4030204@wwwdotorg.org>
References: <1372169952-22439-1-git-send-email-linus.walleij@stericsson.com>
	<51CA08A2.4030204@wwwdotorg.org>
Date: Thu, 27 Jun 2013 12:08:40 +0200
Message-ID: <CACRpkdZJ3oP9ARDhwZ1h8CkFXpDTznPChLiSgivTYKGDkWbOZA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: elaborate a bit on arrangements in doc
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>, Tony Lindgren <tony@atomide.com>,
        Rob Landley <rob@landley.net>,
        Christian Ruppert <christian.ruppert@abilis.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 11:16 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/25/2013 08:19 AM, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> This elaborates a bit on the pinctrl vs GPIO arangements
>> in the hardware.
>>
>> Inspired by some drawings in a mail from Christian
>> Ruppert.
(...)
> I'm not really sure quite what these diagrams are attempting to convey
> within the context of this document.

I am trying to help pinctrl kernel developers understand hardware
terminology.

>> +In (A) the GPIO-like functionality of the pin is *always* available.
>
> Well, that can't really be true.
>
> It may be possible that you can always read the physical pin's value via
> a GPIO input register.
>
> However, you obviously can't always write to a GPIO output register to
> set the pin's value. If you could, the pin would simply be a GPIO, and
> never serve any other function.

This is possible on the U300. What happens in practice is
that what you send out on the output from e.g. the I2C block is
OR:ed with the GPIO output, so if that is not zero, you jam it to 1.

> If you're saying that it's always possible to put the pin into a mode
> where you can use the GPIO output register to driver the pin value, well
> then that's just regular pin-muxing, so I'm not sure why it's worth
> mentioning.

That's not really the case. It can drive the pin at the same time.

> In (a) there are really two levels of pinmux configuration, one in the
> GPIO HW block (GPIO-vs-whatever-pinctrl-selects).
>
> In (b) there is another level of pinmux configuration; some block has to
> exist between the physical pins and both GPIO/pinctrl HW modules; it
> simply isn't drawn in the diagram

I've redrawn these a bit to reflect the cases I know exist.
Check the v2 patch.

> In all cases though, this is just attempting to enumerate different HW
> designs for pin-muxing I think. Isn't it better to just let each SoC's
> datasheet specify exactly how things are hooked up?

The intention of this is to understand the datasheet from a kernel
point of view.

Yours,
Linus Walleij
