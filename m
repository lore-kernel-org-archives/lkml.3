Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaG1PsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:48:23 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60612 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaG1PsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:48:20 -0400
Date: Mon, 28 Jul 2014 10:48:14 -0500
From: rkuo <rkuo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ley Foon Tan <lftan@altera.com>, Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        linux-hexagon@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Subject: Re: [PATCH v2 13/29] nios2: DMA mapping API
Message-ID: <20140728154814.GA9179@codeaurora.org>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
 <4843763.ps2D25LEeM@wuerfel>
 <CAFiDJ582FiLAS=B13O3PV_d-FkR31j=5bN_LcXBSWkrGsHK_Gw@mail.gmail.com>
 <5059148.8xZUvoce2l@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5059148.8xZUvoce2l@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 02:05:16PM +0200, Arnd Bergmann wrote:
> > >> +void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
> > >> +                          size_t size, enum dma_data_direction direction)
> > >> +{
> > >> +     BUG_ON(!valid_dma_direction(direction));
> > >> +
> > >> +     __dma_sync(phys_to_virt(dma_handle), size, direction);
> > >> +}
> > >> +EXPORT_SYMBOL(dma_sync_single_for_cpu);
> > >> +
> > >> +void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
> > >> +                             size_t size, enum dma_data_direction direction)
> > >> +{
> > >> +     BUG_ON(!valid_dma_direction(direction));
> > >> +
> > >> +     __dma_sync(phys_to_virt(dma_handle), size, direction);
> > >> +}
> > >> +EXPORT_SYMBOL(dma_sync_single_for_device);
> > >
> > > More importantly: you do the same operation for both _for_cpu and _for_device.
> > > I assume your CPU can never do speculative cache prefetches, so it's not
> > > incorrect, but you do twice the number of invalidations and flushes that
> > > you need.
> > >
> > > Why would you do anything for _for_cpu here?
> > I am a bit confused for _for_cpu and _for_device here. I found some
> > architectures like c6x and hexagon have same operation for both
> > _for_cpu and _for_device as well.
> 
> (adding their maintainers to cc)
> 
> Yes, you are right, they seem to have the same bug and could see a noticeable
> DMA performance improvement if they change it as well.
> 

Yep that's a bug.  Thanks for pointing this out.


-Richard Kuo


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
