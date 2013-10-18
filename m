Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab3JRPs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:48:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41406 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab3JRPs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:48:57 -0400
Date: Fri, 18 Oct 2013 16:48:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, konrad.wilk@oracle.com,
        Ian.Campbell@citrix.com, will.deacon@arm.com
Subject: Re: [PATCH v8 08/19] arm/xen: get_dma_ops: return xen_dma_ops if
	we are running as xen_initial_domain
Message-ID: <20131018154847.GD25034@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com> <1382031814-8782-8-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1310181319300.26077@kaball.uk.xensource.com> <20131018154246.GB25034@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1310181643260.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1310181643260.26077@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 04:46:00PM +0100, Stefano Stabellini wrote:
> On Fri, 18 Oct 2013, Russell King - ARM Linux wrote:
> > On Fri, Oct 18, 2013 at 01:22:18PM +0100, Stefano Stabellini wrote:
> > > Russell,
> > > are you OK with this patch?
> > 
> > Only concern is why the change is soo large.
> > 
> > > > -static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> > > > +static inline struct dma_map_ops *__generic_dma_ops(struct device *dev)
> > > >  {
> > > >  	if (dev && dev->archdata.dma_ops)
> > > >  		return dev->archdata.dma_ops;
> > > >  	return &arm_dma_ops;
> > > >  }
> > > >  
> > > > +static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> > > > +{
> > > > +	if (xen_initial_domain())
> > > > +		return xen_dma_ops;
> > > > +	else
> > > > +		return __generic_dma_ops(dev);
> > > > +}
> > > > +
> > 
> > What's wrong with:
> > 
> >  static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> >  {
> > +	if (xen_initial_domain())
> > +		return xen_dma_ops;
> >  	if (dev && dev->archdata.dma_ops)
> >  		return dev->archdata.dma_ops;
> >  	return &arm_dma_ops;
> >  }
> 
> 
> xen_dma_ops functions might have to call back the native implementation.
> With the above there is no way for a xen_dma_ops function to get to
> archdata.dma_ops or arm_dma_ops.
> This is the reason why this patch introduces __generic_dma_ops.

Ah, that's fine then, but having that described in the commit message
would be useful.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks.
