Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbbAMPrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:47:32 -0500
Received: from mga03.intel.com ([134.134.136.65]:25151 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbbAMPqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:46:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,750,1413270000"; 
   d="scan'208";a="650463771"
Date: Tue, 13 Jan 2015 21:15:32 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] dmaengine: k3: Fix duplicated function name and
 allmodconfig build
Message-ID: <20150113154532.GG3085@intel.com>
References: <1419858090-7682-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1419858090-7682-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 02:01:30PM +0100, Krzysztof Kozlowski wrote:
> While splitting device control in db08425ebd51 ("dmaengine: k3:
> Split device_control") new function with the same 'k3_dma_resume' name
> was added, leading to build error:
> 
> drivers/dma/k3dma.c:823:12: error: conflicting types for ‘k3_dma_resume’
> drivers/dma/k3dma.c:625:12: note: previous definition of ‘k3_dma_resume’ was here
> 
Applied, thanks

-- 
~Vinod

> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/dma/k3dma.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
> index 49be7f687c4c..a4ff7e9e68be 100644
> --- a/drivers/dma/k3dma.c
> +++ b/drivers/dma/k3dma.c
> @@ -601,7 +601,7 @@ static int k3_dma_terminate_all(struct dma_chan *chan)
>  	return 0;
>  }
>  
> -static int k3_dma_pause(struct dma_chan *chan)
> +static int k3_dma_transfer_pause(struct dma_chan *chan)
>  {
>  	struct k3_dma_chan *c = to_k3_chan(chan);
>  	struct k3_dma_dev *d = to_k3_dma(chan->device);
> @@ -622,7 +622,7 @@ static int k3_dma_pause(struct dma_chan *chan)
>  	return 0;
>  }
>  
> -static int k3_dma_resume(struct dma_chan *chan)
> +static int k3_dma_transfer_resume(struct dma_chan *chan)
>  {
>  	struct k3_dma_chan *c = to_k3_chan(chan);
>  	struct k3_dma_dev *d = to_k3_dma(chan->device);
> @@ -735,8 +735,8 @@ static int k3_dma_probe(struct platform_device *op)
>  	d->slave.device_prep_slave_sg = k3_dma_prep_slave_sg;
>  	d->slave.device_issue_pending = k3_dma_issue_pending;
>  	d->slave.device_config = k3_dma_config;
> -	d->slave.device_pause = k3_dma_pause;
> -	d->slave.device_resume = k3_dma_resume;
> +	d->slave.device_pause = k3_dma_transfer_pause;
> +	d->slave.device_resume = k3_dma_transfer_resume;
>  	d->slave.device_terminate_all = k3_dma_terminate_all;
>  	d->slave.copy_align = DMA_ALIGN;
>  
> -- 
> 1.9.1
> 

-- 
