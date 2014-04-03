Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaDCP5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:57:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58057 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaDCP5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:57:34 -0400
Message-ID: <1396540644.20145.38.camel@fourier>
Subject: Re: [PATCH 3.8 57/86] ASoC: pcm: free path list before exiting from
 error conditions
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, kernel-team@lists.ubuntu.com,
        Patrick Lai <plai@codeaurora.org>, Mark Brown <broonie@linaro.org>,
        Ben Hutchings <ben@decadent.org.uk>
Date: Thu, 03 Apr 2014 08:57:24 -0700
In-Reply-To: <1396368519-12728-58-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
	 <1396368519-12728-58-git-send-email-kamal@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 09:08 -0700, Kamal Mostafa wrote:
> 3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Patrick Lai <plai@codeaurora.org>
> 
> commit e4ad1accb28d0ed8cea6f12395d58686ad344ca7 upstream.


I am dropping this patch from 3.8-stable, per Ben Hutchings' analysis in
stable@ thread "Re: [PATCH 3.13 110/149] ASoC: pcm: free path list
before exiting from error conditions".

Thanks, Ben!

 -Kamal


> dpcm_path_get() allocates dynamic memory to hold path list.
> Corresponding dpcm_path_put() must be called to free the memory.
> dpcm_path_put() is not called under several error conditions.
> This leads to memory leak.
> 
> Signed-off-by: Patrick Lai <plai@codeaurora.org>
> Signed-off-by: Mark Brown <broonie@linaro.org>
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---
>  sound/soc/soc-pcm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
> index cf191e6..2d0dbd2 100644
> --- a/sound/soc/soc-pcm.c
> +++ b/sound/soc/soc-pcm.c
> @@ -1866,6 +1866,7 @@ int soc_dpcm_runtime_update(struct snd_soc_dapm_widget *widget)
>  
>  		paths = dpcm_path_get(fe, SNDRV_PCM_STREAM_PLAYBACK, &list);
>  		if (paths < 0) {
> +			dpcm_path_put(&list);
>  			dev_warn(fe->dev, "ASoC: %s no valid %s path\n",
>  					fe->dai_link->name,  "playback");
>  			mutex_unlock(&card->mutex);
> @@ -1895,6 +1896,7 @@ capture:
>  
>  		paths = dpcm_path_get(fe, SNDRV_PCM_STREAM_CAPTURE, &list);
>  		if (paths < 0) {
> +			dpcm_path_put(&list);
>  			dev_warn(fe->dev, "ASoC: %s no valid %s path\n",
>  					fe->dai_link->name,  "capture");
>  			mutex_unlock(&card->mutex);
> @@ -1959,6 +1961,7 @@ static int dpcm_fe_dai_open(struct snd_pcm_substream *fe_substream)
>  	fe->dpcm[stream].runtime = fe_substream->runtime;
>  
>  	if (dpcm_path_get(fe, stream, &list) <= 0) {
> +		dpcm_path_put(&list);
>  		dev_dbg(fe->dev, "ASoC: %s no valid %s route\n",
>  			fe->dai_link->name, stream ? "capture" : "playback");
>  	}


