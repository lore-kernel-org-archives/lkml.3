Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3EHIWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 04:22:13 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:60399 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3EHIWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 04:22:11 -0400
Date: Wed, 8 May 2013 09:22:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 6/6] ASoC: ux500: Use the first two AD slots for capture
Message-ID: <20130508082205.GK3102@gmail.com>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-7-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367997261-32048-7-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 May 2013, Fabio Baltieri wrote:

> Set AD_OUT1 and AD_OUT2, corresponding to LINL and LINR pins, as the
> default input slots for the capture interfaces.
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>  sound/soc/codecs/ab8500-codec.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
> index 7c026d4..9dafd52 100644
> --- a/sound/soc/codecs/ab8500-codec.c
> +++ b/sound/soc/codecs/ab8500-codec.c
> @@ -2334,17 +2334,18 @@ static int ab8500_codec_set_dai_tdm_slot(struct snd_soc_dai *dai,
>  	case 0:
>  		break;
>  	case 1:
> -		/* AD_OUT3 -> slot 0 & 1 */
> -		snd_soc_update_bits(codec, AB8500_ADSLOTSEL1, AB8500_MASK_ALL,
> -				AB8500_ADSLOTSELX_AD_OUT3_TO_SLOT_EVEN |
> -				AB8500_ADSLOTSELX_AD_OUT3_TO_SLOT_ODD);
> +		/* AD_OUT1 -> slot 0 & 1 */
> +		snd_soc_update_bits(codec, AB8500_ADSLOTSEL1,
> +				AB8500_MASK_ALL,
> +				AB8500_ADSLOTSELX_AD_OUT1_TO_SLOT_EVEN |
> +				AB8500_ADSLOTSELX_AD_OUT1_TO_SLOT_ODD);
>  		break;
>  	case 2:
> -		/* AD_OUT3 -> slot 0, AD_OUT2 -> slot 1 */
> +		/* AD_OUT1 -> slot 0, AD_OUT2 -> slot 1 */
>  		snd_soc_update_bits(codec,
>  				AB8500_ADSLOTSEL1,
>  				AB8500_MASK_ALL,
> -				AB8500_ADSLOTSELX_AD_OUT3_TO_SLOT_EVEN |
> +				AB8500_ADSLOTSELX_AD_OUT1_TO_SLOT_EVEN |
>  				AB8500_ADSLOTSELX_AD_OUT2_TO_SLOT_ODD);
>  		break;
>  	case 8:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
