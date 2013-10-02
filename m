Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3JBRIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:08:48 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50658 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753987Ab3JBRIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:08:47 -0400
Date: Wed, 2 Oct 2013 18:07:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v6 10/19] xen: introduce xen_alloc/free_coherent_pages
Message-ID: <20131002170747.GG29794@arm.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
 <1380298207-29151-10-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130930153143.GQ3106@phenom.dumpdata.com>
 <DB675896-3FF2-409B-A2C6-24295C197A3F@arm.com>
 <alpine.DEB.2.02.1310021754580.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1310021754580.26077@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 06:03:46PM +0100, Stefano Stabellini wrote:
> On Tue, 1 Oct 2013, Catalin Marinas wrote:
> > On 30 Sep 2013, at 16:31, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > > On Fri, Sep 27, 2013 at 05:09:58PM +0100, Stefano Stabellini wrote:
> > >> xen_swiotlb_alloc_coherent needs to allocate a coherent buffer for cpu
> > >> and devices. On native x86 and ARMv8 is sufficient to call
> > >> __get_free_pages in order to get a coherent buffer, while on ARM we need
> > >> to call the native dma_ops->alloc implementation.
> > >> 
> > >> When arm64 stops using the swiotlb by default and starts having multiple
> > >> dma_ops implementations, we'll use __get_dma_ops there too.
> > > 
> > > I presume this is a future TODO, not some further patch (in which
> > > case you should say in here the title of it). If it is a TODO could
> > > you stick that in the sentence here somewhere to make it crytal clear that
> > > it is not implemented.
> > 
> > Thanks for pointing this out.  The arm64 patch shouldn't be different
> > from arm here.  I thought a subsequent patch already added
> > __get_dma_ops() for arm64.
> 
> Yes, the arm64 patch already added __get_dma_ops.
> 
> However I am not using __get_dma_ops to implement
> xen_alloc_coherent_pages for arm64 because I can just use
> __get_free_pages for the moment:

So why do the work twice when we'll get coherency maintenance in the DMA
ops?

-- 
Catalin
