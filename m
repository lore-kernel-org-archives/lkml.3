Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbaGWPFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:05:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42489 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756005AbaGWPFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:05:51 -0400
Date: Wed, 23 Jul 2014 16:05:18 +0100
From: Will Deacon <will.deacon@arm.com>
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: Himangi Saraogi <himangi774@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "julia.lawall@lip6.fr" <julia.lawall@lip6.fr>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] drivers: CCI: Correct use of ! and &
Message-ID: <20140723150518.GD27677@arm.com>
References: <20140707140538.GA4204@himangi-Dell>
 <9hhwqb42k63.fsf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9hhwqb42k63.fsf@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 04:01:56PM +0100, Punit Agrawal wrote:
> > diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
> > index 5a86da9..7af78df 100644
> > --- a/drivers/bus/arm-cci.c
> > +++ b/drivers/bus/arm-cci.c
> > @@ -397,7 +397,8 @@ static irqreturn_t pmu_handle_irq(int irq_num, void *dev)
> >  		hw_counter = &event->hw;
> >  
> >  		/* Did this counter overflow? */
> > -		if (!pmu_read_register(idx, CCI_PMU_OVRFLW) & CCI_PMU_OVRFLW_FLAG)
> > +		if (!(pmu_read_register(idx, CCI_PMU_OVRFLW) &
> > +		      CCI_PMU_OVRFLW_FLAG))
> >  			continue;
> 
> 
> Going back to the manual, this fix looks correct.
> 
> Acked-by: Punit Agrawal <punit.agrawal@arm.com>
> 
> Will, would this go via your tree?

Given that you're happy with it, I don't mind which tree it goes in.
Probably deserves a CC stable on it too.

If you get stuck, put it in rmk's patch system.

Will
