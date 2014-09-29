Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbaI2Toj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:44:39 -0400
Received: from smtp-out-075.synserver.de ([212.40.185.75]:1114 "EHLO
	smtp-out-073.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754490AbaI2Toi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:44:38 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 15705
Message-ID: <5429B6B0.3050709@metafoo.de>
Date: Mon, 29 Sep 2014 21:44:48 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.0
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        linux-kernel@vger.kernel.org
CC: alsa-devel@alsa-project.org, lgirdwood@gmail.com, broonie@kernel.org
Subject: Re: [PATCH v2 3/3] ASoC: ssm2602: add support for 11.025kHz and 22.5kHz
 sample rates
References: <1412019697-19475-1-git-send-email-stefan.kristiansson@saunalahti.fi>
In-Reply-To: <1412019697-19475-1-git-send-email-stefan.kristiansson@saunalahti.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 09:41 PM, Stefan Kristiansson wrote:
> This adds the necessary values to the constraint list and
> register values to the coefficient table in order to
> configure the device for 11.025kHz and 22.5kHz sample rates.
>
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
> Changes in v2:
>   - Keep SSM2602_RATES sorted.
> ---
>   sound/soc/codecs/ssm2602.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/sound/soc/codecs/ssm2602.c b/sound/soc/codecs/ssm2602.c
> index 4021cd4..7c41848 100644
> --- a/sound/soc/codecs/ssm2602.c
> +++ b/sound/soc/codecs/ssm2602.c
> @@ -192,7 +192,7 @@ static const struct snd_pcm_hw_constraint_list ssm2602_constraints_12288000 = {
>   };
>
>   static const unsigned int ssm2602_rates_11289600[] = {
> -	8000, 44100, 88200,
> +	8000, 11025, 22050, 44100, 88200,
>   };
>
>   static const struct snd_pcm_hw_constraint_list ssm2602_constraints_11289600 = {
> @@ -237,6 +237,16 @@ static const struct ssm2602_coeff ssm2602_coeff_table[] = {
>   	{18432000, 96000, SSM2602_COEFF_SRATE(0x7, 0x1, 0x0)},
>   	{12000000, 96000, SSM2602_COEFF_SRATE(0x7, 0x0, 0x1)},
>
> +	/* 11.025k */
> +	{11289600, 11025, SSM2602_COEFF_SRATE(0xc, 0x0, 0x0)},
> +	{16934400, 11025, SSM2602_COEFF_SRATE(0xc, 0x1, 0x0)},
> +	{12000000, 11025, SSM2602_COEFF_SRATE(0xc, 0x1, 0x1)},
> +
> +	/* 22.05k */
> +	{11289600, 22050, SSM2602_COEFF_SRATE(0xd, 0x0, 0x0)},
> +	{16934400, 22050, SSM2602_COEFF_SRATE(0xd, 0x1, 0x0)},
> +	{12000000, 22050, SSM2602_COEFF_SRATE(0xd, 0x1, 0x1)},
> +
>   	/* 44.1k */
>   	{11289600, 44100, SSM2602_COEFF_SRATE(0x8, 0x0, 0x0)},
>   	{16934400, 44100, SSM2602_COEFF_SRATE(0x8, 0x1, 0x0)},
> @@ -467,7 +477,8 @@ static int ssm2602_set_bias_level(struct snd_soc_codec *codec,
>   	return 0;
>   }
>
> -#define SSM2602_RATES (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_16000 |\
> +#define SSM2602_RATES (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_11025 |\
> +		SNDRV_PCM_RATE_16000 | SNDRV_PCM_RATE_22050 |\
>   		SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_44100 |\
>   		SNDRV_PCM_RATE_48000 | SNDRV_PCM_RATE_88200 |\
>   		SNDRV_PCM_RATE_96000)
>

