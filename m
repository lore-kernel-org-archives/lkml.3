Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254Ab3E2CTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:19:13 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:43383
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab3E2CTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:19:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 29 May 2013 10:19:36 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 10/12] ipu_idmac: re-use dma_cookie_status()
Message-ID: <20130529021934.GB370@S2101-09.ap.freescale.net>
References: <1369656882-25241-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1369656882-25241-11-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1369656882-25241-11-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 03:14:40PM +0300, Andy Shevchenko wrote:
> It's better to use generic dma_cookie_status() that allows user to get standard
> possible return codes independently of the DMAC driver in charge.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/dma/ipu/ipu_idmac.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
> index d39c2cd..608d4a2 100644
> --- a/drivers/dma/ipu/ipu_idmac.c
> +++ b/drivers/dma/ipu/ipu_idmac.c
> @@ -1593,10 +1593,7 @@ static void idmac_free_chan_resources(struct dma_chan *chan)
>  static enum dma_status idmac_tx_status(struct dma_chan *chan,
>  		       dma_cookie_t cookie, struct dma_tx_state *txstate)
>  {
> -	dma_set_tx_state(txstate, chan->completed_cookie, chan->cookie, 0);
> -	if (cookie != chan->cookie)
> -		return DMA_ERROR;
> -	return DMA_SUCCESS;
> +	return dma_cookie_status(chan, cookie, txstate);
>  }
>  
>  static int __init ipu_idmac_init(struct ipu *ipu)
> -- 
> 1.8.2.rc0.22.gb3600c3
> 

