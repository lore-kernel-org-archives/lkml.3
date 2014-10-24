Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbaJXXde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 19:33:34 -0400
Received: from 8bytes.org ([81.169.241.247]:54287 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbaJXXdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 19:33:32 -0400
Date: Sat, 25 Oct 2014 01:33:29 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com
Subject: Re: [PATCH linux-next] iommu: add iommu for s390 platform
Message-ID: <20141024233329.GA6202@8bytes.org>
References: <1413892645-37657-1-git-send-email-blaschka@linux.vnet.ibm.com>
 <20141022141728.GG10074@8bytes.org>
 <20141022154320.GA42442@tuxmaker.boeblingen.de.ibm.com>
 <20141023124115.GB10053@8bytes.org>
 <20141023140437.GA31009@tuxmaker.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023140437.GA31009@tuxmaker.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On Thu, Oct 23, 2014 at 04:04:37PM +0200, Frank Blaschka wrote:
> > A domain is basically an abstraction for a DMA page table (or a
> > dma_table, as you call it on s390). So you can easily create similar
> > mappings for more than one device with it.
> >
> the clp instructions reports a start/end dma address for the pci device.
> on my system all devices report:
> 
> sdma = 0x100000000;
> edma = 0x1ffffffffffffff;

These values need to be reported through the IOMMU-API, so that the
users know which address ranges they can map.

> dma mappings are created for each device separately starting from 0x100000000
> and filling the the VIOA space for this device (until 0x1ffffffffffffff)
> 
> If we would like to have more then one device per domain I think:
> 
> we would have to slice the IOVA address space (0x100000000 - 0x1ffffffffffffff)
> of the domain and report only a slice to the pci device (clp)
> The iommu code would have to find the device by the dma (VIOA) address
> and then program the entry to the table of the particular device (and only this
> device).

Why do you need to splice an address space when more than one device is
assigned to it? Does that come from the hardware?

Usually its not problematic when devices share an address space. The
partitioning of that address-space between devices is done by an address
allocator which works on small chunks of memory (io-page-size
granularity).

But such an address allocator is part of the DMA-API, the IOMMU-API
which you implement here only cares about the mappings itself, not about
address allocation.


	Joerg

