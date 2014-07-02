Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaGBLqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:46:55 -0400
Received: from smtp-out-155.synserver.de ([212.40.185.155]:1051 "EHLO
	smtp-out-155.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaGBLqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:46:54 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 28478
Message-ID: <53B3F126.5060709@metafoo.de>
Date: Wed, 02 Jul 2014 13:46:46 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, vinod.koul@intel.com,
        dan.j.williams@intel.com, tiwai@suse.de,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        joelf@ti.com, nsekhar@ti.com
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 3/4] ALSA: pcm_dmaengine: Use the available wrapper to
 get physical width
References: <1404300570-14082-1-git-send-email-peter.ujfalusi@ti.com> <1404300570-14082-4-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1404300570-14082-4-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 01:29 PM, Peter Ujfalusi wrote:
> params_physical_width() is available via pcm_params.h
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.

> ---
>   sound/core/pcm_dmaengine.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/sound/core/pcm_dmaengine.c b/sound/core/pcm_dmaengine.c
> index 76cbb9ec953a..d5611ec80381 100644
> --- a/sound/core/pcm_dmaengine.c
> +++ b/sound/core/pcm_dmaengine.c
> @@ -65,7 +65,7 @@ int snd_hwparams_to_dma_slave_config(const struct snd_pcm_substream *substream,
>   	enum dma_slave_buswidth buswidth;
>   	int bits;
>
> -	bits = snd_pcm_format_physical_width(params_format(params));
> +	bits = params_physical_width(params);
>   	if (bits < 8 || bits > 64)
>   		return -EINVAL;
>   	else if (bits == 8)
>

