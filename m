Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab3HWTsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:48:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50354 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab3HWTss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:48:48 -0400
Message-ID: <5217BC9B.4060906@wwwdotorg.org>
Date: Fri, 23 Aug 2013 13:48:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lars Poeschel <poeschel@lemonage.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, galak@codeaurora.org,
        Pawel Moll <pawel.moll@arm.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de> <CACRpkdYUeyVZcN1-jOzg0zo4eSJK1S+M5fJ0FcMsgwaPKW4Obw@mail.gmail.com> <52167E5D.6060802@wwwdotorg.org> <201308231140.44923.poeschel@lemonage.de>
In-Reply-To: <201308231140.44923.poeschel@lemonage.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 03:40 AM, Lars Poeschel wrote:
> On Thursday 22 August 2013 at 23:10:53, Stephen Warren wrote:
>> On 08/21/2013 05:36 PM, Linus Walleij wrote:
>>> On Thu, Aug 22, 2013 at 1:10 AM, Stephen Warren
>>> <swarren@wwwdotorg.org> wrote: [Me]
>>>
>>>>>> check if these in turn reference the interrupt-controller, and
>>>>>> if they do, loop over the interrupts used by that child and
>>>>>> perform gpio_request() and gpio_direction_input() on these,
>>>>>> making them unreachable from the GPIO side.
>>>>
>>>> What about bindings that require a GPIO to be specified, yet don't
>>>> allow an IRQ to be specified, and the driver internally does perform
>>>> gpio_to_irq() on it? I don't think one can detect that case.
>>>
>>> This is still allowed. Consumers that prefer to have a GPIO
>>> passed and convert it to IRQ by that call can still do so,
>>> they will know what they're doing and will not cause the
>>> double-command situation that we're trying to solve.
>>
>> Why not? There are certainly drivers in the kernel which request a GPIO
>> as both a GPIO and as an (dual-edge) interrupt, so that they can read
>> the GPIO input whenever the IRQ goes off, in order to determine the pin
>> state. This is safer against high-latency or lost interrupts.
> 
> This is the point! They REQUEST the GPIO. They can then do whatever they 
> like with this GPIO then, even additionally use it as interrupt.
> In the devicetree case the interrupts are not requested. This is what we 
> are trying to address with the patch. The device using this interrupt has 
> no idea where this interrupt comes from. Is it a gpio-interrupt or not? 
> Does it have to request a gpio before using this interrupt or not?

If the kernel automatically requests the GPIO because it's referenced as
an interrupt then surely if the driver also requests it, then it will
fail, because the GPIO is already requested. Or, is there an explicit
check for that?

Is the problem you're trying to solve really an actual problem? I'm not
convinced it's necessary for the GPIO to show up as requested if the pin
is used as an IRQ input?
