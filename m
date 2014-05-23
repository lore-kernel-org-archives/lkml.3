Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaEWDKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 23:10:34 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:46525 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaEWDKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 23:10:33 -0400
MIME-Version: 1.0
In-Reply-To: <1400790060-10977-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1400790060-10977-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Fri, 23 May 2014 08:40:32 +0530
Message-ID: <CAHbNUh0cdV3-o+gQaKF3xKH77SRQLJkLGJTr660Bze8kQNDUfw@mail.gmail.com>
Subject: Re: [PATCH] sound: soc: samsung: dma.c: Fix to remove null pointer
 checks that could never happen
From: Tushar Behera <tushar.behera@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 2014 01:51, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Removal of null pointer checks that could never happen
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---

The subject should probably be (at least should start with "ASoC: samsung:")
"ASoC: samsung: Remove redundant null pointer check from dma.c"

With that change,
Reviewed-by: Tushar Behera <tushar.behera@linaro.org>

>  sound/soc/samsung/dma.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
> index dc09b71..0f17ae0 100644
> --- a/sound/soc/samsung/dma.c
> +++ b/sound/soc/samsung/dma.c
> @@ -124,8 +124,7 @@ static void audio_buffdone(void *data)
>                 if (prtd->dma_pos >= prtd->dma_end)
>                         prtd->dma_pos = prtd->dma_start;
>
> -               if (substream)
> -                       snd_pcm_period_elapsed(substream);
> +               snd_pcm_period_elapsed(substream);
>
>                 spin_lock(&prtd->lock);
>                 if (!samsung_dma_has_circular()) {
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Tushar Behera
