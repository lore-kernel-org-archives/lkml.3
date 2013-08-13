Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab3HMJ44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:56:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60288 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594Ab3HMJ4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:56:54 -0400
Message-ID: <520A02BA.4090805@ti.com>
Date: Tue, 13 Aug 2013 15:26:10 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>, Nishanth Menon <nm@ti.com>,
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

Hi Tony,

On Tuesday 13 August 2013 01:40 PM, Tony Lindgren wrote:
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
> Sorry for the delay on this, I think the best way to set this up
> is as a separate drivers/irqchip controller. Then just map the
> configured interrupts for the board with interrupt-map and
> interrupt-map-mask binding. No need to stuff all the SoC specific
> maps to the .dts, just the ones used for the board.
>
> Regards,
>
> Tony
>  
 Initially irqchip was discussed, but we also have a DMA crossbar
 to map the dma-requests. Since both irq/dma crossbars should be handled,
 pinctrl was suggested as the appropriate place to handle this.

Regards,
 Sricharan
