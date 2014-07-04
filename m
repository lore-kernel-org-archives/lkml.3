Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaGDIGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:06:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51176 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbaGDIF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:05:59 -0400
Date: Fri, 4 Jul 2014 10:05:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tony Lindgren <tony@atomide.com>
Cc: Suman Anna <s-anna@ti.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        Dave Gerlach <d-gerlach@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 2/6] mailbox/omap: add support for parsing dt devices
Message-ID: <20140704080556.GA16274@amd.pavel.ucw.cz>
References: <1403660878-56350-1-git-send-email-s-anna@ti.com>
 <1403660878-56350-3-git-send-email-s-anna@ti.com>
 <20140628170709.GB23634@xo-6d-61-c0.localdomain>
 <53B18999.2020506@ti.com>
 <20140630185942.GA5410@amd.pavel.ucw.cz>
 <53B1BBA8.5090507@ti.com>
 <20140630203225.GA3893@amd.pavel.ucw.cz>
 <20140704064547.GZ28884@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140704064547.GZ28884@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > >>>> The non-DT support has to be maintained for now to not break
> > > >>>> OMAP3 legacy boot, and the legacy-style code will be cleaned
> > > >>>> up once OMAP3 is also converted to DT-boot only.
> > > >>>
> > > >>>> @@ -587,24 +606,157 @@ static int omap_mbox_unregister(struct omap_mbox_device *mdev)
> > > >>>>  	return 0;
> > > >>>>  }
> > > >>>>  
> > > >>>> +static const struct omap_mbox_device_data omap2_data = {
> > > >>>> +	.num_users	= 4,
> > > >>>> +	.num_fifos	= 6,
> > > >>>> +	.intr_type	= MBOX_INTR_CFG_TYPE1,
> > > >>>> +};
> > > >>>> +
> > > >>>> +static const struct omap_mbox_device_data omap3_data = {
> > > >>>> +	.num_users	= 2,
> > > >>>> +	.num_fifos	= 2,
> > > >>>> +	.intr_type	= MBOX_INTR_CFG_TYPE1,
> > > >>>> +};
> > > >>>> +
> > > >>>> +static const struct omap_mbox_device_data am335x_data = {
> > > >>>> +	.num_users	= 4,
> > > >>>> +	.num_fifos	= 8,
> > > >>>> +	.intr_type	= MBOX_INTR_CFG_TYPE2,
> > > >>>> +};
> > > >>>

> > Aha, ok, then the intr_type should be derived from
> > compatible-string. Or rather... you should have three
> > compatible-strings for the three possibilities? (And then subtype,
> > currently unused, in case there are more hw differences).
> 
> The compatible string can and should be separate for each revision
> unless they are the same exacat hardware revision.

ACK.

> > > two are HW IP design parameters, so in general putting them in DT isn't
> > > completely a bad idea, but I will wait to see if there are any further
> > > comments on this from Tony or DT maintainers before I make changes.
> > 
> > Ok, right... I'd vote for putting them into DT.
> 
> I would avoid adding custom DT properties where possible and let the
> driver just initialize the right data based on the compatible flag.

If these are HW IP design parameters, we can expect to see many
different combinations. Yet we know ahead of time how to handle
different parameters HW people select.

Thus IMO we should do it in the device tree.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
