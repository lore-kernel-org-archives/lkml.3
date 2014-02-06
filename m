Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbaBFNWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 08:22:42 -0500
Received: from mail.active-venture.com ([67.228.131.205]:65180 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463AbaBFNWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:22:41 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52F38CA1.8020806@roeck-us.net>
Date: Thu, 06 Feb 2014 05:22:41 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
CC: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 0/8] da9055: Driver initialisation fixes, add DT support
References: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com> <20140206005406.GC1308@roeck-us.net> <2E89032DDAA8B9408CB92943514A03376B7E368A@SW-EX-MBX02.diasemi.com>
In-Reply-To: <2E89032DDAA8B9408CB92943514A03376B7E368A@SW-EX-MBX02.diasemi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 03:46 AM, Opensource [Adam Thomson] wrote:
> On Thu, Feb 06, 2014 at 00:54:11AM +0000, Guenter Roeck wrote:
>
>> Adam,
>>
>> You don't really explain what the problem actually is. Can you elaborate ?
>
> Sorry, yes. For the conflicting device Ids, both the PMIC and the CODEC used
> the same I2C Id string, which meant if you tried to intiate both together on the
> same bus, then the second would fail.
>
> For the removal of platform_get_irq_byname(), the reason for this was that it
> was conflicting with regmap_irq_get_virq() when the IRQ value returned from
> platform_get_irq_byname() was being passed to regmap_irq_get_virq(). The result
> for the code was that it would try to request a threaded IRQ using an invalid
> IRQ number (have also described this further in patch 0004 mail thread,
> https://lkml.org/lkml/2014/2/6/126).
>
>>
>> Also, I have been using platform_get_irq() to get the interrupt resource
>> in mfd client drivers and similar situations. Wouldn't this work here as well
>> if you don't want to use platform_get_irq_byname() ?
>
> What I could've done is use platform_get_irq_byname() and avoided using
> regmap_irq_get_virq() as I would already have the correct VIRQ to pass to
> request_threaded_irq(), but I figured that using regmap_irq_get_virq() made
> more sense at the time, and was unable to use both.
>

I may be missing something, but I think the problem may be that you are
doing two mappings instead of just one. I don't think you need to call
regmap_irq_get_virq() at all.

Guenter

