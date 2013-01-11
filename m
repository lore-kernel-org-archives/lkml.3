Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3AKS3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:29:14 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:36447 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3AKS3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:29:12 -0500
Date: Fri, 11 Jan 2013 13:33:49 -0500
From: Matt Porter <mporter@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Dan Williams <djbw@fb.com>, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v4 00/14] DMA Engine support for AM33XX
Message-ID: <20130111183349.GA14660@beef>
References: <1357883330-5364-1-git-send-email-mporter@ti.com>
 <201301111140.41584.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301111140.41584.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 11:40:41AM +0000, Arnd Bergmann wrote:
> On Friday 11 January 2013, Matt Porter wrote:
> > The approach taken is similar to how OMAP DMA is being converted to
> > DMA Engine support. With the functional EDMA private API already
> > existing in mach-davinci/dma.c, we first move that to an ARM common
> > area so it can be shared. Adding DT and runtime PM support to the
> > private EDMA API implementation allows it to run on AM33xx. AM33xx
> > only boots using DT so we leverage Jon's generic DT DMA helpers to
> > register EDMA DMAC with the of_dma framework and then add support
> > for calling the dma_request_slave_channel() API to both the mmc
> > and spi drivers.
> 
> I think this looks very good. What I wonder is whether we should
> make the non-DT parts of the dmaengine driver compile-time
> conditional on CONFIG_ATAGS though, so the slave drivers don't
> have a link-time dependency on the dmaengine driver's 
> omap_dma_filter_fn symbol when building without ATAGS support.

We have tightly coupled the link-time dependency for
omap_dma_filter_fn by going down the path of using
dma_request_slave_channel_compat() as Tony suggested to avoid extra
ifdefry.

That dependency will go away naturally if all the "legacy" OMAP platforms
were required to only boot from DT...just as a newly added SoCs are.

Are you suggesting unwinding the _compat() approach?

-Matt
