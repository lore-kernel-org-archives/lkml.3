Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaJJNGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 09:06:32 -0400
Received: from smtp.citrix.com ([66.165.176.89]:33121 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbaJJNG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 09:06:29 -0400
X-IronPort-AV: E=Sophos;i="5.04,692,1406592000"; 
   d="scan'208";a="180136789"
Date: Fri, 10 Oct 2014 14:04:10 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
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
In-Reply-To: <20141010120702.GI7755@arm.com>
Message-ID: <alpine.DEB.2.02.1410101401250.17038@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com> <1412941908-5850-3-git-send-email-stefano.stabellini@eu.citrix.com> <20141010120702.GI7755@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2014, Will Deacon wrote:
> On Fri, Oct 10, 2014 at 12:51:44PM +0100, Stefano Stabellini wrote:
> > Introduce a function to check whether a device is dma coherent.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > CC: linux@arm.linux.org.uk
> > CC: catalin.marinas@arm.com
> > CC: will.deacon@arm.com
> > CC: linux-arm-kernel@lists.infradead.org
> > ---
> >  arch/arm/include/asm/dma-mapping.h   |    6 ++++++
> >  arch/arm64/include/asm/dma-mapping.h |    5 +++++
> >  2 files changed, 11 insertions(+)
> > 
> > diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> > index c45b61a..bededbb 100644
> > --- a/arch/arm/include/asm/dma-mapping.h
> > +++ b/arch/arm/include/asm/dma-mapping.h
> > @@ -126,6 +126,12 @@ static inline int set_arch_dma_coherent_ops(struct device *dev)
> >  	set_dma_ops(dev, &arm_coherent_dma_ops);
> >  	return 0;
> >  }
> > +
> > +static inline bool is_dma_coherent(struct device *dev)
> > +{
> > +    return (__generic_dma_ops(dev) == &arm_coherent_dma_ops);
> > +}
> 
> Hmm, what about the IOMMU ops?

Maybe I should check __generic_dma_ops(dev) != &arm_dma_ops?
Do you have any better suggestions?
