Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3BDQzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:55:33 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:50659 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab3BDQzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:55:31 -0500
Message-ID: <510FF5C9.3030600@mvista.com>
Date: Mon, 04 Feb 2013 20:54:17 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: balbi@ti.com
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Matt Porter <mporter@ti.com>,
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
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to arm/common
References: <1359742975-10421-2-git-send-email-mporter@ti.com> <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com> <20130201184915.GP2244@beef> <510C1D0E.6030401@mvista.com> <20130201185820.GE29898@arwen.pp.htv.fi> <510C2A47.1090607@mvista.com> <20130201205600.GA31762@arwen.pp.htv.fi> <20130201213003.GW2637@n2100.arm.linux.org.uk> <20130204154153.GA18237@arwen.pp.htv.fi> <510FF1A6.403@mvista.com> <20130204164712.GB4269@arwen.pp.htv.fi>
In-Reply-To: <20130204164712.GB4269@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02/04/2013 07:47 PM, Felipe Balbi wrote:

> On Mon, Feb 04, 2013 at 08:36:38PM +0300, Sergei Shtylyov wrote:
>>> opted out of it. From the top of my head we have CPPI 3.x, CPPI 4.1,
>>> Inventra DMA, OMAP sDMA and ux500 DMA engines supported by the driver.

>>> Granted, CPPI 4.1 makes some assumptions about the fact that it's
>>> handling USB tranfers,

>>    What CPPI 4.1 code makes this assumptions? MUSB DMA driver? Then it's just

> HW makes the asumptions

   Not true at all. There is a separate set of registers (at offset 0) which
copes with USB specifics, but CPPI 4.1 itself doesn't know about USB anything.
It's just the way the driver was written that it used both sets of registers but
this needs to be changed into more abstacted accesses to the USB-specific part,
to cope with it being different on different platfroms, like AM35x. The driver
as it was last posted, just needs rework now.

>>> but nevertheless, the IP can be, and in fact is,
>>> used with many different DMA engines and driver needs to cope with it.

>>    What IP, CPPI 4.1 or MUSB?

> MUSB

>>> Current DMA abstraction is quite poor, for example there's no way to
>>> compile support for multiple DMA engines. Code also makes certain, IMO
>>> unnecessary, assumptions about the underlying DMA engine (abstraction is
>>> poor, as said above but it we could follow MUSB's programming guide when
>>> it comes to programming DMA transfers).

>>    Don't know, I was quite content with the abstraction when writing CPPI 4.1
>> driver for MUSB...

> look closer. The whole:

> if (is_cppi())
> 	foo();
> else if (is_inventra())
> 	bar();
> else if (is_omap_sdma())
> 	baz();

> is bogus.

   That part -- yes. There were attempt to get rid of this, but without changing
the DMA API. It was left halfway done after my only critical comment, IIRC. Will
we ever see the continuation of this effort?

>>> Considering all of the above, it's far better to use DMA engine and get
>>> rid of all the mess.

>>    In my eyes, getting rid of the mess doesn't justify breaking the rules that
>> Russell formulated above.

> MUSB is no PCI, there is no single, standard interface to the DMA
> engine (unlike Synopsys' dwc-usb3 and dwc-usb2, where we don't use DMA
> engine), every DMA engine comes with its own set of registers, its own
> programming model and so forth.

   Same can be said about PCI where each bus master has its own programming i/f
-- so I didn't really dig this example.

WBR, Sergei

