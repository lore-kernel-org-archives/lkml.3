Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab3BATu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 14:50:29 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:40306 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab3BATu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 14:50:27 -0500
Message-ID: <510C2A47.1090607@mvista.com>
Date: Fri, 01 Feb 2013 23:49:11 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: balbi@ti.com
CC: Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
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
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to arm/common
References: <1359742975-10421-1-git-send-email-mporter@ti.com> <1359742975-10421-2-git-send-email-mporter@ti.com> <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com> <20130201184915.GP2244@beef> <510C1D0E.6030401@mvista.com> <20130201185820.GE29898@arwen.pp.htv.fi>
In-Reply-To: <20130201185820.GE29898@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02/01/2013 09:58 PM, Felipe Balbi wrote:

>>>>> Move mach-davinci/dma.c to common/edma.c so it can be used
>>>>> by OMAP (specifically AM33xx) as well.

>>>> I think this should rather go to drivers/dma/?

>>> No, this is the private EDMA API. It's the analogous thing to
>>> the private OMAP dma API that is in plat-omap/dma.c. The actual
>>> dmaengine driver is in drivers/dma/edma.c as a wrapper around
>>> this...same way OMAP DMA engine conversion is being done.

>>   Keeps me wondering why we couldn't have the same with CPPI 4.1 when I proposed
>> that, instead of waiting indefinitely for TI to convert it to drivers/dma/
>> directly. We could have working MUSB DMA on OMAP-L1x/Sitara all this time... Sigh.

> good point, do you wanna send some patches ?

   I have already sent them countless times and even stuck CPPI 4.1 support (in
arch/arm/common/cppi41.c) in Russell's patch system. TI requested to remove the
patch. :-(

> I guess to make the MUSB side simpler we would need musb-dma-engine glue
> to map dmaengine to the private MUSB API. Then we would have some
> starting point to also move inventra (and anybody else) to dmaengine
> API.

   Why? Inventra is a dedicated device's private DMA controller, why make
universal DMA driver for it?

> Once that's done, we drop MUSB's private API.

   Don't think it's a good idea.

WBR, Sergei

