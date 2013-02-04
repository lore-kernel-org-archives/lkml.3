Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab3BDQh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:37:56 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:42978 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465Ab3BDQhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:37:52 -0500
Message-ID: <510FF1A6.403@mvista.com>
Date: Mon, 04 Feb 2013 20:36:38 +0300
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
References: <1359742975-10421-1-git-send-email-mporter@ti.com> <1359742975-10421-2-git-send-email-mporter@ti.com> <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com> <20130201184915.GP2244@beef> <510C1D0E.6030401@mvista.com> <20130201185820.GE29898@arwen.pp.htv.fi> <510C2A47.1090607@mvista.com> <20130201205600.GA31762@arwen.pp.htv.fi> <20130201213003.GW2637@n2100.arm.linux.org.uk> <20130204154153.GA18237@arwen.pp.htv.fi>
In-Reply-To: <20130204154153.GA18237@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02/04/2013 06:41 PM, Felipe Balbi wrote:

>>>>> I guess to make the MUSB side simpler we would need musb-dma-engine glue
>>>>> to map dmaengine to the private MUSB API. Then we would have some
>>>>> starting point to also move inventra (and anybody else) to dmaengine
>>>>> API.

>>>>    Why? Inventra is a dedicated device's private DMA controller, why make
>>>> universal DMA driver for it?

>>> because it doesn't make sense to support multiple DMA APIs. We can check
>>> from MUSB's registers if it was configured with Inventra DMA support and
>>> based on that we can register MUSB's own DMA Engine to dmaengine API.

>> Hang on.  This is one of the DMA implementations which is closely
>> coupled with the USB and only the USB?  If it is...

>> I thought this had been discussed _extensively_ before.  I thought the
>> resolution on it was:
>> 1. It would not use the DMA engine API.
>> 2. It would not live in arch/arm.
>> 3. It would be placed nearby the USB driver it's associated with.

>> (1) because we don't use APIs just for the hell of it - think.  Do we
>> use the DMA engine API for PCI bus mastering ethernet controllers?  No.
>> Do we use it for PCI bus mastering SCSI controllers?  No.  Because the
>> DMA is integral to the rest of the device.

> that's not really a fair comparison, however. MUSB is used with several
> DMA engines.

> The only DMA engine which is really coupled with MUSB is the Inventra
> DMA engine which comes as an optional feature to the IP. Many users have

   That's not quite true. At least CPPI 3.0 is coupled with MUSB as well. The
programming interface is MUSB specific, and differs from that of the EMAC driver
which also uses CPPI 3.0 (however, the DMA descriptor format is the same between
both, IIRC).

> opted out of it. From the top of my head we have CPPI 3.x, CPPI 4.1,
> Inventra DMA, OMAP sDMA and ux500 DMA engines supported by the driver.

> Granted, CPPI 4.1 makes some assumptions about the fact that it's
> handling USB tranfers,

   What CPPI 4.1 code makes this assumptions? MUSB DMA driver? Then it's just
natural. Generic CPPI 4.1 support code (as was posted for both mach-dacinci/ or
common/ placement) made no such assumptions.

> but nevertheless, the IP can be, and in fact is,
> used with many different DMA engines and driver needs to cope with it.

   What IP, CPPI 4.1 or MUSB?

> Current DMA abstraction is quite poor, for example there's no way to
> compile support for multiple DMA engines. Code also makes certain, IMO
> unnecessary, assumptions about the underlying DMA engine (abstraction is
> poor, as said above but it we could follow MUSB's programming guide when
> it comes to programming DMA transfers).

   Don't know, I was quite content with the abstraction when writing CPPI 4.1
driver for MUSB...

> Considering all of the above, it's far better to use DMA engine and get
> rid of all the mess.

   In my eyes, getting rid of the mess doesn't justify breaking the rules that
Russell formulated above.

WBR, Sergei

