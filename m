Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab3KFL5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:57:44 -0500
Received: from smtp-out-091.synserver.de ([212.40.185.91]:1628 "EHLO
	smtp-out-080.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756235Ab3KFL5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:57:43 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 20247
Message-ID: <527A2E37.2040100@metafoo.de>
Date: Wed, 06 Nov 2013 12:55:35 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, Mark Brown <broonie@kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH 08/13] ASoC: generic-dmaengine-pcm: Clear
 slave_config memory
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org> <1383732985-18928-9-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1383732985-18928-9-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 11:16 AM, Lee Jones wrote:
> We currently assume that the DMA Slave Config will be fully populated
> by the platform, however some DMA Engines make decisions based on zero
> (default) flags such as DMA_SLAVE_BUSWIDTH_UNDEFINED and as this is a
> static declaration we need to memset it to clear the data area.
> 
> Cc: alsa-devel@alsa-project.org
> Cc: Mark Brown <broonie@kernel.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.

> ---
>  sound/soc/soc-generic-dmaengine-pcm.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
> index ee07903..6ad4c7a 100644
> --- a/sound/soc/soc-generic-dmaengine-pcm.c
> +++ b/sound/soc/soc-generic-dmaengine-pcm.c
> @@ -90,6 +90,8 @@ static int dmaengine_pcm_hw_params(struct snd_pcm_substream *substream,
>  	struct dma_slave_config slave_config;
>  	int ret;
>  
> +	memset(&slave_config, 0, sizeof(slave_config));
> +
>  	if (!pcm->config)
>  		prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config;
>  	else
> 

