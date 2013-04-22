Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3DVKH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:07:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:44861 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab3DVKHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:07:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,525,1363158000"; 
   d="scan'208";a="289687572"
Date: Mon, 22 Apr 2013 15:06:31 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 21/32] dmaengine: ste_dma40: Also report the number of
 logical channels
Message-ID: <20130422093631.GE24632@intel.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-22-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-22-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:12:03AM +0100, Lee Jones wrote:
> Now we know the total of physical and logical channels, we may as
> well report them within the information log.
> 
> Before:
> dma40 dma40.0: hardware revision: 3 @ 0x801c0000 with 8 physical channels
> 
> After:
> <as above ...> and 256 logical channels
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/dma/ste_dma40.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index 282dd59..805049c 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -3200,8 +3200,9 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
>  
>  	num_log_chans = num_phy_chans * D40_MAX_LOG_CHAN_PER_PHY;
>  
> -	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x with %d physical channels\n",
> -		 rev, res->start, num_phy_chans);
> +	dev_info(&pdev->dev, "hardware revision: %d @ 0x%x with "
> +		"%d physical channels and %d logical channels\n",
> +		rev, res->start, num_phy_chans, num_log_chans);
Splitting log messages across lines is bad idea and sacrifces readablity... also
wasnt splitting logging to multiple lines emit checkpatch warn

--
~Vinod
>  
>  	base = kzalloc(ALIGN(sizeof(struct d40_base), 4) + (num_phy_chans +
>  	num_log_chans + ARRAY_SIZE(dma40_memcpy_channels)) * -- 1.7.10.4
> 
