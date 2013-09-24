Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750818Ab3IXFlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 01:41:46 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:59797 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab3IXFlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 01:41:45 -0400
Message-ID: <524125F4.4060608@collabora.co.uk>
Date: Tue, 24 Sep 2013 07:41:08 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jon Hunter <jgchunter@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] gpio/omap: auto-setup a GPIO when used as an IRQ
References: <1379860848-29020-1-git-send-email-javier.martinez@collabora.co.uk> <CACRpkdb35DouKsZ+9aWfQmER1vmAaK1dR7VXjoFHTLRR+hBezg@mail.gmail.com>
In-Reply-To: <CACRpkdb35DouKsZ+9aWfQmER1vmAaK1dR7VXjoFHTLRR+hBezg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 10:15 PM, Linus Walleij wrote:
> On Sun, Sep 22, 2013 at 4:40 PM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
> 
>> To use a GPIO pin as an interrupt line, two previous configurations
>> have to be made:
>>
>> a) Map the GPIO pin as an interrupt line into the Linux irq space
>> b) Enable the GPIO bank and configure the GPIO direction as input
>>
>> Most GPIO/IRQ chip drivers just create a mapping for every single
>> GPIO pin with irq_create_mapping() on .probe so users usually can
>> assume a) and only have to do b) by using the following sequence:
>>
>> gpio_request(gpio, "foo IRQ");
>> gpio_direction_input(gpio);
>>
>> and then request a IRQ with:
>>
>> irq = gpio_to_irq(gpio);
>> request_irq(irq, ...);
> 
> I guess I have to live with this approach, but I'd like to - if possible -
> address my pet issue.
> 
> - It is OK that the HW get set up as GPIO input by the IRQ
>   request function alone. (Through gpio_irq_type I guess).
> 

Yes, this is how is made on this patch indeed.

> - When a second caller calls omap_gpio_request() it should
>   be OK as well, but only if the flags corresponds to the
>   previously enabled input mode. Else it should be
>   disallowed.
> 
> - The same should happen for _set_gpio_direction() if a pin
>   previously set up for IRQ gets a request to be used as
>   output.
> 
> If this cannot be tracked in the driver, it is certainly a candidate
> for something that gpiolib should be doing. And then I'm open to
> solutions to how we can do that.
> 

Ok, this can be tracked in the driver, will add it when posting v2 soon.

> If this needs to be applied pronto to fix the regression I'm
> happy with that too, if we add a big boilerplate stating the above
> problem and that it needs to be *fixed* at some point.
> 
> But in either case I want this to be tested on OMAP1 before
> I apply it, as in a Tested-by tag.
>

Agreed. Even though this is a fix for a long standing issue I prefer it to be
tested extensively than applying the patch in a rush just to learn that causes
regressions and have to be reverted as it happens last time.

So as you said let's wait until we have a few Tested-by tags by people using
different OMAP platforms specially OMAP1.

> Yours,
> Linus Walleij
> 

Thanks a lot and best regards,
Javier

