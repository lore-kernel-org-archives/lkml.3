Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaHUMF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:05:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49551 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530AbaHUMF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:05:58 -0400
Date: Thu, 21 Aug 2014 13:05:54 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: arizona: Add additional dummy IRQ callbacks
Message-ID: <20140821120554.GC7328@opensource.wolfsonmicro.com>
References: <1407851483-19207-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140821115631.GA4266@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821115631.GA4266@lee--X1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 12:56:31PM +0100, Lee Jones wrote:
> On Tue, 12 Aug 2014, Charles Keepax wrote:
> >  static struct irq_chip arizona_irq_chip = {
> >  	.name			= "arizona",
> > -	.irq_disable		= arizona_irq_disable,
> > -	.irq_enable		= arizona_irq_enable,
> > +	.irq_disable		= arizona_irq_dummy,
> > +	.irq_enable		= arizona_irq_dummy,
> > +	.irq_ack		= arizona_irq_dummy,
> > +	.irq_mask		= arizona_irq_dummy,
> > +	.irq_unmask		= arizona_irq_dummy,
> 
> If you provide .irq_enable(), then .irq_unmask becomes redundant
> and/or is checked for before invoking.  There is a chance of
> .irq_mask() being called, but if this is a problem, it should be fixed
> in the IRQ Chip code.  There is also one unprotected invocation of
> .irq_ack(), but I think this should be fixed rather than forcing each
> user of IRQ Chip to provide all of these call-backs.

Cool I will look at doing some fixups in the IRQ code and see
where that gets me to.

Thanks,
Charles
