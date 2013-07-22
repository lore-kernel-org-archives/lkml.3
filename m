Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab3GVKBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:01:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:44681 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910Ab3GVKBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:01:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,718,1367996400"; 
   d="scan'208";a="369046260"
Date: Mon, 22 Jul 2013 14:52:36 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dan Williams <djbw@fb.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH resend] dma: pl330: Fix cyclic transfers
Message-ID: <20130722092236.GB18642@intel.com>
References: <1373984003-21778-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373984003-21778-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 04:13:23PM +0200, Lars-Peter Clausen wrote:
> Allocate a descriptor for each period of a cyclic transfer, not just the first.
> Also since the callback needs to be called for each finished period make sure to
> initialize the callback and callback_param fields of each descriptor in a cyclic
> transfer.

 
>  	switch (direction) {
>  	case DMA_MEM_TO_DEV:
> -		desc->rqcfg.src_inc = 1;
> -		desc->rqcfg.dst_inc = 0;
> -		desc->req.rqtype = MEMTODEV;
> -		src = dma_addr;
> -		dst = pch->fifo_addr;
> -		break;
>  	case DMA_DEV_TO_MEM:
> -		desc->rqcfg.src_inc = 0;
> -		desc->rqcfg.dst_inc = 1;
> -		desc->req.rqtype = DEVTOMEM;
> -		src = pch->fifo_addr;
> -		dst = dma_addr;
>  		break;
>  	default:
>  		dev_err(pch->dmac->pif.dev, "%s:%d Invalid dma direction\n",
shouldnt the whole switch be removed and for error check you should use
is_slave_direction()

~Vinod
