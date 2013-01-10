Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab3AJTZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:25:55 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:38022 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3AJTZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:25:53 -0500
Date: Thu, 10 Jan 2013 14:30:28 -0500
From: Matt Porter <mporter@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3 11/16] mmc: omap_hsmmc: limit max_segs with the
 EDMA DMAC
Message-ID: <20130110193028.GP14660@beef>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
 <1350566815-409-12-git-send-email-mporter@ti.com>
 <508E3BE6.3070609@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508E3BE6.3070609@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 01:48:46PM +0530, Sekhar Nori wrote:
> On 10/18/2012 6:56 PM, Matt Porter wrote:
> > The EDMA DMAC has a hardware limitation that prevents supporting
> > scatter gather lists with any number of segments. Since the EDMA
> > DMA Engine driver sets the maximum segments to 16, we do the
> > same.
> > 
> > TODO: this will be replaced once the DMA Engine API supports an
> > API to query the DMAC's segment size limit.
> > 
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > ---
> >  drivers/mmc/host/omap_hsmmc.c |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> > index b327cd0..52bab01 100644
> > --- a/drivers/mmc/host/omap_hsmmc.c
> > +++ b/drivers/mmc/host/omap_hsmmc.c
> > @@ -1828,6 +1828,16 @@ static int __devinit omap_hsmmc_probe(struct platform_device *pdev)
> >  	 * as we want. */
> >  	mmc->max_segs = 1024;
> >  
> > +	/* Eventually we should get our max_segs limitation for EDMA by
> > +	 * querying the dmaengine API */
> 
> Nit picking: This is not as per multi-line comment style in
> Documentation/CodingStyle.

Thanks :). This is dropped from v4 anyway, as I now use a call to
dma_get_channel_caps() to determine the SG limits.

-Matt
