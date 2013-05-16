Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3EPFxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 01:53:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:32313 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333Ab3EPFxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 01:53:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="314435673"
Date: Thu, 16 May 2013 10:48:20 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au, arnd@arndb.de,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 35/39] dmaengine: ste_dma40_ll: Replace meaningless
 register set with comment
Message-ID: <20130516051820.GH27639@intel.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-36-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368611522-9984-36-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 10:51:58AM +0100, Lee Jones wrote:
> Unsure of the author's intentions, rather than just removing the nop,
> we're replacing it with a comment containing the possible intention
> of the statement OR:ing with 0.
Would be worthwhile to check w/ Linus W on this (or check whom to blame)

--
~Vinod
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/dma/ste_dma40_ll.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
> index a035dfe..27b818d 100644
> --- a/drivers/dma/ste_dma40_ll.c
> +++ b/drivers/dma/ste_dma40_ll.c
> @@ -182,8 +182,10 @@ static int d40_phy_fill_lli(struct d40_phy_lli *lli,
>  	else
>  		lli->reg_cfg &= ~BIT(D40_SREG_CFG_TIM_POS);
>  
> -	/* Post link */
> -	lli->reg_lnk |= 0 << D40_SREG_LNK_PHY_PRE_POS;
> +	/*
> +	 * Post link - D40_SREG_LNK_PHY_PRE_POS = 0
> +	 * Relink happens after transfer completion.
> +	 */
>  
>  	return 0;
>  }
> -- 
> 1.7.10.4
> 
