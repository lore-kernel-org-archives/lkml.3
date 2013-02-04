Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3BDRLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:11:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34942 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3BDRLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:11:31 -0500
Date: Mon, 4 Feb 2013 17:10:59 +0000
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
Message-ID: <20130204171059.GE2637@n2100.arm.linux.org.uk>
References: <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com> <20130201184915.GP2244@beef> <510C1D0E.6030401@mvista.com> <20130201185820.GE29898@arwen.pp.htv.fi> <510C2A47.1090607@mvista.com> <20130201205600.GA31762@arwen.pp.htv.fi> <20130201213003.GW2637@n2100.arm.linux.org.uk> <20130204154153.GA18237@arwen.pp.htv.fi> <510FF1A6.403@mvista.com> <20130204164712.GB4269@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204164712.GB4269@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 06:47:12PM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Feb 04, 2013 at 08:36:38PM +0300, Sergei Shtylyov wrote:
> >    In my eyes, getting rid of the mess doesn't justify breaking the rules that
> > Russell formulated above.
> 
> MUSB is no PCI, there is no single, standard interface to the DMA
> engine (unlike Synopsys' dwc-usb3 and dwc-usb2, where we don't use DMA
> engine), every DMA engine comes with its own set of registers, its own
> programming model and so forth.

Err, before you get too wrapped up in that argument... if you think there's
anything like a common hardware interface for DMA on PCI, you'd be wrong.
There isn't.

What there is is a bus protocol for it.  How the device decides to perform
DMA is up to the device; there's no standard register definitions across
all devices.  Yes, some classes have a standard register set (like USB,
and ATA) but others are totally device specific (eg, network chips).

However, on PCI, the DMA support is always integrated with the rest of
the device itself.  That is not the case here.

So, bringing PCI up into this discussion is totally irrelevant.  As I've
already explained, this was brought up in the _previous_ discussion as
a reason why _not_ to use the DMA engine API for this.

So, can we please leave PCI totally out of this?  It didn't belong here
2-3 years ago, and it sure enough doesn't belong here now.  It's nothing
but pure distraction.  And the more this goes on, the more I can see,
yet again, the CPPI 4.1 going nowhere at all.

As I can see it, there's nothing more to talk about.  The issue has been
extensively talked to death.  What it needs now is not _more_ talk, it
needs someone to actually go and _do_ something useful with it.

I realise that may be difficult given the mess that TI must still be in
internally since the upheaval of OMAP, but it sounds like there's a
different group needing this stuff to work...
