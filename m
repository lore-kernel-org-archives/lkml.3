Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab3KWQct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 11:32:49 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64569 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab3KWQcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 11:32:47 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ykNJDUTV7Kh0M3B5sqjuQ
Date: Sat, 23 Nov 2013 08:32:40 -0800
From: Tony Lindgren <tony@atomide.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20131123163240.GW5928@atomide.com>
References: <20131123004334.GJ10023@atomide.com>
 <20131123005509.GJ16735@n2100.arm.linux.org.uk>
 <20131123010850.GN10023@atomide.com>
 <20131123011515.GO10023@atomide.com>
 <20131123015034.GP10023@atomide.com>
 <CAL_JsqKV7K+QdLHS+3LtfcVx5Dpc7n6A8UwwNWKBP33Gs19c8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqKV7K+QdLHS+3LtfcVx5Dpc7n6A8UwwNWKBP33Gs19c8g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rob Herring <robherring2@gmail.com> [131123 07:43]:
> On Fri, Nov 22, 2013 at 7:50 PM, Tony Lindgren <tony@atomide.com> wrote:
> > * Tony Lindgren <tony@atomide.com> [131122 17:16]:
> >> * Tony Lindgren <tony@atomide.com> [131122 17:09]:
> >> > * Russell King - ARM Linux <linux@arm.linux.org.uk> [131122 16:56]:
> >> > > On Fri, Nov 22, 2013 at 04:43:35PM -0800, Tony Lindgren wrote:
> >> > > > +               /* See of_device_resource_notify for populating interrupts */
> >> > > > +               for (i = 0; i < num_irq; i++, res++) {
> >> > > > +                       res->flags = IORESOURCE_IRQ;
> >> > > > +                       res->start = -EPROBE_DEFER;
> >> > > > +                       res->end = -EPROBE_DEFER;
> >> > >
> >> > > NAK.  Definitely a bad idea to start introducing magic values other into
> >> > > resources.  Please don't do this.
> >> >
> >> > Do you have any better ideas on how to sort out this issue then?
> >>
> >> I guess we could allocate all the resources lazily here, I'll take a look
> >> at that.
> >
> > Here's a version that allocates the resources lazily with the notifier.
> > Seems to boot, need to play with it a bit more though to make sure we're
> > not overwriting resources for any legacy devices.
> 
> Have you seen Thierry's series[1]? While your approach is certainly
> more concise, it seems like a work-around for the problem. I don't
> think a notifier is the right long term solution.

OK cool. I think we can fix the $Subject bug first without making all
those changes, then do the rest of the reorg for v3.14.

The bug is that we try to populate IRQ resources at a wrong time
when they may not exist.

Based on a quick look it seems we could combine Thierry's addition
of the new function of_platform_probe(struct platform_device *pdev)
and use that to allocate all resources at driver probe time like my
patch is doing. And then there's no need for the notifier.

Regards,

Tony

 
> [1] http://www.spinics.net/lists/arm-kernel/msg274110.html
