Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab3BBACB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 19:02:01 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:52465 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab3BBAB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 19:01:58 -0500
Message-ID: <510C5761.7050401@mvista.com>
Date: Sat, 02 Feb 2013 04:01:37 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to arm/common
References: <1359742975-10421-1-git-send-email-mporter@ti.com> <1359742975-10421-2-git-send-email-mporter@ti.com> <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com> <20130201184915.GP2244@beef> <2077c13e12314dc3adc8e5b653855da0@DFLE72.ent.ti.com> <20130201185959.GQ2244@beef>
In-Reply-To: <20130201185959.GQ2244@beef>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01-02-2013 22:59, Matt Porter wrote:

>>>>> Move mach-davinci/dma.c to common/edma.c so it can be used
>>>>> by OMAP (specifically AM33xx) as well.

>>>> I think this should rather go to drivers/dma/?

>>> No, this is the private EDMA API. It's the analogous thing to
>>> the private OMAP dma API that is in plat-omap/dma.c. The actual
>>> dmaengine driver is in drivers/dma/edma.c as a wrapper around
>>> this...same way OMAP DMA engine conversion is being done.

>>    Keeps me wondering why we couldn't have the same with CPPI 4.1 when I proposed
>> that, instead of waiting indefinitely for TI to convert it to drivers/dma/
>> directly. We could have working MUSB DMA on OMAP-L1x/Sitara all this time... Sigh.

> That is a shame. Yeah, I've pointed out that I was doing this exactly
> the same way as was acceptable for the OMAP DMA conversion since it was
> in RFC. The reasons are sound since in both cases, we have many drivers
> to convert that need to continue using the private DMA APIs.

    In case of CPPI 4.1, we'd only have to convert MUSB DMA driver. Other 
in-tree CPPI 4.1 having SoCs don't use it for anything but MUSB -- it even is 
sub-block of their MUSB device, AFAIK (I maybe wrong about Sitaras -- I don't 
know them well).

> -Matt

WBR, Sergei

