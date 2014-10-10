Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaJJMHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 08:07:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50930 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbaJJMH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 08:07:29 -0400
Date: Fri, 10 Oct 2014 13:07:03 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH v4 3/7] [RFC] arm/arm64: introduce is_dma_coherent
Message-ID: <20141010120702.GI7755@arm.com>
References: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com>
 <1412941908-5850-3-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412941908-5850-3-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 12:51:44PM +0100, Stefano Stabellini wrote:
> Introduce a function to check whether a device is dma coherent.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: linux@arm.linux.org.uk
> CC: catalin.marinas@arm.com
> CC: will.deacon@arm.com
> CC: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm/include/asm/dma-mapping.h   |    6 ++++++
>  arch/arm64/include/asm/dma-mapping.h |    5 +++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index c45b61a..bededbb 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -126,6 +126,12 @@ static inline int set_arch_dma_coherent_ops(struct device *dev)
>  	set_dma_ops(dev, &arm_coherent_dma_ops);
>  	return 0;
>  }
> +
> +static inline bool is_dma_coherent(struct device *dev)
> +{
> +    return (__generic_dma_ops(dev) == &arm_coherent_dma_ops);
> +}

Hmm, what about the IOMMU ops?

Will
