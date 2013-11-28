Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab3K1GyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 01:54:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:27512 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab3K1GyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 01:54:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,789,1378882800"; 
   d="scan'208";a="416359644"
Date: Thu, 28 Nov 2013 11:27:06 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jason Cooper <jason@lakedaemon.net>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dma: mv_xor: remove mv_desc_get_dest_addr()
Message-ID: <20131128055706.GM8834@intel.com>
References: <1385408365-8072-1-git-send-email-jason@lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385408365-8072-1-git-send-email-jason@lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Dan

On Mon, Nov 25, 2013 at 07:39:25PM +0000, Jason Cooper wrote:
> The following commit:
> 
>   54f8d501e842 dmaengine: remove DMA unmap from drivers
> 
> removed the last caller to mv_desc_get_dest_addr(), creating the
> warning:
> 
>   drivers/dma/mv_xor.c:57:12: warning: 'mv_desc_get_dest_addr' defined
>   but not used [-Wunused-function]
> 
> Remove it.
> 
> Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Acked-by: Vinod Koul <vinod.koul@intel.com>

This should go thru Dan's tree

> ---
>  drivers/dma/mv_xor.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
> index 7807f0ef4e20..23bcc9158cbc 100644
> --- a/drivers/dma/mv_xor.c
> +++ b/drivers/dma/mv_xor.c
> @@ -54,12 +54,6 @@ static void mv_desc_init(struct mv_xor_desc_slot *desc, unsigned long flags)
>  	hw_desc->desc_command = (1 << 31);
>  }
>  
> -static u32 mv_desc_get_dest_addr(struct mv_xor_desc_slot *desc)
> -{
> -	struct mv_xor_desc *hw_desc = desc->hw_desc;
> -	return hw_desc->phy_dest_addr;
> -}
> -
>  static void mv_desc_set_byte_count(struct mv_xor_desc_slot *desc,
>  				   u32 byte_count)
>  {
> -- 
> 1.8.4.4
> 

-- 
