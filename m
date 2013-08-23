Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3HWEf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 00:35:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47087 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab3HWEf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 00:35:28 -0400
Date: Thu, 22 Aug 2013 21:35:27 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Javi Merino <javi.merino@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] irqchip: gic: Don't complain in gic_get_cpumask() if
 UP system
Message-ID: <20130823043527.GG23960@codeaurora.org>
References: <1373067573-29946-1-git-send-email-sboyd@codeaurora.org>
 <20130712111322.GC3213@e102654-lin.cambridge.arm.com>
 <20130712121023.GB27430@codeaurora.org>
 <51E71249.4050200@codeaurora.org>
 <alpine.LFD.2.03.1307171830170.14924@syhkavp.arg>
 <51E71C78.6080604@codeaurora.org>
 <alpine.LFD.2.03.1307171849180.14924@syhkavp.arg>
 <51E7236D.3010700@codeaurora.org>
 <20130822184312.GE23960@codeaurora.org>
 <alpine.LFD.2.03.1308221458320.14472@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1308221458320.14472@syhkavp.arg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Nicolas Pitre wrote:
> On Thu, 22 Aug 2013, Stephen Boyd wrote:
> 
> > On 07/17, Stephen Boyd wrote:
> > > On 07/17/13 15:53, Nicolas Pitre wrote:
> > > > On Wed, 17 Jul 2013, Stephen Boyd wrote:
> > > >
> > > >> On 07/17/13 15:34, Nicolas Pitre wrote:
> > > >>> On Wed, 17 Jul 2013, Stephen Boyd wrote:
> > > >>>
> > > >>>> On 07/12/13 05:10, Stephen Boyd wrote:
> > > >>>>> On 07/12, Javi Merino wrote:
> > > >>>>>> I agree, we should drop the check.  It's annoying in uniprocessors and
> > > >>>>>> unlikely to be found in the real world unless your gic entry in the dt
> > > >>>>>> is wrong.
> > > >>> And that's a likely outcome in the real world.
> > > >>>
> > > >>>>> Ok. How about this?
> > > >>>> Any comments?
> > > >>> What about this instead:
> > > >> Unfortunately arm64 doesn't have SMP_ON_UP. 
> > > > And why does that matter?
> > > 
> > > Because the gic driver is compiled on both arm and arm64? I suppose we
> > > could define is_smp() to 1 on arm64 but its probably better to rely on
> > > generic kernel things instead of arch specific functions.
> > > 
> > > >
> > > >> It sounds like you preferred the first patch using num_possible_cpus()
> > > > Probably, yes.  I didn't follow the early conversation though.
> > > 
> > > This was the first patch:
> > > 
> > > ---8<----
> > > 
> > > diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> > > index 19ceaa6..589c760 100644
> > > --- a/drivers/irqchip/irq-gic.c
> > > +++ b/drivers/irqchip/irq-gic.c
> > > @@ -368,7 +368,7 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
> > >  			break;
> > >  	}
> > >  
> > > -	if (!mask)
> > > +	if (!mask && num_possible_cpus() > 1)
> > >  		pr_crit("GIC CPU mask not found - kernel will fail to boot.\n");
> > >  
> > >  	return mask;
> > 
> > Can one of these two patches be picked up?
> 
> Sure.  Just send it to RMK's patch system with my ACK.
> 

I'm confused on that. MAINTAINERS says this patch should go
through Thomas Gleixner's irq/core branch but it looks like only
arm-soc has been taking patches for the current location.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
