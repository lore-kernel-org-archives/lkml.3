Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaINFzp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 01:55:45 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:17457 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752301AbaINFzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 01:55:44 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+BAI+NlYw0G4F8TWzRTbW+r7REim7RW94=
X-DKIM: OpenDKIM Filter v2.0.1 titan 3EA3F5E138A
Date: Sun, 14 Sep 2014 01:55:33 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Robert Richter <rric@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Robert Richter <rrichter@cavium.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] GICv3: Fixing 32 bit compatibility
Message-ID: <20140914055533.GK21986@titan.lakedaemon.net>
References: <1410185480-5153-1-git-send-email-rric@kernel.org>
 <540DBC0C.7080902@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540DBC0C.7080902@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 03:24:12PM +0100, Marc Zyngier wrote:
> Hi Robert,
> 
> On 08/09/14 15:11, Robert Richter wrote:
> > From: Robert Richter <rrichter@cavium.com>
> > 
> > Fixing 32 bit compatibility by using ULL for u64 constants.
> > 
> > Signed-off-by: Robert Richter <rrichter@cavium.com>
> > ---
> >  drivers/irqchip/irq-gic-v3.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> > index 57eaa5a0b1e3..9e13c87c7dfe 100644
> > --- a/drivers/irqchip/irq-gic-v3.c
> > +++ b/drivers/irqchip/irq-gic-v3.c
> > @@ -441,7 +441,7 @@ static u16 gic_compute_target_list(int *base_cpu, const struct cpumask *mask,
> >  
> >  		mpidr = cpu_logical_map(cpu);
> >  
> > -		if (cluster_id != (mpidr & ~0xffUL)) {
> > +		if (cluster_id != (mpidr & ~0xffULL)) {
> >  			cpu--;
> >  			goto out;
> >  		}
> > @@ -479,7 +479,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
> >  	smp_wmb();
> >  
> >  	for_each_cpu_mask(cpu, *mask) {
> > -		u64 cluster_id = cpu_logical_map(cpu) & ~0xffUL;
> > +		u64 cluster_id = cpu_logical_map(cpu) & ~0xffULL;
> >  		u16 tlist;
> >  
> >  		tlist = gic_compute_target_list(&cpu, mask, cluster_id);
> > 
> 
> Yeah, and there are many more. I'm currently sitting on a rather long
> queue of GICv3-related 32bit patches. I'll try to get that posted shortly.

I'll hold off until you post a complete series then.

thx,

Jason.
