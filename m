Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123Ab3HSQ41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:56:27 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:56588 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751080Ab3HSQ40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:56:26 -0400
Date: Mon, 19 Aug 2013 17:55:49 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v4 05/10] arm64: do not initialize arm64_swiotlb if
 dma_ops is already set
Message-ID: <20130819165549.GD19712@arm.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
 <1376565054-24153-5-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376565054-24153-5-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 12:10:49PM +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: catalin.marinas@arm.com
> CC: will.deacon@arm.com
> ---
>  arch/arm64/mm/dma-mapping.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
> index 4bd7579..a006e84 100644
> --- a/arch/arm64/mm/dma-mapping.c
> +++ b/arch/arm64/mm/dma-mapping.c
> @@ -63,6 +63,8 @@ static struct dma_map_ops arm64_swiotlb_dma_ops = {
>  
>  void __init arm64_swiotlb_init(void)
>  {
> +	if (dma_ops != NULL)
> +		return;
>  	dma_ops = &arm64_swiotlb_dma_ops;
>  	swiotlb_init(1);

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
