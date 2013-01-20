Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab3ATOU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 09:20:27 -0500
Received: from mga14.intel.com ([143.182.124.37]:55517 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab3ATOU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 09:20:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,500,1355126400"; 
   d="scan'208";a="246174470"
Date: Sun, 20 Jan 2013 05:55:41 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Cong Ding <dinggnu@gmail.com>
Cc: Dan Williams <djbw@fb.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: sh/shdma-base.c: remove unnecessary null pointer
 check
Message-ID: <20130120135541.GG23398@intel.com>
References: <1358209435-16429-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358209435-16429-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 01:23:48AM +0100, Cong Ding wrote:
> the variable chan is dereferenced in line 635, so it is no reason to check
> null again in line 641.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  drivers/dma/sh/shdma-base.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
> index f4cd946..4acb85a 100644
> --- a/drivers/dma/sh/shdma-base.c
> +++ b/drivers/dma/sh/shdma-base.c
> @@ -638,9 +638,6 @@ static int shdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>  	unsigned long flags;
>  	int ret;
>  
> -	if (!chan)
> -		return -EINVAL;
> -
>  	switch (cmd) {
>  	case DMA_TERMINATE_ALL:
>  		spin_lock_irqsave(&schan->chan_lock, flags);
Applied, Thanks

--
~Vinod
