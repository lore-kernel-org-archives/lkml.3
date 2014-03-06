Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaCFTs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:48:29 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42582 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751444AbaCFTs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:48:28 -0500
Date: Thu, 6 Mar 2014 14:48:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dan Williams <dan.j.williams@intel.com>
cc: Dave Jones <davej@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: uhci_hcd: DMA-API: cpu touching an active dma mapped cacheline
In-Reply-To: <CAPcyv4iqno9r_AvhQShSz1mN=4wEBv7Ld1fwG9x4um7KmfdWxA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1403061443110.961-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014, Dan Williams wrote:

> >>> Mapped at:
> >>>  [<c13081b5>] debug_dma_alloc_coherent+0x2b/0xc3
> >>>  [<c116fcee>] dma_pool_alloc+0x14f/0x2fd
> >>>  [<c1456eaa>] uhci_alloc_td.isra.35+0x24/0x60
> >>>  [<c1457fa6>] uhci_start+0x272/0x56b
> >>>  [<c142d8fb>] usb_add_hcd+0x252/0x774
> >>
> >> I don't get it.  As the name indicates, debug_dma_alloc_coherent should
> >> give us consistent memory -- meaning that the CPU is allowed to access
> >> the memory while DMA is in progress, without worrying about caching
> >> effects (see Documentation/DMA-API.txt).
> >>
> >> So why should we get a warning when the CPU accesses this memory?  Is
> >> this a regression in the DMA debug library?
> >
> > Yes, it seems so.  alloc_coherent needs to be exempt from active
> > mapping tracking.  Fix coming up.
> >
> 
> Actually I'm not so sure.  Yes, alloc_coherent means the cpu can
> touch, but if that page is COW'd how can you be sure that the copy
> gets the most up to date data from the device?  This check is
> asserting that dma might be colliding with a copy-on-write event.

dma_pool_create should never return memory that requires COW.  How 
would the system know when to do the copies?

Alan Stern

