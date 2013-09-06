Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab3IFOPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:15:25 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53146 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751491Ab3IFOPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:15:24 -0400
Date: Fri, 6 Sep 2013 15:14:44 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v5 11/13] xen: introduce xen_alloc/free_coherent_pages
Message-ID: <20130906141444.GE1946@arm.com>
References: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com>
 <1377801154-29215-11-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130905160905.GI11887@arm.com>
 <alpine.DEB.2.02.1309051742390.6397@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309051742390.6397@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 05:43:33PM +0100, Stefano Stabellini wrote:
> On Thu, 5 Sep 2013, Catalin Marinas wrote:
> > On Thu, Aug 29, 2013 at 07:32:32PM +0100, Stefano Stabellini wrote:
> > > xen_swiotlb_alloc_coherent needs to allocate a coherent buffer for cpu
> > > and devices. On native x86 and ARMv8 is sufficient to call
> > > __get_free_pages in order to get a coherent buffer, while on ARM we need
> > > to call arm_dma_ops.alloc.
> > 
> > Don't bet on this for ARMv8. It's not mandated for the architecture, so
> > at some point some SoC will require non-cacheable buffers for coherency.
> 
> I see.
> Would it be better if I implemented xen_alloc_coherent_pages on armv8 by
> calling arm64_swiotlb_dma_ops.alloc?

What does this buffer do exactly? Is it allocated by guests?

Currently arm64_swiotlb_dma_ops assume cache-coherent DMA. I have a
patch which introduces new ops for non-coherent DMA but this should
really be orthogonal to swiotlb. You can basically have 4 combinations
of coherent/non-coherent and swiotlb/iommu. Mark Rutland is currently
looking into how best to describe this via DT as it may not even be per
SoC but per bus or device.

-- 
Catalin
