Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab3FQOFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:05:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:51408 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab3FQOFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:05:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,881,1363158000"; 
   d="scan'208";a="318252021"
Date: Mon, 17 Jun 2013 18:56:07 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Xiang Wang <wangxfdu@gmail.com>
Cc: Dan Williams <djbw@fb.com>, linux-kernel@vger.kernel.org,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Subject: Re: [PATCH 1/2] dma: mmp_pdma: add protect when alloc/free phy
 channels
Message-ID: <20130617132607.GA10671@intel.com>
References: <1370246529-17155-1-git-send-email-wangxfdu@gmail.com>
 <1370246529-17155-2-git-send-email-wangxfdu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370246529-17155-2-git-send-email-wangxfdu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 04:02:08PM +0800, Xiang Wang wrote:
> From: Xiang Wang <wangx@marvell.com>
> 
> In mmp pdma, phy channels are allocated/freed dynamically
> and frequently. But no proper protection is added.
> Conflict will happen when multi-users are requesting phy
> channels at the same time. Use spinlock to protect.
> 
> Signed-off-by: Xiang Wang <wangx@marvell.com>
> ---
>  drivers/dma/mmp_pdma.c |   41 +++++++++++++++++++++++++----------------
>  1 files changed, 25 insertions(+), 16 deletions(-)
> 

> +static void free_phy(struct mmp_pdma_chan *pchan)
pls namespace this
> +{
> +	struct mmp_pdma_device *pdev = to_mmp_pdma_dev(pchan->chan.device);
> +	unsigned long flags;
empty line pls

> +	if (!pchan->phy)
> +		return;
> +
> +	spin_lock_irqsave(&pdev->phy_lock, flags);
> +	pchan->phy->vchan = NULL;
> +	pchan->phy = NULL;
> +	spin_unlock_irqrestore(&pdev->phy_lock, flags);
> +}
> +
rest looks okay

--
~Vinod
