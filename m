Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3HWSpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:45:52 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:43364 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab3HWSpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:45:50 -0400
MIME-Version: 1.0
In-Reply-To: <52167E5D.6060802@wwwdotorg.org>
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de>
	<1507189.CRWvzVJqTV@flatron>
	<521548E3.6010703@wwwdotorg.org>
	<CACRpkdYUeyVZcN1-jOzg0zo4eSJK1S+M5fJ0FcMsgwaPKW4Obw@mail.gmail.com>
	<52167E5D.6060802@wwwdotorg.org>
Date: Fri, 23 Aug 2013 20:45:49 +0200
Message-ID: <CACRpkdZgFMH07_W2eUWsgsUMXAJA1paEimAds=-XeViZaYySLA@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Lars Poeschel <poeschel@lemonage.de>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 11:10 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/21/2013 05:36 PM, Linus Walleij wrote:
>> On Thu, Aug 22, 2013 at 1:10 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> [Me]
>>>>> check if these in turn reference the interrupt-controller, and
>>>>> if they do, loop over the interrupts used by that child and
>>>>> perform gpio_request() and gpio_direction_input() on these,
>>>>> making them unreachable from the GPIO side.
>>>
>>> What about bindings that require a GPIO to be specified, yet don't allow
>>> an IRQ to be specified, and the driver internally does perform
>>> gpio_to_irq() on it? I don't think one can detect that case.
>>
>> This is still allowed. Consumers that prefer to have a GPIO
>> passed and convert it to IRQ by that call can still do so,
>> they will know what they're doing and will not cause the
>> double-command situation that we're trying to solve.
>
> Why not? There are certainly drivers in the kernel which request a GPIO
> as both a GPIO and as an (dual-edge) interrupt, so that they can read
> the GPIO input whenever the IRQ goes off, in order to determine the pin
> state. This is safer against high-latency or lost interrupts.

Yes? Are we talking past each other here?

This is a perfectly OK thing to do as long as it is done like
this:

request_gpio(gpio);
gpio_direction_input(gpio);
request_irq(gpio_to_irq(gpio));

Pass only the GPIO in the device tree and this works just fine.

The use case after that we do not interfer with.

Yours,
Linus Walleij
