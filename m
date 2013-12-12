Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab3LLTYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:24:06 -0500
Received: from muru.com ([72.249.23.125]:34947 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab3LLTYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:24:01 -0500
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Dec 2013 14:24:01 EST
Date: Thu, 12 Dec 2013 19:19:08 +0000
From: Tony Lindgren <tony@atomide.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        NeilBrown <neilb@suse.de>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: [PATCH 1/3] arm: omap2: Export devconf1 bypass and acbias.
Message-ID: <20131212191908.GA29072@muru.com>
References: <1381784555-18344-1-git-send-email-marek@goldelico.com>
 <1381784555-18344-2-git-send-email-marek@goldelico.com>
 <20131111164917.GN15154@atomide.com>
 <CAAfyv37LRb_Q=UZVgtKdOAz_r6_qThewAU90W7nrqHdB5fDA_g@mail.gmail.com>
 <20131111233152.GR15154@atomide.com>
 <CAAfyv36MaVqrmQxpqDu-ciO9GNJK3pJkFZohEvd1BOLOWWEOhw@mail.gmail.com>
 <20131210224659.GY13171@atomide.com>
 <CAAfyv35wKAK2PNjcXcNan9GC0x-MmH5k4xmzj_vKKhPeztHV-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfyv35wKAK2PNjcXcNan9GC0x-MmH5k4xmzj_vKKhPeztHV-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 09:31:02AM +0100, Belisko Marek wrote:
> Hi Tony,
> 
> On Tue, Dec 10, 2013 at 11:46 PM, Tony Lindgren <tony@atomide.com> wrote:
> > * Belisko Marek <marek.belisko@gmail.com> [131210 14:13]:
> >> On Tue, Nov 12, 2013 at 12:31 AM, Tony Lindgren <tony@atomide.com> wrote:
> >> >
> >> > It would be best to set it up as omap-ctrl.c driver under drivers
> >> > somewhere with few functions exported for DSS and MMC drivers.
> >>
> >> I create small dummy driver based on phy-omap-control which can be
> >> used but before sending patch (with more updates) I would like to get
> >> some feedback if my direction is correct.
> >
> > Cool thanks. Yeah what you have can easily be combined with the patches
> > Balaji has posted to make HSMMC use drivers/mfd/syscon.c via regmap
> > for the SCM register access. Maybe take a look at the work in progress
> > patches in thread:
> >
> > [PATCH v4 0/7] mmc: omap_hsmmc: pbias dt and cleanup
> >
> > And also see my comments regarding using the SCM GENERAL register area
> > as base for the syscon.c driver. That should work for your driver too,
> > right? And then you can access the SYSCON1 register that way from your
> > consumer driver ;)
>
> If I understand correclty I can use syscon driver (it will have in
> range also devconf1 register) ad get rid of my custom driver
> and then get regmap from syscon and update bits that I need for venc, right?

Yeah something like that. Or since the sysconf1 register is shared, it might
be best to still provide specific functions to access it if we cannot map
just specific bits of it separately for drivers using regmap.

But anyways this should for most part remove the need for a custom driver(s)
unless the register is a regulator or a clock.

Regards,

Tony
