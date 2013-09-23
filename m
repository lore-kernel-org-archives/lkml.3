Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab3IWQcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:32:23 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58877 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab3IWQcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:32:20 -0400
Message-ID: <52406CF6.3040807@collabora.co.uk>
Date: Mon, 23 Sep 2013 18:31:50 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jon Hunter <jgchunter@gmail.com>, linux-gpio@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] gpio/omap: auto-setup a GPIO when used as an IRQ
References: <1379860848-29020-1-git-send-email-javier.martinez@collabora.co.uk> <524068D4.5040909@wwwdotorg.org>
In-Reply-To: <524068D4.5040909@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 06:14 PM, Stephen Warren wrote:
> On 09/22/2013 08:40 AM, Javier Martinez Canillas wrote:
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
>> 
>> Some drivers know that their IRQ line is being driven by a GPIO
>> and use a similar sequence as the described above but others are
>> not aware or don't care wether their IRQ is a real line from an
>> interrupt controller or a GPIO pin acting as an IRQ.
>> ...
> 
> I think that explanation is a bit like retro-actively implying that
> drivers /should/ be aware of whether their IRQ is a GPIO or not, and
> should be acting differently. However, they should not.
>

I know the patch description is rather verbose but since we have been discussing
this a lot and people have different opinions I wanted to explain some context
and the motivation for the patch.

> I would much rather see a simpler patch description along the lines of:
> 
> The OMAP GPIO controller HW requires that a pin be configured in GPIO
> mode in order to operate as an interrupt input. Since drivers should not
> be aware of whether an interrupt pin is also a GPIO or not, the HW
> should be fully configured/enabled as an IRQ if a driver solely uses IRQ
> APIs such as request_irq, and never calls any GPIO-related APIs. As
> such, add the missing HW setup to the OMAP GPIO controller's irq_chip
> driver.
> 

Thanks for the suggestion, I'll use something like that when I do a proper post
as a PATCH and not RFC.

> The code change looks like it does what I would expect though.
> 

Great, let's see what is the feedback from Santosh and Kevin about the
implementation since they are the maintainers of this driver.

I really hope we can find a solution to this long standing issue.

Thanks a lot and best regards,
Javier
