Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaDYLQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:16:07 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52438 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752230AbaDYLQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:16:01 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/zchKe2GZFreuVTPY0R1ebPGJELFBc7BI=
X-DKIM: OpenDKIM Filter v2.0.1 titan CA8EF562CE0
Date: Fri, 25 Apr 2014 07:15:39 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 5/5] irqchip: armanda: Sanitize set_irq_affinity()
Message-ID: <20140425111539.GC28159@titan.lakedaemon.net>
References: <20140304202425.102779779@linutronix.de>
 <20140304203101.088889302@linutronix.de>
 <20140306190531.GF1872@titan.lakedaemon.net>
 <5319ED86.2050707@free-electrons.com>
 <alpine.DEB.2.02.1403071816340.18573@ionos.tec.linutronix.de>
 <53285303.8000305@free-electrons.com>
 <alpine.DEB.2.02.1403182153330.18573@ionos.tec.linutronix.de>
 <5328B4C9.6020906@free-electrons.com>
 <53593619.2000107@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53593619.2000107@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Thu, Apr 24, 2014 at 06:04:41PM +0200, Gregory CLEMENT wrote:
> Hi Thomas,
> 
> On 18/03/2014 22:04, Gregory CLEMENT wrote:
> > On 18/03/2014 21:55, Thomas Gleixner wrote:
> >> On Tue, 18 Mar 2014, Gregory CLEMENT wrote:
> >>> On 07/03/2014 18:17, Thomas Gleixner wrote:
> >>>> It might be the readback of the routing register. I don't have the
> >>>> datasheet of this.
> >>>
> >>> Sorry for the delay, I was on vacation without the hardware to test it.
> >>>
> >>> Indeed it was the readback of the routing register. (Unfortunately the
> >>> datasheet was not yet publicly available :(  ). In your patch by replacing
> >>> the line:
> >>>
> >>> writel(mask, main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
> >>>
> >>> by the following ones:
> >>>
> >>> reg = readl(main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
> >>> reg = (reg & (~ARMADA_370_XP_INT_SOURCE_CPU_MASK)) | mask;
> >>> writel(reg, main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
> >>>
> >>> with
> >>> #define ARMADA_370_XP_INT_SOURCE_CPU_MASK	0xF
> >>>
> >>> Then it worked.
> >>>
> >>> About masking with the online CPU in the original code, the purpose
> >>> was to allow sharing the SoC with an other OS by doing AMP. This feature
> >>> is part of the Marvell version of the kernel.
> >>> The idea was to bring this latter in the vanilla kernel, but I am not sure
> >>> that all the part needed for AMP are acceptable for mainline. So I can add
> >>> it back later when we will need it.
> >>
> >> Right.
> >>
> >> So are you ok with that patch (including your change) ? If you send me
> >> tested/acked-by i'll route it for 3.15
> > 
> > With the change I included you can add my
> > 
> > Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> > Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> > 
> 
> I have just noticed that this patch was not merged in 3.15.
> Actually it is not in the core/irq branch of tip.git with
> the other patches of the same series.
> Is there any reason for this?

I know your mail filters are pretty aggressive and I just wanted to make
sure you saw this.  I'm also not sure what happened here.

thx,

Jason.
