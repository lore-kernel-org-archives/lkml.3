Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3HMIKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 04:10:18 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55282 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750929Ab3HMIKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 04:10:09 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ET9G2ERaRQC6CsezgR7pR
Date: Tue, 13 Aug 2013 01:10:03 -0700
From: Tony Lindgren <tony@atomide.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Nishanth Menon <nm@ti.com>, Sricharan R <r.sricharan@ti.com>,
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
Message-ID: <20130813081003.GU7656@atomide.com>
References: <51E83A4F.5080904@ti.com>
 <CACRpkdY3nQaWimTwB-Zt-8+Q_KZr8a0rpB1SUQq=AuoG4bAYnQ@mail.gmail.com>
 <51ED2385.60108@ti.com>
 <51ED5C66.1010407@ti.com>
 <51EFFBE1.4090505@ti.com>
 <51F0031B.1050307@ti.com>
 <51F00530.9090703@ti.com>
 <51F02069.3050207@ti.com>
 <51F0223E.4050008@ti.com>
 <51F0240F.3050507@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F0240F.3050507@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Santosh Shilimkar <santosh.shilimkar@ti.com> [130724 12:06]:
> On Wednesday 24 July 2013 02:51 PM, Nishanth Menon wrote:
> > On 07/24/2013 01:43 PM, Sricharan R wrote:
> >> On Wednesday 24 July 2013 10:17 PM, Nishanth Menon wrote:
> >>> On 07/24/2013 11:38 AM, Santosh Shilimkar wrote:
> >>>> On Wednesday 24 July 2013 12:08 PM, Nishanth Menon wrote:
> >>>>> That said, maybe a intermediate pinctrl approach might be more pragmatic and less theoretically flexible.
> >>>>> an option might be to "statically allocate" default number of interrupts to a domain - example:
> >>>>> * GIC IRQ 72->78 allotted to UARTs
> >>>>> * pinctrl mapping provided for those but only 6 can be used (rest are marked status="disabled" as default) at any given time (choice of pinctrl option determines GIC interrupt line to use)
> >>>>> * All modules will have a pinctrl definition to have a mapping - to avoid bootloader overriding default cross bar setting in ways un-expected by kernel.
> >>>>>
> >>>>> Does that sound fair trade off?
> >>>> This sounds better. That way we can get all the devices in the DT at least.
> >>>
> >>> Fair enough - if Linus and Tony are still ok with this approach to the problem, seeing a patch series with the effect would be beneficial.
> >>>
> >>   Ok, i will use this idea of certain number interrupts to groups.
> >> Yes on DRA7XX, we have about 160 gic lines and 320 irq crossbar device inputs contending for it.
> >> 1:2 and fully arbitrary.  But will we be really exhausting them ?
> >>
> > Depends on how we allocate :). The default arbitary allocation can be made more logical in your series ofcourse :).
> > 
> I would just most logical peripherals rather than providing every single
> IP connected to cross bar. Otherwise we will end up wth hwmod like
> scenario where now started removing the unused stuff because of
> maintenance and loc issues ;-)

Sorry for the delay on this, I think the best way to set this up
is as a separate drivers/irqchip controller. Then just map the
configured interrupts for the board with interrupt-map and
interrupt-map-mask binding. No need to stuff all the SoC specific
maps to the .dts, just the ones used for the board.

Regards,

Tony
 
