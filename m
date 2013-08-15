Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389Ab3HOU1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:27:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39239 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760249Ab3HOU1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:27:37 -0400
Message-ID: <520D398D.9040806@ti.com>
Date: Thu, 15 Aug 2013 16:26:53 -0400
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
References: <51E83A4F.5080904@ti.com> <CACRpkdY3nQaWimTwB-Zt-8+Q_KZr8a0rpB1SUQq=AuoG4bAYnQ@mail.gmail.com> <51ED2385.60108@ti.com> <51ED5C66.1010407@ti.com> <51EFFBE1.4090505@ti.com> <51F0031B.1050307@ti.com> <51F00530.9090703@ti.com> <51F02069.3050207@ti.com> <51F0223E.4050008@ti.com> <51F0240F.3050507@ti.com> <20130813081003.GU7656@atomide.com> <520A02BA.4090805@ti.com> <CACRpkda+m82PYJsExLM6JLsLa8-bVhdvy_r_+-uKfVT2NG7Cbg@mail.gmail.com>
In-Reply-To: <CACRpkda+m82PYJsExLM6JLsLa8-bVhdvy_r_+-uKfVT2NG7Cbg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 August 2013 04:01 PM, Linus Walleij wrote:
> On Tue, Aug 13, 2013 at 11:56 AM, Sricharan R <r.sricharan@ti.com> wrote:
> 
>>  Initially irqchip was discussed, but we also have a DMA crossbar
>>  to map the dma-requests. Since both irq/dma crossbars should be handled,
>>  pinctrl was suggested as the appropriate place to handle this.
> 
> I think it is better to use irqchip.
>
Did you happen to read the thread why irqchip is in-appropriate
for such an IP. As I said earlier, an IRQ-chip always need a
real IRQ link (even for the chained one) to the primary irqchip.

This IP is just dummy IP makes the connections for the primary
irqchip(read GIC). And its use only limited to make the
connection between the peripheral IRQ event to the GIC IRQ line.

I don't see how you can make this happen with an irqchip
infrastructure.

If you have a idea to make that work, we can go with that
since for time being we can ignore the DMA event related need
of this IP.
 
> For DMA there is already an arbiter mechanism for arbitration of
> virtual channels over physical channels, this is not much different,
> the DMA might need some different tweaking but should be solved
> in that subsystem I think.
>
Sure. The IP won't be limited to DMA and IRQ lines but any other events
like gpio etc in future.
 
> I don't see any way to really abstract this pretty simple crossbar
> for reuse across subsystems.
> 
This exactly the reason, i am against idea of over-engineering the
simple IP whose only job is to make the physical wire connection
in software where as this is generally done in RTL by default on
most of the SOCs.

Regards,
Santosh

