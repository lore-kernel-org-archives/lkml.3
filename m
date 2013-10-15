Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab3JOPrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:47:53 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:41274 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759319Ab3JOPrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:47:52 -0400
X-IronPort-AV: E=Sophos;i="4.93,500,1378857600"; 
   d="scan'208";a="61076898"
Date: Tue, 15 Oct 2013 16:46:55 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v8 02/17] arm64: define DMA_ERROR_CODE
In-Reply-To: <20131010094439.GE3817@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1310151646430.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310092109190.26077@kaball.uk.xensource.com> <1381351710-1876-2-git-send-email-stefano.stabellini@eu.citrix.com> <20131010094439.GE3817@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013, Will Deacon wrote:
> On Wed, Oct 09, 2013 at 09:48:15PM +0100, Stefano Stabellini wrote:
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > CC: will.deacon@arm.com
> > ---
> >  arch/arm64/include/asm/dma-mapping.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
> > index 8d18100..c2cb8a0 100644
> > --- a/arch/arm64/include/asm/dma-mapping.h
> > +++ b/arch/arm64/include/asm/dma-mapping.h
> > @@ -25,6 +25,7 @@
> >  
> >  #define ARCH_HAS_DMA_GET_REQUIRED_MASK
> >  
> > +#define DMA_ERROR_CODE	(~0)
> 
> Hmm, is this guaranteed to be large enough for a dma_addr_t? Other 64-bit
> architectures using a non-zero error code cast to dma_addr_t before the
> negation.

Good catch! I'll fix it.
