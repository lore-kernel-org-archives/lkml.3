Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab3HMN2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:28:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40384 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955Ab3HMN2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:28:42 -0400
Message-ID: <520A3464.10406@ti.com>
Date: Tue, 13 Aug 2013 09:28:04 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Nishanth Menon <nm@ti.com>, Sricharan R <r.sricharan@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, Felipe Balbi <balbi@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/3] misc: Add crossbar driver
References: <51E83A4F.5080904@ti.com> <CACRpkdY3nQaWimTwB-Zt-8+Q_KZr8a0rpB1SUQq=AuoG4bAYnQ@mail.gmail.com> <51ED2385.60108@ti.com> <51ED5C66.1010407@ti.com> <51EFFBE1.4090505@ti.com> <51F0031B.1050307@ti.com> <51F00530.9090703@ti.com> <51F02069.3050207@ti.com> <51F0223E.4050008@ti.com> <51F0240F.3050507@ti.com> <20130813081003.GU7656@atomide.com>
In-Reply-To: <20130813081003.GU7656@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 August 2013 04:10 AM, Tony Lindgren wrote:
> * Santosh Shilimkar <santosh.shilimkar@ti.com> [130724 12:06]:
>> On Wednesday 24 July 2013 02:51 PM, Nishanth Menon wrote:
>>> On 07/24/2013 01:43 PM, Sricharan R wrote:
>>>> On Wednesday 24 July 2013 10:17 PM, Nishanth Menon wrote:
>>>>> On 07/24/2013 11:38 AM, Santosh Shilimkar wrote:
>>>>>> On Wednesday 24 July 2013 12:08 PM, Nishanth Menon wrote:
>>>>>>> That said, maybe a intermediate pinctrl approach might be more pragmatic and less theoretically flexible.
>>>>>>> an option might be to "statically allocate" default number of interrupts to a domain - example:
>>>>>>> * GIC IRQ 72->78 allotted to UARTs
>>>>>>> * pinctrl mapping provided for those but only 6 can be used (rest are marked status="disabled" as default) at any given time (choice of pinctrl option determines GIC interrupt line to use)
>>>>>>> * All modules will have a pinctrl definition to have a mapping - to avoid bootloader overriding default cross bar setting in ways un-expected by kernel.
>>>>>>>
>>>>>>> Does that sound fair trade off?
>>>>>> This sounds better. That way we can get all the devices in the DT at least.
>>>>>
>>>>> Fair enough - if Linus and Tony are still ok with this approach to the problem, seeing a patch series with the effect would be beneficial.
>>>>>
>>>>   Ok, i will use this idea of certain number interrupts to groups.
>>>> Yes on DRA7XX, we have about 160 gic lines and 320 irq crossbar device inputs contending for it.
>>>> 1:2 and fully arbitrary.  But will we be really exhausting them ?
>>>>
>>> Depends on how we allocate :). The default arbitary allocation can be made more logical in your series ofcourse :).
>>>
>> I would just most logical peripherals rather than providing every single
>> IP connected to cross bar. Otherwise we will end up wth hwmod like
>> scenario where now started removing the unused stuff because of
>> maintenance and loc issues ;-)
> 
> Sorry for the delay on this, I think the best way to set this up
> is as a separate drivers/irqchip controller. Then just map the
> configured interrupts for the board with interrupt-map and
> interrupt-map-mask binding. No need to stuff all the SoC specific
> maps to the .dts, just the ones used for the board.
> 
Interrupt mask/unmask, really ? Thats like abusing those irqchip
hooks completely. Your point is to just setup events which we need
and thats what I also suggested. But the use of irqchip hooks is
certainly not the right idea since they are for masking/unmasking
interrupts in running system and not for joining the interrupt
line which needs to happen once during probe.

Regards,
Santosh

