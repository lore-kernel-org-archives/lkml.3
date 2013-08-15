Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab3HOVPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 17:15:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46490 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3HOVPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 17:15:32 -0400
Message-ID: <520D44C5.6080205@ti.com>
Date: Thu, 15 Aug 2013 17:14:45 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Sricharan R <r.sricharan@ti.com>, Tony Lindgren <tony@atomide.com>,
        Nishanth Menon <nm@ti.com>,
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
References: <51E83A4F.5080904@ti.com> <CACRpkdY3nQaWimTwB-Zt-8+Q_KZr8a0rpB1SUQq=AuoG4bAYnQ@mail.gmail.com> <51ED2385.60108@ti.com> <51ED5C66.1010407@ti.com> <51EFFBE1.4090505@ti.com> <51F0031B.1050307@ti.com> <51F00530.9090703@ti.com> <51F02069.3050207@ti.com> <51F0223E.4050008@ti.com> <51F0240F.3050507@ti.com> <20130813081003.GU7656@atomide.com> <520A02BA.4090805@ti.com> <CACRpkda+m82PYJsExLM6JLsLa8-bVhdvy_r_+-uKfVT2NG7Cbg@mail.gmail.com> <520D398D.9040806@ti.com> <CACRpkdYeo1y-HhftkRWgwyq8o-NVuJ978Uq+ON880LHhUxC=hg@mail.gmail.com>
In-Reply-To: <CACRpkdYeo1y-HhftkRWgwyq8o-NVuJ978Uq+ON880LHhUxC=hg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 August 2013 04:51 PM, Linus Walleij wrote:
> On Thu, Aug 15, 2013 at 10:26 PM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>> On Thursday 15 August 2013 04:01 PM, Linus Walleij wrote:
>>> On Tue, Aug 13, 2013 at 11:56 AM, Sricharan R <r.sricharan@ti.com> wrote:
>>>
>>>>  Initially irqchip was discussed, but we also have a DMA crossbar
>>>>  to map the dma-requests. Since both irq/dma crossbars should be handled,
>>>>  pinctrl was suggested as the appropriate place to handle this.
>>>
>>> I think it is better to use irqchip.
>>>
>> Did you happen to read the thread why irqchip is in-appropriate
>> for such an IP.
> 
> Sorry I don't understand what thread that is... can you point me there?
> My previous statement on this issue what this:
> http://marc.info/?l=linux-kernel&m=137442541628641&w=2
> 
It was discussed in couple of threads but the main point was the
need of a link needed for the irqchip.

>> As I said earlier, an IRQ-chip always need a
>> real IRQ link (even for the chained one) to the primary irqchip.
>>
>> This IP is just dummy IP makes the connections for the primary
>> irqchip(read GIC). And its use only limited to make the
>> connection between the peripheral IRQ event to the GIC IRQ line.
>>
>> I don't see how you can make this happen with an irqchip
>> infrastructure.
> 
> I think my post above describes this.
> 
Sorry for being dumb but I don't think cascaded irqchip examples
like GPIO and cross-bars are same. If you take an example of
GPIO irqchip, it always have a physical connection even if it
is 1 IRQ line for (32 logical/sparse IRQs). That goes with
other MFD examples too.

So may be I am still missing something in your proposal.

>>> I don't see any way to really abstract this pretty simple crossbar
>>> for reuse across subsystems.
>>>
>> This exactly the reason, i am against idea of over-engineering the
>> simple IP whose only job is to make the physical wire connection
>> in software where as this is generally done in RTL by default on
>> most of the SOCs.
> 
> Well, it was made accessible by software, and if someone has a
> usecase that requires this do be done dynamically, i.e. not just
> being set up by firmware and never touched, and that use case
> is valid, then I guess we need to do something...
> 
> I think it was mentioned in the thread that there is really such
> a usecase?
> 
Actually there is no practical usecase but one but one can manufacture
it ;-)

