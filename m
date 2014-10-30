Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbaJ3KHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:07:36 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:49871 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135AbaJ3KHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:07:35 -0400
Message-ID: <54520DE4.9090008@imgtec.com>
Date: Thu, 30 Oct 2014 10:07:32 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>, <linux-mips@linux-mips.org>,
        <nbd@openwrt.org>, <yanh@lemote.com>, <linux-kernel@vger.kernel.org>,
        <ralf@linux-mips.org>, <alex.smith@imgtec.com>, <taohl@lemote.com>,
        <chenhc@lemote.com>, <blogic@openwrt.org>
Subject: Re: [PATCH] MIPS: DMA: fix coherent alloc in non-coherent systems
References: <20141030014753.13189.48344.stgit@linux-yegoshin>
In-Reply-To: <20141030014753.13189.48344.stgit@linux-yegoshin>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leonid,

On 30/10/14 01:48, Leonid Yegoshin wrote:
> A default dma_alloc_coherent() fails to alloc a coherent memory on non-coherent
> systems in case of device->coherent_dma_mask covering the whole memory space.
> 
> In case of non-coherent systems the coherent memory on MIPS is restricted by
> size of un-cachable segment and should be located in ZONE_DMA.

Has this pretty much always been broken?

> @@ -81,6 +81,11 @@ static gfp_t massage_gfp_flags(const struct device *dev, gfp_t gfp)
>  		dma_flag = __GFP_DMA;
>  	else
>  #endif
> +#ifdef CONFIG_ZONE_DMA
> +	     if (coherent && !plat_device_is_coherent(dev))

Broken indentation. Please fix to use tabs.

> +			dma_flag = __GFP_DMA;
> +	else
> +#endif
>  #if defined(CONFIG_ZONE_DMA32) && defined(CONFIG_ZONE_DMA)
>  	     if (dev->coherent_dma_mask < DMA_BIT_MASK(32))
>  			dma_flag = __GFP_DMA;

Other than that, this patch looks okay to me (but those with more
experience with MIPS DMA than me may know better).

Reviewed-by: James Hogan <james.hogan@imgtec.com>

Thanks
James
