Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab3ILNyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:54:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33325 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899Ab3ILNyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:54:33 -0400
Date: Thu, 12 Sep 2013 14:53:47 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v5 11/13] xen: introduce xen_alloc/free_coherent_pages
Message-ID: <20130912135347.GA23425@darko.cambridge.arm.com>
References: <20130906141444.GE1946@arm.com>
 <alpine.DEB.2.02.1309061554260.6397@kaball.uk.xensource.com>
 <20130906155928.GH1946@arm.com>
 <alpine.DEB.2.02.1309061706480.6397@kaball.uk.xensource.com>
 <20130906162018.GJ1946@arm.com>
 <alpine.DEB.2.02.1309061740050.6397@kaball.uk.xensource.com>
 <8492887B-2509-42B5-A5F9-A711C519D912@arm.com>
 <alpine.DEB.2.02.1309091732230.6397@kaball.uk.xensource.com>
 <20130911093646.GA26777@darko.cambridge.arm.com>
 <alpine.DEB.2.02.1309111825210.32236@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309111825210.32236@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 06:34:17PM +0100, Stefano Stabellini wrote:
> On Wed, 11 Sep 2013, Catalin Marinas wrote:
> >  static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
> >  {
> >  	BUG_ON(!dev);
> > @@ -32,7 +39,7 @@ static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
> >  
> >  static inline int dma_set_mask(struct device *dev, u64 mask)
> >  {
> > -	return get_dma_ops(dev)->set_dma_mask(dev, mask);
> > +	return __get_dma_ops(dev)->set_dma_mask(dev, mask);
> >  }
> >  
> >  #ifdef __arch_page_to_dma
> 
> I don't understand the reason for this change though: shouldn't
> set_dma_mask go via the "default" (whatever that is), like the others?

Under Xen, this would mean xen_dma_ops->set_dma_mask(). I thought you
want to set the default dma address.

I can see why you may want set_dma_mask() for xen_dma_ops but in also
needs to be passed to __get_dma_ops(dev)->set_dma_ops() otherwise the
actual dma_alloc_attrs() will miss the mask (and on arm64 it does
bouncing via swiotlb).

-- 
Catalin
