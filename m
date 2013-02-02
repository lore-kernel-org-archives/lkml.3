Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab3BBAOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 19:14:20 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:50832 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab3BBAOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 19:14:18 -0500
Message-ID: <510C5A45.5050802@mvista.com>
Date: Sat, 02 Feb 2013 04:13:57 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Felipe Balbi <balbi@ti.com>, Matt Porter <mporter@ti.com>,
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
References: <1359742975-10421-1-git-send-email-mporter@ti.com> <1359742975-10421-2-git-send-email-mporter@ti.com> <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com> <20130201184915.GP2244@beef> <510C1D0E.6030401@mvista.com> <20130201185820.GE29898@arwen.pp.htv.fi> <510C2A47.1090607@mvista.com> <20130201205600.GA31762@arwen.pp.htv.fi> <20130201213003.GW2637@n2100.arm.linux.org.uk>
In-Reply-To: <20130201213003.GW2637@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02-02-2013 1:30, Russell King - ARM Linux wrote:

>> On Fri, Feb 01, 2013 at 11:49:11PM +0300, Sergei Shtylyov wrote:
>>>> good point, do you wanna send some patches ?

>>>     I have already sent them countless times and even stuck CPPI 4.1 support (in
>>> arch/arm/common/cppi41.c) in Russell's patch system. TI requested to remove the
>>> patch. :-(

>> sticking into arch/arm/common/ wasn't a nice move. But then again, so
>> wasn't asking for the patch to be removed :-s

> Err, patches don't get removed, they get moved to 'discarded'.

>>>> I guess to make the MUSB side simpler we would need musb-dma-engine glue
>>>> to map dmaengine to the private MUSB API. Then we would have some
>>>> starting point to also move inventra (and anybody else) to dmaengine
>>>> API.

>>>     Why? Inventra is a dedicated device's private DMA controller, why make
>>> universal DMA driver for it?

>> because it doesn't make sense to support multiple DMA APIs. We can check
>> from MUSB's registers if it was configured with Inventra DMA support and
>> based on that we can register MUSB's own DMA Engine to dmaengine API.

> Hang on.  This is one of the DMA implementations which is closely
> coupled with the USB and only the USB?  If it is...

> I thought this had been discussed _extensively_ before.  I thought the
> resolution on it was:
> 1. It would not use the DMA engine API.
> 2. It would not live in arch/arm.
> 3. It would be placed nearby the USB driver it's associated with.

    Note that all this doesn't apply to CPPI 4.1 controller (as contrasted to 
CPPI 3.0 support in MUSB aand EMAC drivers) -- it's shared by design. Just the 
implementations that are in tree have it as MUSB's sub-block, serving only MUSB.

WBR, Sergei

