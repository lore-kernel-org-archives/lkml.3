Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3LQIL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:11:28 -0500
Received: from smtp-out-177.synserver.de ([212.40.185.177]:1054 "EHLO
	smtp-out-044.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750816Ab3LQIL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:11:27 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 18843
Message-ID: <52AFF951.9020201@metafoo.de>
Date: Tue, 17 Dec 2013 08:12:17 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: dmaengine: Add config parameter NULL
 check.
References: <1387264600-14225-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1387264600-14225-1-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 08:16 AM, Xiubo Li wrote:
> Because the "ASoC: dmaengine-pcm: Provide default config" has provided
> us one defualt config of DMA. When using this, the config parameter of
> devm_snd_dmaengine_pcm_register() will be NULL, so here we need to have
> a check before using it.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.

> ---
>  sound/soc/soc-generic-dmaengine-pcm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
> index 7483922..2a6c569 100644
> --- a/sound/soc/soc-generic-dmaengine-pcm.c
> +++ b/sound/soc/soc-generic-dmaengine-pcm.c
> @@ -299,7 +299,7 @@ static int dmaengine_pcm_request_chan_of(struct dmaengine_pcm *pcm,
>  	    !dev->of_node)
>  		return 0;
>  
> -	if (config->dma_dev) {
> +	if (config && config->dma_dev) {
>  		/*
>  		 * If this warning is seen, it probably means that your Linux
>  		 * device structure does not match your HW device structure.
> @@ -317,7 +317,7 @@ static int dmaengine_pcm_request_chan_of(struct dmaengine_pcm *pcm,
>  			name = "rx-tx";
>  		else
>  			name = dmaengine_pcm_dma_channel_names[i];
> -		if (config->chan_names[i])
> +		if (config && config->chan_names[i])
>  			name = config->chan_names[i];
>  		chan = dma_request_slave_channel_reason(dev, name);
>  		if (IS_ERR(chan)) {
> 

