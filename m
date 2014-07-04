Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaGDGpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 02:45:52 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:28568 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758AbaGDGpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 02:45:50 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+MkjfnTsfT5aJBhYbG5yka
Date: Thu, 3 Jul 2014 23:45:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Suman Anna <s-anna@ti.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        Dave Gerlach <d-gerlach@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 2/6] mailbox/omap: add support for parsing dt devices
Message-ID: <20140704064547.GZ28884@atomide.com>
References: <1403660878-56350-1-git-send-email-s-anna@ti.com>
 <1403660878-56350-3-git-send-email-s-anna@ti.com>
 <20140628170709.GB23634@xo-6d-61-c0.localdomain>
 <53B18999.2020506@ti.com>
 <20140630185942.GA5410@amd.pavel.ucw.cz>
 <53B1BBA8.5090507@ti.com>
 <20140630203225.GA3893@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630203225.GA3893@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [140630 13:34]:
> Hi!
> 
> > >>>> The non-DT support has to be maintained for now to not break
> > >>>> OMAP3 legacy boot, and the legacy-style code will be cleaned
> > >>>> up once OMAP3 is also converted to DT-boot only.
> > >>>
> > >>>> @@ -587,24 +606,157 @@ static int omap_mbox_unregister(struct omap_mbox_device *mdev)
> > >>>>  	return 0;
> > >>>>  }
> > >>>>  
> > >>>> +static const struct omap_mbox_device_data omap2_data = {
> > >>>> +	.num_users	= 4,
> > >>>> +	.num_fifos	= 6,
> > >>>> +	.intr_type	= MBOX_INTR_CFG_TYPE1,
> > >>>> +};
> > >>>> +
> > >>>> +static const struct omap_mbox_device_data omap3_data = {
> > >>>> +	.num_users	= 2,
> > >>>> +	.num_fifos	= 2,
> > >>>> +	.intr_type	= MBOX_INTR_CFG_TYPE1,
> > >>>> +};
> > >>>> +
> > >>>> +static const struct omap_mbox_device_data am335x_data = {
> > >>>> +	.num_users	= 4,
> > >>>> +	.num_fifos	= 8,
> > >>>> +	.intr_type	= MBOX_INTR_CFG_TYPE2,
> > >>>> +};
> > >>>
> > >>> So you use compatible strings to look up 3 integers. Would it be better to have
> > >>> num_users/num_fifos/intr_type directly in the device tree? That should be cleaner
> > >>> and more flexible...
> > >>>
> > >>> If you do that, would it be possible to have share compatible string?
> > >>
> > >> Yeah, I have actually encoded the .num_users and .num_fifos in DT in the
> > >> previous version [1] with shared compatible strings, but dropped those
> > >> properties in favour of adding minimal custom properties to DT based on
> > >> some offline IRC comments. I have no objections either way, but there is
> > >> really nothing to be gained from minimizing compatible strings.
> > > 
> > > Actually, I'd guess best solution would be to do both: have it encoded
> > > in device tree _and_ have separate compatible string for each version
> > > (in case there are other differences). You'd still get rid of the
> > > table...
> > 
> > Do note that the .intr_type has to with the register layout rather than
> > a physical property (mainly to distinguish the pre-OMAP4 IP register
> > layout), so I am not convinced that belongs to DT. This is the reason
> > why I didn't represent it in DT even in the previous version. The
> > other
> 
> Aha, ok, then the intr_type should be derived from
> compatible-string. Or rather... you should have three
> compatible-strings for the three possibilities? (And then subtype,
> currently unused, in case there are more hw differences).

The compatible string can and should be separate for each revision
unless they are the same exacat hardware revision.
 
> > two are HW IP design parameters, so in general putting them in DT isn't
> > completely a bad idea, but I will wait to see if there are any further
> > comments on this from Tony or DT maintainers before I make changes.
> 
> Ok, right... I'd vote for putting them into DT.

I would avoid adding custom DT properties where possible and let the
driver just initialize the right data based on the compatible flag.

That is as long as the amount of data built into the driver is minimal.

If we wanted to have some fifo property in DT, it should be Linux
generic property to avoid adding yet more custom driver specific
properties.

Regards,

Tony
