Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab3IFOS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:18:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23454 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3IFOS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:18:28 -0400
Date: Fri, 6 Sep 2013 10:17:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v5 12/13] swiotlb-xen: use xen_alloc/free_coherent_pages
Message-ID: <20130906141754.GT2590@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com>
 <1377801154-29215-12-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130830135333.GL21239@phenom.dumpdata.com>
 <alpine.DEB.2.02.1309051743450.6397@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309051743450.6397@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 05:50:45PM +0100, Stefano Stabellini wrote:
> On Fri, 30 Aug 2013, Konrad Rzeszutek Wilk wrote:
> > On Thu, Aug 29, 2013 at 07:32:33PM +0100, Stefano Stabellini wrote:
> > > Use xen_alloc_coherent_pages and xen_free_coherent_pages to allocate or
> > > free coherent pages.
> > > 
> > > We need to be careful handling the pointer returned by
> > > xen_alloc_coherent_pages, because on ARM the pointer is not equal to
> > > phys_to_virt(*dma_handle). In fact virt_to_phys on the returned pointer
> > > doesn't return a valid physical address.
> > 
> > Why is it called 'virt_to_phys'? What does it return then?
> 
> virt_to_phys only works for kernel direct mapped RAM memory.
> In this case the virtual address could be an ioremap address, therefore
> passing it to virt_to_phys would give you another physical address that
> doesn't correspond to it.

Ah, so very much ARM (and in some way SPARC) specific. I think you need add some comments
in the code (And git commit) to explain this. Thank you.
