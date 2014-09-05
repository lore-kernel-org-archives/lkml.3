Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaIEVPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:15:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37574 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaIEVPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:15:48 -0400
Message-ID: <540A27DC.4010206@gmail.com>
Date: Fri, 05 Sep 2014 14:15:08 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Mark Rutland <mark.rutland@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] Documentation: bcm7120-l2: Add Broadcom BCM7120-style
 L2 binding
References: <1409265326-7579-1-git-send-email-f.fainelli@gmail.com> <1409265326-7579-3-git-send-email-f.fainelli@gmail.com> <alpine.DEB.2.10.1409031410580.3333@nanos> <20140903124317.GB3127@leverpostej> <5407490E.7060505@gmail.com> <20140905090528.GG2172@leverpostej> <5409FA82.6000703@gmail.com> <alpine.DEB.2.10.1409052113210.5472@nanos> <540A15AA.4000805@gmail.com> <alpine.DEB.2.10.1409052224211.5472@nanos>
In-Reply-To: <alpine.DEB.2.10.1409052224211.5472@nanos>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 01:44 PM, Thomas Gleixner wrote:
> On Fri, 5 Sep 2014, Florian Fainelli wrote:
>> On 09/05/2014 12:21 PM, Thomas Gleixner wrote:
>>> So if I understand correctly what you have is:
>>>
>>>                           /- GIC------------->   
>>>  Device-irq ---- [routing]
>>>                           \- BC irq chip ---->
>>>
>>> and you implement it as
>>>
>>>  Device-irq ---- [BC irq chip] ---- [GIC] --->
>>>                             |
>>>                             ----------------->
>>>
>>> And the fwd mask is to tell the BC chip to use the GIC and which irq
>>> of the GIC, so it can fiddle with the GIC under the hood, right?
>>
>> The forward mask really is to tell the BCM7120 l2 interrupt controller:
>> bypass me, and output the UART interrupts directly at the GIC level, so
>> I think this does match your understanding.
>>
>> Not setting the forward mask means you would get the UART interrupts at
>> the BCM7120 l2 interrupt controller level, and have to handle them here.
>>
>> Hope this helps clarify what this funky piece of hardware does.
> 
> Sigh, this stacked interrupt chip nonsense is becoming a plague.

This is a HW design that we inherited, but fortunately we might be able
to fix that in the future.

> 
> So if you set that bit then the UART driver only sees the GIC as its
> interrupt controller and not the L2 thingy. So, the L2 chip only
> enables its interrupt unconditionally for that line and the
> enable/disable happens at the GIC level.

Exactly, this is completely transparent for the UART and the GIC.

> 
> If that's the case, that's fine with me. It's not pretty, but at least
> it does not involve L2 fiddling indirectly with the GIC.

Absolutely, we do not have to do the arch_gic_extn thingy.

Thanks for your feedback!
--
Florian
