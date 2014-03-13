Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaCMOfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:35:52 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:59508 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbaCMOfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:35:51 -0400
MIME-Version: 1.0
In-Reply-To: <4757683.7Ln0Vh5c4G@wuerfel>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<1394463171.2270.54.camel@shinybook.infradead.org>
	<CACRpkdZrRYY0U5zDwoKRarAH=W6UmxGKX_gWR6nYPM64t6Dzpg@mail.gmail.com>
	<4757683.7Ln0Vh5c4G@wuerfel>
Date: Thu, 13 Mar 2014 15:35:50 +0100
Message-ID: <CACRpkdZALBWJAFc5j_KpXc1iahkYNYp0B3q5v1Rj8w+MknoHzQ@mail.gmail.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Koul, Vinod" <vinod.koul@intel.com>, yuanyabin1978@sina.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        "Krogerus, Heikki" <heikki.krogerus@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 9:52 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 13 March 2014 09:17:04 Linus Walleij wrote:
>>
>> Again as Russell stated that doesn't necessarily influence any memory
>> coherency or the physical address pointer written into the DMAC
>> hardware at all, does it? The transfers can still happen between the
>> peripheral and DMAC, and the IOMMU can still be sitting in the middle
>> of things, in front of the DMAC not the device, needing to be flushed etc.
>>
>> Sorry if I don't get it... maybe this is one of these funny Intel things
>> I cannot wrap my head around properly.
>
> The device pointer we pass into dma_map_* can be used for anything that
> the underlying dma_map_ops implementation requires. This includes
> determining:
>
> * coherency
> * offsets between bus and cpu physical address
> * presence of IOMMU
> * limits in available bus address space (dma_mask)
> * iommu context ID (normally the location on the PCI bus)
>
> The difference is that on ARM we usually care about the first
> four, which may be different for each device. The case that Dave is
> interested in is when these four are known implicitly but the fifth
> one is not know but depends on the slave device.

Ahhh I get it. But the topological question remains I guess...

ARM buses have something like bus master IDs I think (usually
only visible to the hardware) I guess it fills a similar purpose thoug
we never really see it from the OS side.

Yours,
Linus Walleij
