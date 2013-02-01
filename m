Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab3BAVeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 16:34:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33406 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605Ab3BAVeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 16:34:03 -0500
Date: Fri, 1 Feb 2013 21:30:03 +0000
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
Message-ID: <20130201213003.GW2637@n2100.arm.linux.org.uk>
References: <1359742975-10421-1-git-send-email-mporter@ti.com> <1359742975-10421-2-git-send-email-mporter@ti.com> <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com> <20130201184915.GP2244@beef> <510C1D0E.6030401@mvista.com> <20130201185820.GE29898@arwen.pp.htv.fi> <510C2A47.1090607@mvista.com> <20130201205600.GA31762@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130201205600.GA31762@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 10:56:00PM +0200, Felipe Balbi wrote:
> hi,
> 
> On Fri, Feb 01, 2013 at 11:49:11PM +0300, Sergei Shtylyov wrote:
> > > good point, do you wanna send some patches ?
> > 
> >    I have already sent them countless times and even stuck CPPI 4.1 support (in
> > arch/arm/common/cppi41.c) in Russell's patch system. TI requested to remove the
> > patch. :-(
> 
> sticking into arch/arm/common/ wasn't a nice move. But then again, so
> wasn't asking for the patch to be removed :-s

Err, patches don't get removed, they get moved to 'discarded'.

> > > I guess to make the MUSB side simpler we would need musb-dma-engine glue
> > > to map dmaengine to the private MUSB API. Then we would have some
> > > starting point to also move inventra (and anybody else) to dmaengine
> > > API.
> > 
> >    Why? Inventra is a dedicated device's private DMA controller, why make
> > universal DMA driver for it?
> 
> because it doesn't make sense to support multiple DMA APIs. We can check
> from MUSB's registers if it was configured with Inventra DMA support and
> based on that we can register MUSB's own DMA Engine to dmaengine API.

Hang on.  This is one of the DMA implementations which is closely
coupled with the USB and only the USB?  If it is...

I thought this had been discussed _extensively_ before.  I thought the
resolution on it was:
1. It would not use the DMA engine API.
2. It would not live in arch/arm.
3. It would be placed nearby the USB driver it's associated with.

(1) because we don't use APIs just for the hell of it - think.  Do we
use the DMA engine API for PCI bus mastering ethernet controllers?  No.
Do we use it for PCI bus mastering SCSI controllers?  No.  Because the
DMA is integral to the rest of the device.

The DMA engine API only makes sense if the DMA engine is a shared
system resource.
