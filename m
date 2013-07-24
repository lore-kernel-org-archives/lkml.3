Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab3GXIn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:43:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61046 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3GXInv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:43:51 -0400
Date: Wed, 24 Jul 2013 10:43:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
cc: Olof Johansson <olof@lixom.net>, Simon Horman <simon@horms.net>,
        Linux-SH <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] shdma: fixup sh_dmae_get_partial() calculation
 error
In-Reply-To: <87bo5sv63u.wl%kuninori.morimoto.gx@renesas.com>
Message-ID: <Pine.LNX.4.64.1307241042360.30777@axis700.grange>
References: <1373422152-29976-1-git-send-email-horms+renesas@verge.net.au>
 <20130716012041.GA942@verge.net.au> <20130723023907.GC14983@quad.lixom.net>
 <20130723041220.GA22253@verge.net.au> <87zjtddgtg.wl%kuninori.morimoto.gx@renesas.com>
 <20130724034009.GA18355@verge.net.au> <87d2q8v6fs.wl%kuninori.morimoto.gx@renesas.com>
 <87bo5sv63u.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:IKbOzWR/mxXANv8gMzCFvQ6SzmGc3JlYEex8oUECoPi
 TMZNUymsS6O6L0JiIqQoTfgst8AkPBmNt9IdBZUey95fVAn4In
 Jed+i0iNTbKyO2sXYf8aGuJ9j1dtt/dHd11MiS1YEJMJztIxJ3
 oWblEFH3Zii8Ozy3adu33m4/eS5QWE4zpYvwLnjG7Z8KugymOV
 +itay6yM9vThtsLzqkm1oYhiYEYYaKuhxyHeZB9iK4zliBoEdc
 +PDeebqRZIXmOWN77WzafFPbXVNnSCeeutg47ygeUVrrQ/IOat
 hwEtMhDsvbobeDPzgqALi+CjOusZ6sSNW0On2rOQBHiwJOVJZf
 jJm4anAdLMp6RL45ctEsVx23ZRqRf+DgLLoaK8Ctc+/aPJXoXA
 krZ9ktTd8aJzg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morimoto-san

On Tue, 23 Jul 2013, Kuninori Morimoto wrote:

> sh_desc->hw.tcr is controlling real data size,
> and, register TCR is controlling data transfer count
> which was xmit_shifted value of hw.tcr.
> Current sh_dmae_get_partial() is calculating in different unit.
> This patch fixes it.
> 
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Looks right to me

Acked-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>

Thanks
Guennadi

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

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
