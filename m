Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3ATOTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 09:19:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:20526 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab3ATOTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 09:19:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,500,1355126400"; 
   d="scan'208";a="246174361"
Date: Sun, 20 Jan 2013 05:55:11 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Cong Ding <dinggnu@gmail.com>
Cc: Dan Williams <djbw@fb.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: remove unnecessary null pointer check in
 mmp_pdma.c
Message-ID: <20130120135511.GF23398@intel.com>
References: <1358209188-16350-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358209188-16350-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 01:19:48AM +0100, Cong Ding wrote:
> the pointer cfg is dereferenced in line 594, so it's no reason to check null
> again in line 620.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  drivers/dma/mmp_pdma.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
> index c6d98c0..81d7b89 100644
> --- a/drivers/dma/mmp_pdma.c
> +++ b/drivers/dma/mmp_pdma.c
> @@ -617,10 +617,8 @@ static int mmp_pdma_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
>  		else if (maxburst == 32)
>  			chan->dcmd |= DCMD_BURST32;
>  
> -		if (cfg) {
> -			chan->dir = cfg->direction;
> -			chan->drcmr = cfg->slave_id;
> -		}
> +		chan->dir = cfg->direction;
> +		chan->drcmr = cfg->slave_id;
>  		chan->dev_addr = addr;
>  		break;
>  	default:
Applied, Thanks

--
~Vinod
