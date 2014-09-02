Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaIBKYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:24:30 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51975 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaIBKY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:24:27 -0400
Message-ID: <54059A35.3020303@gmail.com>
Date: Tue, 02 Sep 2014 15:51:41 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>, broonie@kernel.org, perex@perex.cz,
        lgirdwood@gmail.com, tiwai@suse.de, moinejf@free.fr, andrew@lunn.ch,
        kuninori.morimoto.gx@renesas.com, jsarha@ti.com,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/4] ASoC: simple-card: add asoc_simple_card_fmt_master()
 to simplify the code.
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com> <1409649969-15759-2-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1409649969-15759-2-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 02:56 PM, Xiubo Li wrote:
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>   sound/soc/generic/simple-card.c | 61 ++++++++++++++++++++---------------------
>   1 file changed, 29 insertions(+), 32 deletions(-)
>
> diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
> index 986d2c7..cad2b30 100644
> --- a/sound/soc/generic/simple-card.c
> +++ b/sound/soc/generic/simple-card.c
> @@ -163,6 +163,26 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
>   	return 0;
>   }
>   
> +static inline unsigned int
> +asoc_simple_card_fmt_master(struct device_node *np,
> +			    struct device_node *bitclkmaster,
> +			    struct device_node *framemaster)
> +{
> +	switch (((np == bitclkmaster) << 4) | (np == framemaster)) {
> +	case 0x11:
> +		return SND_SOC_DAIFMT_CBS_CFS;
> +	case 0x10:
> +		return SND_SOC_DAIFMT_CBS_CFM;
> +	case 0x01:
> +		return SND_SOC_DAIFMT_CBM_CFS;
> +	default:
> +		return SND_SOC_DAIFMT_CBM_CFM;
> +	}
> +
> +	/* Shouldn't be here */
> +	return -EINVAL;
> +}

It will be nice if we declare the switch case numbers as macros (specific name)...



-- 
Regards,
Varka Bhadram.

