Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaGDIX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:23:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22532 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaGDIX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:23:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19s8FK7VlaU7XYQXNiE5uVQ
Date: Fri, 4 Jul 2014 01:23:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Suman Anna <s-anna@ti.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        Dave Gerlach <d-gerlach@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 2/6] mailbox/omap: add support for parsing dt devices
Message-ID: <20140704082354.GD28884@atomide.com>
References: <1403660878-56350-1-git-send-email-s-anna@ti.com>
 <1403660878-56350-3-git-send-email-s-anna@ti.com>
 <20140628170709.GB23634@xo-6d-61-c0.localdomain>
 <53B18999.2020506@ti.com>
 <20140630185942.GA5410@amd.pavel.ucw.cz>
 <53B1BBA8.5090507@ti.com>
 <20140630203225.GA3893@amd.pavel.ucw.cz>
 <20140704064547.GZ28884@atomide.com>
 <20140704080556.GA16274@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140704080556.GA16274@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [140704 01:07]:
> Hi!
> 
> > > > >>>> The non-DT support has to be maintained for now to not break
> > > > >>>> OMAP3 legacy boot, and the legacy-style code will be cleaned
> > > > >>>> up once OMAP3 is also converted to DT-boot only.
> > > > >>>
> > > > >>>> @@ -587,24 +606,157 @@ static int omap_mbox_unregister(struct omap_mbox_device *mdev)
> > > > >>>>  	return 0;
> > > > >>>>  }
> > > > >>>>  
> > > > >>>> +static const struct omap_mbox_device_data omap2_data = {
> > > > >>>> +	.num_users	= 4,
> > > > >>>> +	.num_fifos	= 6,
> > > > >>>> +	.intr_type	= MBOX_INTR_CFG_TYPE1,
> > > > >>>> +};
> > > > >>>> +
> > > > >>>> +static const struct omap_mbox_device_data omap3_data = {
> > > > >>>> +	.num_users	= 2,
> > > > >>>> +	.num_fifos	= 2,
> > > > >>>> +	.intr_type	= MBOX_INTR_CFG_TYPE1,
> > > > >>>> +};
> > > > >>>> +
> > > > >>>> +static const struct omap_mbox_device_data am335x_data = {
> > > > >>>> +	.num_users	= 4,
> > > > >>>> +	.num_fifos	= 8,
> > > > >>>> +	.intr_type	= MBOX_INTR_CFG_TYPE2,
> > > > >>>> +};
> > > > >>>
> 
> > > Aha, ok, then the intr_type should be derived from
> > > compatible-string. Or rather... you should have three
> > > compatible-strings for the three possibilities? (And then subtype,
> > > currently unused, in case there are more hw differences).
> > 
> > The compatible string can and should be separate for each revision
> > unless they are the same exacat hardware revision.
> 
> ACK.
> 
> > > > two are HW IP design parameters, so in general putting them in DT isn't
> > > > completely a bad idea, but I will wait to see if there are any further
> > > > comments on this from Tony or DT maintainers before I make changes.
> > > 
> > > Ok, right... I'd vote for putting them into DT.
> > 
> > I would avoid adding custom DT properties where possible and let the
> > driver just initialize the right data based on the compatible flag.
> 
> If these are HW IP design parameters, we can expect to see many
> different combinations. Yet we know ahead of time how to handle
> different parameters HW people select.
> 
> Thus IMO we should do it in the device tree.

Oh you mean from supporting new hardware with just .dts changes?
>From that point of view it makes sense to have them as DT properties,
so I'm fine with that.

Let's just try to use something that's generic like fifosize. No idea
how the property for num_fifos should be handled though as that
implies some knowledge in the driver which num_users have fifos?

So unless that can be described clearly in a DT property as well,
the binding might be still unusable for new hardware :)

Regards,

Tony
