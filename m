Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaFMNNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:13:32 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:38021 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750870AbaFMNNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:13:30 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+MsH02ANXs5D5QIfzzbdkXs+f6OJ8FVYs=
X-DKIM: OpenDKIM Filter v2.0.1 titan 21C2858EC0B
Date: Fri, 13 Jun 2014 09:13:21 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Subject: Re: [PATCH V2 05/19] irqchip: crossbar: Change allocation logic by
 reversing search for free irqs
Message-ID: <20140613131321.GG8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
 <1402574007-13987-6-git-send-email-r.sricharan@ti.com>
 <20140612125615.GT8664@titan.lakedaemon.net>
 <539A95A3.1010301@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539A95A3.1010301@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 11:39:39AM +0530, Sricharan R wrote:
> Hi Jason,
> 
> On Thursday 12 June 2014 06:26 PM, Jason Cooper wrote:
> > On Thu, Jun 12, 2014 at 05:23:13PM +0530, Sricharan R wrote:
> >> From: Nishanth Menon <nm@ti.com>
> >>
> >> Reverse the search algorithm to ensure that address mapping and IRQ
> >> allocation logics are proper. This can open up new bugs which are
> >> easily fixable rather than wait till allocation logic approaches
> >> the limit to find new bugs.
> > 
> > Could you expand on this logic some more?  What class of bugs are you
> > hoping to discover more easily?
> > 
> 
> class 1. address space errors -> example:
> reg = <a size_b>
> ti,max-irqs =  is a wrong parameter
> 
> class 2: irq-reserved list - which decides which entries in the
> address space is not actually wired in
> 
> class 3: wrong list of routable-irqs.
> 
> in general allocating from max to min tends to have benefits in
> ensuring the different issues that may be present in dts is easily
> caught at definition time, rather than at a later point in time.

Perfect, thanks for clarifying.  Please add this to the commit log when
you respin.

thx,

Jason.
