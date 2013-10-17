Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3JQO2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:28:05 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50463 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755605Ab3JQO2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:28:03 -0400
Date: Thu, 17 Oct 2013 16:27:55 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: Re: [PATCH 01/28] dmaengine: use DMA_COMPLETE for dma completion
 status
Message-ID: <20131017142755.GA4477@breakpoint.cc>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
 <1381940926-25564-2-git-send-email-vinod.koul@intel.com>
 <Pine.LNX.4.64.1310162028340.22648@axis700.grange>
 <CAPcyv4hOZHmegDiPYmeVWzOUCasQaixzCzpLHs37i7RZznhGsA@mail.gmail.com>
 <20131017020745.GA14013@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017020745.GA14013@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 07:37:45AM +0530, Vinod Koul wrote:
> index 0bc7275..683c380 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -45,16 +45,17 @@ static inline int dma_submit_error(dma_cookie_t cookie)
>  
>  /**
>   * enum dma_status - DMA transaction status
> - * @DMA_SUCCESS: transaction completed successfully
> + * @DMA_COMPLETE: transaction completed
>   * @DMA_IN_PROGRESS: transaction not yet processed
>   * @DMA_PAUSED: transaction is paused
>   * @DMA_ERROR: transaction failed
>   */
>  enum dma_status {
> -	DMA_SUCCESS,
> +	DMA_COMPLETE,
>  	DMA_IN_PROGRESS,
>  	DMA_PAUSED,
>  	DMA_ERROR,
> +	DMA_SUCCESS,
>  };

There are some drivers which compare against == or != DMA_SUCCESS. Shouldn't this
become
  enum dma_status {
 -	DMA_SUCCESS,
 +	DMA_COMPLETE = 0, DMA_SUCCESS = 0,
  	DMA_IN_PROGRESS,
  	DMA_PAUSED,
  	DMA_ERROR,
  };

so nothing breaks during the transition?

Sebastian
