Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaJVQMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:12:09 -0400
Received: from smtp.citrix.com ([66.165.176.89]:8497 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199AbaJVQME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:12:04 -0400
X-IronPort-AV: E=Sophos;i="5.04,769,1406592000"; 
   d="scan'208";a="183907094"
Date: Wed, 22 Oct 2014 17:04:13 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Will Deacon <will.deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH v4 3/7] [RFC] arm/arm64: introduce is_dma_coherent
In-Reply-To: <alpine.DEB.2.02.1410131358490.17038@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1410221703560.876@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com> <1412941908-5850-3-git-send-email-stefano.stabellini@eu.citrix.com> <20141010120702.GI7755@arm.com> <alpine.DEB.2.02.1410101401250.17038@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1410131215400.17038@kaball.uk.xensource.com> <20141013125725.GA19156@arm.com> <alpine.DEB.2.02.1410131358490.17038@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2014, Stefano Stabellini wrote:
> On Mon, 13 Oct 2014, Will Deacon wrote:
> > On Mon, Oct 13, 2014 at 12:16:14PM +0100, Stefano Stabellini wrote:
> > > On Fri, 10 Oct 2014, Stefano Stabellini wrote:
> > > > On Fri, 10 Oct 2014, Will Deacon wrote:
> > > > > On Fri, Oct 10, 2014 at 12:51:44PM +0100, Stefano Stabellini wrote:
> > > > > > Introduce a function to check whether a device is dma coherent.
> > > > > > 
> > > > > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > > > > CC: linux@arm.linux.org.uk
> > > > > > CC: catalin.marinas@arm.com
> > > > > > CC: will.deacon@arm.com
> > > > > > CC: linux-arm-kernel@lists.infradead.org
> > > > > > ---
> > > > > >  arch/arm/include/asm/dma-mapping.h   |    6 ++++++
> > > > > >  arch/arm64/include/asm/dma-mapping.h |    5 +++++
> > > > > >  2 files changed, 11 insertions(+)
> > > > > > 
> > > > > > diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> > > > > > index c45b61a..bededbb 100644
> > > > > > --- a/arch/arm/include/asm/dma-mapping.h
> > > > > > +++ b/arch/arm/include/asm/dma-mapping.h
> > > > > > @@ -126,6 +126,12 @@ static inline int set_arch_dma_coherent_ops(struct device *dev)
> > > > > >  	set_dma_ops(dev, &arm_coherent_dma_ops);
> > > > > >  	return 0;
> > > > > >  }
> > > > > > +
> > > > > > +static inline bool is_dma_coherent(struct device *dev)
> > > > > > +{
> > > > > > +    return (__generic_dma_ops(dev) == &arm_coherent_dma_ops);
> > > > > > +}
> > > > > 
> > > > > Hmm, what about the IOMMU ops?
> > > > 
> > > > Maybe I should check __generic_dma_ops(dev) != &arm_dma_ops?
> > > > Do you have any better suggestions?
> > > 
> > > ping?
> > 
> > Without any clear idea about why this is needed or how it's used, I don't
> > have any better ideas.
> 
> Thanks for the quick reply.
> 
> It is used in dom0 to figure out whether the device is not coherent: in
> that case Dom0 is going to issue an hypercall and Xen is going to
> execute the required cache maintenance operations on Dom0's behalf.
> 
> In practice for this use case iommu_dma_ops is not a problem, as the
> device is never going to appear as being behind an SMMU in dom0.

re-ping?
