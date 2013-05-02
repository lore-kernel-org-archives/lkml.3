Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab3EBTjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:39:31 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:61266 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab3EBTj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:39:29 -0400
Message-ID: <5182C0EC.7040008@gmail.com>
Date: Thu, 02 May 2013 21:39:24 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irqchip: add support for Marvell Orion SoCs
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130502185322.GA29333@obsidianresearch.com> <201305022111.41043.arnd@arndb.de> <5182BFC6.3070709@gmail.com>
In-Reply-To: <5182BFC6.3070709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 09:34 PM, Sebastian Hesselbarth wrote:
> On 05/02/2013 09:11 PM, Arnd Bergmann wrote:
>> On Thursday 02 May 2013, Jason Gunthorpe wrote:
>>>> +static struct of_device_id orion_irq_dt_ids[] __initconst = {
>>>> + { .compatible = "marvell,orion-mpic", .data = orion_of_init },
>>>> + { }
>>>
>>> Is there a strong reason to change the compatible string? Looks to me
>>> like either the new driver or the old driver will bind depending on
>>> what is in the machine description. No need for a new string?
>>>
>>
>> The compatible string should change if the binding changes in an
>> incomptible way, and we should try not to change it unless it's
>> fundamentally flawed.
>
> Well, there is no _fundamental_ change in the binding syntax as it
> is only reg, interrupts, and clocks. But there is a semantic change
> in reg properties, as current orion irq controller wants the mask
> registers (0x04,0x08) only while this also needs cause register
> (0x00).
>
> Nothing that couldn't be handled while moving Orion arch to irqchip
> but if there are no further objections, I'd like to stick with the new
> compatible string - also having orion-spic in mind.

Taking Jason Gunthorpe's last reply, I will stick to the _old_
compatible string and name the bridge irq handler as Jason suggested.

I will send a v2 soon.

Sebastian
