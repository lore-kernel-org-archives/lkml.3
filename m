Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaHSLLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:11:18 -0400
Received: from 8bytes.org ([81.169.241.247]:43865 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaHSLLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:11:17 -0400
Date: Tue, 19 Aug 2014 13:11:15 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] iommu/vt-d: Add new macros for invalidation event
Message-ID: <20140819111115.GB26492@8bytes.org>
References: <1408067751-30754-1-git-send-email-zhen-hual@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408067751-30754-1-git-send-email-zhen-hual@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 09:55:51AM +0800, Li, Zhen-Hua wrote:
> According to intel's spec
>         Intel® Virtualization Technology for Directed I/O,
>         Revision: 1.3 , February 2011,
>         Chaper 10.4.25 to 10.4.28
> 
> There are four registers
> 
>         IECTL_REG   0xa0    Invalidation event control register
>         IEDATA_REG  0xa4    Invalidation event data register
>         IEADDR_REG  0xa8    Invalidation event address register
>         IEUADDR_REG 0xac    Invalidation event upper address register
> 
> Through they are not used in kernel in the latest version, the defination
>  should be added to kernel as well as other registers.
> 
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> ---
>  include/linux/intel-iommu.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index a65208a..15fafd5 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -56,6 +56,10 @@
>  #define DMAR_IQ_SHIFT	4	/* Invalidation queue head/tail shift */
>  #define DMAR_IQA_REG	0x90	/* Invalidation queue addr register */
>  #define DMAR_ICS_REG	0x9c	/* Invalidation complete status register */
> +#define DMAR_IECTL_REG	0xa0	/* Invalidation event control register */
> +#define DMAR_IEDATA_REG	0xa4	/* Invalidation event data register */
> +#define DMAR_IEADDR_REG	0xa8	/* Invalidation event address register */
> +#define DMAR_IEUADDR_REG 0xac	/* Invalidation event upper address register */
>  #define DMAR_IRTA_REG	0xb8    /* Interrupt remapping table addr register */
>  
>  #define OFFSET_STRIDE		(9)

There is no point in adding register defines that are not used anywhere.


	Joerg

