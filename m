Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaCMIxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:53:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:58682 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaCMIxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:53:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
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
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
Date: Thu, 13 Mar 2014 09:52:17 +0100
Message-ID: <4757683.7Ln0Vh5c4G@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACRpkdZrRYY0U5zDwoKRarAH=W6UmxGKX_gWR6nYPM64t6Dzpg@mail.gmail.com>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com> <1394463171.2270.54.camel@shinybook.infradead.org> <CACRpkdZrRYY0U5zDwoKRarAH=W6UmxGKX_gWR6nYPM64t6Dzpg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:tig444sQHXgFQT44F0iVKg+efLc2RVUWbrPRdoMrrQG
 xpWsjsvIjugopHsqSex4RfJIPZ7XBKMMnUDrZsjWgcpMApEaCX
 UNLpieEB/GRlGAw0It6zmZym6nmV29GOb2RAqEpfU3xcJ+pvQ3
 36Y90f5jwJ0Pn5L58YPEHFg+df3WAxqU8faEvhpdyvRGAkezVC
 DMqXHPqGJB/+qodVfDr8Npn1n+/nLLUYbxWl1Iog0OCJI3KaL1
 Y3b2DVW9oWAfbZ2+dajD7vGJX6ad33JMThJmrkt9RSBmWWGCvq
 Tmbuch8lBP8czTNzLFDollcsaVxZDSYCMS7oEadpIrr681b53E
 CnWAUcESGq5+Zm65vJnw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2014 09:17:04 Linus Walleij wrote:
> 
> Again as Russell stated that doesn't necessarily influence any memory
> coherency or the physical address pointer written into the DMAC
> hardware at all, does it? The transfers can still happen between the
> peripheral and DMAC, and the IOMMU can still be sitting in the middle
> of things, in front of the DMAC not the device, needing to be flushed etc.
> 
> Sorry if I don't get it... maybe this is one of these funny Intel things
> I cannot wrap my head around properly.

The device pointer we pass into dma_map_* can be used for anything that
the underlying dma_map_ops implementation requires. This includes
determining:

* coherency
* offsets between bus and cpu physical address
* presence of IOMMU
* limits in available bus address space (dma_mask)
* iommu context ID (normally the location on the PCI bus)

The difference is that on ARM we usually care about the first
four, which may be different for each device. The case that Dave is
interested in is when these four are known implicitly but the fifth
one is not know but depends on the slave device.

	Arnd
