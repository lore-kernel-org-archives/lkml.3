Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbaFLPcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:32:47 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:37260 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756255AbaFLPco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:32:44 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+KYqM+GawjYwIzmz5qCVVU5oH0dMpONpI=
X-DKIM: OpenDKIM Filter v2.0.1 titan 3E4AF58E18E
Date: Thu, 12 Jun 2014 11:32:26 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Joe Perches <joe@perches.com>
Cc: Sricharan R <r.sricharan@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com,
        santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Subject: Re: [PATCH V2 08/19] irqchip: crossbar: fix checkpatch warning
Message-ID: <20140612153226.GE8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
 <1402574007-13987-9-git-send-email-r.sricharan@ti.com>
 <20140612131042.GU8664@titan.lakedaemon.net>
 <5399AC9C.4080602@ti.com>
 <1402582711.9947.17.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402582711.9947.17.camel@joe-AO725>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Joe,

On Thu, Jun 12, 2014 at 07:18:31AM -0700, Joe Perches wrote:
> On Thu, 2014-06-12 at 19:05 +0530, Sricharan R wrote:
> > On Thursday 12 June 2014 06:40 PM, Jason Cooper wrote:
> > > On Thu, Jun 12, 2014 at 05:23:16PM +0530, Sricharan R wrote:
> > >> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
> []
> > >> @@ -34,7 +34,8 @@ struct crossbar_device {
> > >>  	uint *irq_map;
> > >>  	void __iomem *crossbar_base;
> > >>  	int *register_offsets;
> > >> -	void (*write) (int, int);
> > >> +
> > >> +	void (*write)(int, int);
> > > 
> > > The empty line here looks bogus to me.
> 
> Good eye.  It's unnecessary.
> 
> > > Did you re-run checkpatch after fixing the unnecessary space to
> > > see if it still complained about having a 'blank line after
> > > declarations'?
> > > 
> >  Yes, it still complains even after fixing unnecessary space.
> 
> It's a checkpatch defect.
> 
> It's been fixed by:
> https://lkml.org/lkml/2014/6/6/426

Ah, good to know.

> > > I'm generally opposed to these sorts of checkpatch patches, especially
> > > when they are just warnings.  It's great for a new driver in the staging
> > > tree, but it makes backporting future bugfixes that much harder when
> > > drivers have been live in mainline.
> 
> Blind adherence to checkpatch isn't always a great idea.

Agreed.

> But bugfix backports haven't been much of an issue in
> other subsystems with fairly active whitespace/style
> changes.

Most of the mvebu fixes we've had that failed to apply were generally
due to a large whitespace change (dts node shuffling, admittedly not
checkpatch-related).  I've also frequently been stymied by code cleanups
when using git blame to find the commit introducing a regression.

So, my general rule is: If you're submitting a patch to make checkpatch
be quiet, re-assess the need.  If you're making changes and you can fix
some checkpatch items while you're there, then do so.

There are certainly legitimate checkpatch-only patches, I just don't
think this is one qualifies.

thx,

Jason.
