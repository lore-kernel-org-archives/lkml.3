Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3BAL5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:57:08 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:62256 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab3BAL5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:57:05 -0500
Date: Fri, 1 Feb 2013 06:57:39 -0500
From: Matt Porter <mporter@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, Russell King <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>, Padma Venkat <padma.kvr@gmail.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 03/10] ARM: edma: add AM33XX support to the private
 EDMA API
Message-ID: <20130201115738.GL2244@beef>
References: <1359529229-22207-1-git-send-email-mporter@ti.com>
 <201301300932.58732.arnd@arndb.de>
 <20130131183255.GI2244@beef>
 <6932828d68394f71ba6df8e6bf608635@DFLE72.ent.ti.com>
 <20130131214241.GJ2244@beef>
 <1359698501.14894.74.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359698501.14894.74.camel@cumari.coelho.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 08:01:41AM +0200, Luciano Coelho wrote:
> On Thu, 2013-01-31 at 16:42 -0500, Matt Porter wrote:
> > On Thu, Jan 31, 2013 at 08:58:39PM +0000, Arnd Bergmann wrote:
> > > On Thursday 31 January 2013, Matt Porter wrote:
> > > > On Wed, Jan 30, 2013 at 09:32:58AM +0000, Arnd Bergmann wrote:
> > > > > On Wednesday 30 January 2013, Matt Porter wrote:
> > > > > > +               dma_cap_set(DMA_SLAVE, edma_filter_info.dma_cap);
> > > > > > +               of_dma_controller_register(dev->of_node,
> > > > > > +                                          of_dma_simple_xlate,
> > > > > > +                                          &edma_filter_info);
> > > > > > +       }
> > > > > 
> > > > > How do you actually deal with the problem mentioned by Padma, that
> > > > > the filter function does not know which edma instance it is looking
> > > > > at? If you assume that there can only be a single edma instance in
> > > > > the system, that is probably a limitation that should be documented
> > > > > somewhere, and ideally the probe() function should check for that.
> > > > 
> > > > I make an assumption of one edma instance in the system in the case of
> > > > DT being populated. This is always true right now as the only SoC with
> > > > two EDMA controllers in existence is Davinci DA850. Until recently,
> > > > Davinci had no DT support. Given the steady work being done today on DT
> > > > support for DA850, it'll probably be something needed in 3.10.
> > > > 
> > > > I will add a comment and check in probe() to capture this assumption
> > > > and then plan to update separately to support DA850 booting from DT.
> > > 
> > > Ok, sounds good. Hopefully by then we will already have a nicer
> > > way to write an xlate function that does not rely on a filter
> > > function.
> > 
> > Yes, it would be nice to avoid what Padma had to do. I should have
> > mentioned also that the second EDMA on DA850 has no DMA events of
> > immediate use on it anyway. All the in-kernel users use events on the
> > first controller, except for the second MMC instance. That's only used
> > for a wl12xx module on the EVM and that driver has no DT support so it
> > doesn't matter yet in the DT case. Because of this, DA850 can actually
> > add EDMA DT support immediately (on top of this series) and add DMA
> > support to the DT support already posted for the Davinci SPI and MMC
> > client drivers.
> 
> I haven't followed this whole discussion in details, but please notice
> that I'm aiming to get DT support for the WiLink modules (wlcore,
> wl12xx...) for 3.10. ;)

Great, looks like we'll all be synced then. ;)

-Matt
