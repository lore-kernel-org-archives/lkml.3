Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab3BDPpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:45:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34837 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab3BDPps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:45:48 -0500
Date: Mon, 4 Feb 2013 15:45:02 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, "Cousson, Benoit" <b-cousson@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
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
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
	arm/common
Message-ID: <20130204154502.GD2637@n2100.arm.linux.org.uk>
References: <1359742975-10421-1-git-send-email-mporter@ti.com> <1359742975-10421-2-git-send-email-mporter@ti.com> <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com> <20130201184915.GP2244@beef> <510C1D0E.6030401@mvista.com> <20130201185820.GE29898@arwen.pp.htv.fi> <510C2A47.1090607@mvista.com> <20130201205600.GA31762@arwen.pp.htv.fi> <20130201213003.GW2637@n2100.arm.linux.org.uk> <20130204154153.GA18237@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204154153.GA18237@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 05:41:53PM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Feb 01, 2013 at 09:30:03PM +0000, Russell King - ARM Linux wrote:
> > > > > I guess to make the MUSB side simpler we would need musb-dma-engine glue
> > > > > to map dmaengine to the private MUSB API. Then we would have some
> > > > > starting point to also move inventra (and anybody else) to dmaengine
> > > > > API.
> > > > 
> > > >    Why? Inventra is a dedicated device's private DMA controller, why make
> > > > universal DMA driver for it?
> > > 
> > > because it doesn't make sense to support multiple DMA APIs. We can check
> > > from MUSB's registers if it was configured with Inventra DMA support and
> > > based on that we can register MUSB's own DMA Engine to dmaengine API.
> > 
> > Hang on.  This is one of the DMA implementations which is closely
> > coupled with the USB and only the USB?  If it is...
> > 
> > I thought this had been discussed _extensively_ before.  I thought the
> > resolution on it was:
> > 1. It would not use the DMA engine API.
> > 2. It would not live in arch/arm.
> > 3. It would be placed nearby the USB driver it's associated with.
> > 
> > (1) because we don't use APIs just for the hell of it - think.  Do we
> > use the DMA engine API for PCI bus mastering ethernet controllers?  No.
> > Do we use it for PCI bus mastering SCSI controllers?  No.  Because the
> > DMA is integral to the rest of the device.
> 
> that's not really a fair comparison, however. MUSB is used with several
> DMA engines.

I only mentioned it because it _was_ brought up as an argument against
using the DMA engine API in the previous discussions.  I'm just reminding
people what was discussed.

> Considering all of the above, it's far better to use DMA engine and get
> rid of all the mess.

Which is what both you and I have been saying for the last 3 or so years
on this subject...
