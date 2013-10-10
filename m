Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3JJJpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 05:45:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52899 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193Ab3JJJpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 05:45:08 -0400
Date: Thu, 10 Oct 2013 10:44:39 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v8 02/17] arm64: define DMA_ERROR_CODE
Message-ID: <20131010094439.GE3817@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.02.1310092109190.26077@kaball.uk.xensource.com>
 <1381351710-1876-2-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381351710-1876-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 09:48:15PM +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> CC: will.deacon@arm.com
> ---
>  arch/arm64/include/asm/dma-mapping.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
> index 8d18100..c2cb8a0 100644
> --- a/arch/arm64/include/asm/dma-mapping.h
> +++ b/arch/arm64/include/asm/dma-mapping.h
> @@ -25,6 +25,7 @@
>  
>  #define ARCH_HAS_DMA_GET_REQUIRED_MASK
>  
> +#define DMA_ERROR_CODE	(~0)

Hmm, is this guaranteed to be large enough for a dma_addr_t? Other 64-bit
architectures using a non-zero error code cast to dma_addr_t before the
negation.

Will
