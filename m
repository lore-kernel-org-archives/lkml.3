Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3JWOjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 10:39:13 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46404 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3JWOjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 10:39:11 -0400
Message-ID: <5267DF8D.70800@linaro.org>
Date: Wed, 23 Oct 2013 15:39:09 +0100
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konrad.wilk@oracle.com, Ian.Campbell@citrix.com, ben-linux@fluff.org,
        kgene.kim@samsung.com, sbkim73@samsung.com,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v8 14/19] ASoC: Samsung: Rename dma_ops by samsung_dma_ops
References: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com> <1382031814-8782-14-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1382031814-8782-14-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Add samsung sounds maintainers)

On 10/17/2013 06:43 PM, Stefano Stabellini wrote:
> From: Julien Grall <julien.grall@linaro.org>
>
> The commit "arm: introduce a global dma_ops pointer" introduce compilation issue
> when CONFIG_SND_SOC_SAMSUNG is enabled.
>
> sound/soc/samsung/dma.c:345:27: error: conflicting types for 'dma_ops'
> /local/home/julien/works/arndale/linux/arch/arm/include/asm/dma-mapping.h:16:28:
> note: previous declaration of 'dma_ops' was here
>
> Signed-off-by: Julien Grall <julien.grall@linaro.org>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>   sound/soc/samsung/dma.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
> index 21b7926..827c0d8 100644
> --- a/sound/soc/samsung/dma.c
> +++ b/sound/soc/samsung/dma.c
> @@ -341,7 +341,7 @@ static int dma_mmap(struct snd_pcm_substream *substream,
>   				     runtime->dma_bytes);
>   }
>
> -static struct snd_pcm_ops dma_ops = {
> +static struct snd_pcm_ops samsung_dma_ops = {
>   	.open		= dma_open,
>   	.close		= dma_close,
>   	.ioctl		= snd_pcm_lib_ioctl,
> @@ -428,7 +428,7 @@ out:
>   }
>
>   static struct snd_soc_platform_driver samsung_asoc_platform = {
> -	.ops		= &dma_ops,
> +	.ops		= &samsung_dma_ops,
>   	.pcm_new	= dma_new,
>   	.pcm_free	= dma_free_dma_buffers,
>   };
>

-- 
Julien Grall
