Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab3G3IuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:50:11 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:37656 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab3G3IuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:50:01 -0400
Date: Tue, 30 Jul 2013 17:49:58 +0900
From: Simon Horman <horms@verge.net.au>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Olof Johansson <olof@lixom.net>, Linux-SH <linux-sh@vger.kernel.org>,
        Guennadi <g.liakhovetski@gmx.de>, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH resend] shdma: fixup sh_dmae_get_partial() calculation
 error
Message-ID: <20130730084957.GA17209@verge.net.au>
References: <1373422152-29976-1-git-send-email-horms+renesas@verge.net.au>
 <20130716012041.GA942@verge.net.au>
 <20130723023907.GC14983@quad.lixom.net>
 <20130723041220.GA22253@verge.net.au>
 <87zjtddgtg.wl%kuninori.morimoto.gx@renesas.com>
 <20130724034009.GA18355@verge.net.au>
 <87d2q8v6fs.wl%kuninori.morimoto.gx@renesas.com>
 <87bo5sv63u.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo5sv63u.wl%kuninori.morimoto.gx@renesas.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Cc Vinod ]

On Tue, Jul 23, 2013 at 11:12:41PM -0700, Kuninori Morimoto wrote:
> sh_desc->hw.tcr is controlling real data size,
> and, register TCR is controlling data transfer count
> which was xmit_shifted value of hw.tcr.
> Current sh_dmae_get_partial() is calculating in different unit.
> This patch fixes it.
> 
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Can I confirm that this was a regression introduced by
4f46f8ac80416b0e8fd3aba6a0d842205fb29140                   
("dmaengine: shdma: restore partial transfer calculation") ?

> ---
> >> Guennadi
> 
> Could you please check this patch, and give it your Acked-by ?
> 
>  drivers/dma/sh/shdma.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
> index b70709b..d670b8b 100644
> --- a/drivers/dma/sh/shdma.c
> +++ b/drivers/dma/sh/shdma.c
> @@ -388,8 +388,8 @@ static size_t sh_dmae_get_partial(struct shdma_chan *schan,
>  						    shdma_chan);
>  	struct sh_dmae_desc *sh_desc = container_of(sdesc,
>  					struct sh_dmae_desc, shdma_desc);
> -	return (sh_desc->hw.tcr - sh_dmae_readl(sh_chan, TCR)) <<
> -		sh_chan->xmit_shift;
> +	return sh_desc->hw.tcr -
> +		(sh_dmae_readl(sh_chan, TCR) << sh_chan->xmit_shift);
>  }
>  
>  /* Called from error IRQ or NMI */
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
