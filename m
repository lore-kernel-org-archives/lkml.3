Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3CHHZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:25:20 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:59722 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab3CHHZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:25:15 -0500
Date: Fri, 8 Mar 2013 08:25:09 +0100
From: Simon Horman <horms@verge.net.au>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, benh@kernel.crashing.org,
        grant.likely@secretlab.ca
Subject: Re: [PATCH] irqchip: Renesas INTC External IRQ pin driver
Message-ID: <20130308072508.GA13457@verge.net.au>
References: <20130218142834.28739.39417.sendpatchset@w520>
 <20130306042304.GA2896@verge.net.au>
 <alpine.LFD.2.02.1303061058250.22263@ionos>
 <20130306114622.GE6684@verge.net.au>
 <alpine.LFD.2.02.1303061405200.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1303061405200.22263@ionos>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 02:05:52PM +0100, Thomas Gleixner wrote:
> On Wed, 6 Mar 2013, Simon Horman wrote:
> 
> > On Wed, Mar 06, 2013 at 11:01:14AM +0100, Thomas Gleixner wrote:
> > > On Wed, 6 Mar 2013, Simon Horman wrote:
> > > > On Mon, Feb 18, 2013 at 11:28:34PM +0900, Magnus Damm wrote:
> > > > > The SoCs using this driver are currently mainly used
> > > > > together with regular platform devices so this driver
> > > > > allows configuration via platform data to support things
> > > > > like static interrupt base address. DT support will
> > > > > be added incrementally in the not so distant future.
> > > > 
> > > > Hi Thomas,
> > > > 
> > > > I'm wondering how you would like to handle merging this driver.
> > > > I can think of three options but I'm sure there are others.
> > > > 
> > > > * You can take the patches (there is a follow-up series) yourself.
> > > > * I can prepare a pull request for you
> > > > * I can prepare a pull request for arm-soc with the shmobile patches that
> > > >   enable the driver on the r8a7779 and sh73a0.
> > > > 
> > > > The last option is possibly the easiest.
> > > 
> > > Correct.
> > > 
> > > > But in that case I'd appreciate an Ack from you on this patch.
> > > 
> > > You want to pick the V2 series, which already has my blessing:
> > > 
> > >     https://lkml.org/lkml/2013/2/26/305
> > > 
> > > For merging it through arm-soc you have my ack now :)
> > 
> > Thanks, I have that.
> > 
> > It seems that V2 adds onto this patch rather than replaces it.
> > So could I also get an Ack for this patch too?
> 
> Ah,. right. V2 is an incremental fix for V1. Yes, please add my Ack.

Thanks.

I have added this into a new intc-external-irq branch of
the renesas tree on kernel.org and thus queued it up for v3.10.

I have also added the following patches to that branch:

irqchip: irqc: Add DT support
irqchip: intc-irqpin: Initial DT support
ARM: shmobile: Make r8a7779 INTC irqpin platform data static
ARM: shmobile: Make sh73a0 INTC irqpin platform data static
irqchip: Renesas IRQC driver
irqchip: intc-irqpin: GPL header for platform data
irqchip: intc-irqpin: Make use of devm functions
irqchip: intc-irqpin: Add force comments
irqchip: intc-irqpin: Cache mapped IRQ
irqchip: intc-irqpin: Whitespace fixes
ARM: shmobile: INTC External IRQ pin driver on r8a7779
ARM: shmobile: INTC External IRQ pin driver on sh73a0
ARM: shmobile: irq_pin() for static IRQ pin assignment

The intc-external-irq branch is merged into the next branch and
I expect it to appear in linux-next in the not to distant future.

I have removed the topic/intc-external-irq branch from the reneas tree,
the branch where these patches were being staged.


