Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbaEIPcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:32:36 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:63875 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268AbaEIPcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:32:32 -0400
Date: Fri, 9 May 2014 09:32:26 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 4/5] iommu: Use dma_addr_t for IOVA arguments
Message-ID: <20140509153226.GA3571@google.com>
References: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <45161364.3Gyo1xJJLV@wuerfel>
 <20140508001814.GB4951@google.com>
 <15249748.Q2CaU9aBE9@wuerfel>
 <20140508203053.GA14448@google.com>
 <1399629530.879.21.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399629530.879.21.camel@i7.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 10:58:50AM +0100, David Woodhouse wrote:
> On Thu, 2014-05-08 at 14:30 -0600, Bjorn Helgaas wrote:
> > I doubt there would be a noticeable performance effect since these are
> > relatively low-frequency interfaces (map, unmap, report_fault), 
> 
> That point of view makes me sad.

Don't be sad; Arnd successfully fended off the challenge :)

> There are people who care deeply about the performance of IOMMU API
> map/unmap. It isn't used *just* for virtual machines any more. See
> drivers/infiniband/hw/usnic/usnic_uiom.c for example.

Of course we should care about IOMMU API performance.  We should also
care about interface consistency, and it seems there's a tradeoff in
this case.  I said "relatively" because I expect map/unmap to be less
frequent than read/write operations that use the mapping.  I don't
know anything about infiniband, so maybe that assumption is false
there.

> I also hold out *some* hope for consolidating the map/unmap functions
> for the IOMMU and DMA APIs at some point. The main difference is that
> the DMA API allocates an IOVA for itself, while the IOMMU API is given
> the bus address too.

I find this aspect of these APIs confusing, so I agree that it would
be nice if these could be consolidated somehow.

Bjorn
