Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3EHISb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 04:18:31 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:53189 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3EHIS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 04:18:28 -0400
Date: Wed, 8 May 2013 09:18:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 4/6] ASoC: ux500: Update tx tdm slots configuration
Message-ID: <20130508081823.GI3102@gmail.com>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-5-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367997261-32048-5-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 May 2013, Fabio Baltieri wrote:

> Update ab8500-codec and mop500_ab8500 tx slot configuration to reflect
> the actual one used by STE.  Also update a wrong comment in the process.
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>  sound/soc/codecs/ab8500-codec.c | 20 ++++++++++----------
>  sound/soc/ux500/mop500_ab8500.c |  4 ++--
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
> index 3126cac..7c026d4 100644
> --- a/sound/soc/codecs/ab8500-codec.c
> +++ b/sound/soc/codecs/ab8500-codec.c
> @@ -2300,18 +2300,18 @@ static int ab8500_codec_set_dai_tdm_slot(struct snd_soc_dai *dai,
>  	case 0:
>  		break;
>  	case 1:
> -		/* Slot 9 -> DA_IN1 & DA_IN3 */
> -		snd_soc_update_bits(codec, AB8500_DASLOTCONF1, mask, 11);
> -		snd_soc_update_bits(codec, AB8500_DASLOTCONF3, mask, 11);
> -		snd_soc_update_bits(codec, AB8500_DASLOTCONF2, mask, 11);
> -		snd_soc_update_bits(codec, AB8500_DASLOTCONF4, mask, 11);
> +		/* Slot 8 -> DA_IN1 to DA_IN4 */
> +		snd_soc_update_bits(codec, AB8500_DASLOTCONF1, mask, 8);
> +		snd_soc_update_bits(codec, AB8500_DASLOTCONF3, mask, 8);
> +		snd_soc_update_bits(codec, AB8500_DASLOTCONF2, mask, 8);
> +		snd_soc_update_bits(codec, AB8500_DASLOTCONF4, mask, 8);
>  		break;
>  	case 2:
> -		/* Slot 9 -> DA_IN1 & DA_IN3, Slot 11 -> DA_IN2 & DA_IN4 */
> -		snd_soc_update_bits(codec, AB8500_DASLOTCONF1, mask, 9);
> -		snd_soc_update_bits(codec, AB8500_DASLOTCONF3, mask, 9);
> -		snd_soc_update_bits(codec, AB8500_DASLOTCONF2, mask, 11);
> -		snd_soc_update_bits(codec, AB8500_DASLOTCONF4, mask, 11);
> +		/* Slot 8 -> DA_IN1 & DA_IN3, Slot 9 -> DA_IN2 & DA_IN4 */
> +		snd_soc_update_bits(codec, AB8500_DASLOTCONF1, mask, 8);
> +		snd_soc_update_bits(codec, AB8500_DASLOTCONF3, mask, 8);
> +		snd_soc_update_bits(codec, AB8500_DASLOTCONF2, mask, 9);
> +		snd_soc_update_bits(codec, AB8500_DASLOTCONF4, mask, 9);
>  
>  		break;
>  	case 8:
> diff --git a/sound/soc/ux500/mop500_ab8500.c b/sound/soc/ux500/mop500_ab8500.c
> index 4606194..44899f7 100644
> --- a/sound/soc/ux500/mop500_ab8500.c
> +++ b/sound/soc/ux500/mop500_ab8500.c
> @@ -28,8 +28,8 @@
>  #include "ux500_msp_dai.h"
>  #include "../codecs/ab8500-codec.h"
>  
> -#define TX_SLOT_MONO	0x0008
> -#define TX_SLOT_STEREO	0x000a
> +#define TX_SLOT_MONO	0x0001
> +#define TX_SLOT_STEREO	0x0003
>  #define RX_SLOT_MONO	0x0001
>  #define RX_SLOT_STEREO	0x0003
>  #define TX_SLOT_8CH	0x00FF

Looks fine: Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
