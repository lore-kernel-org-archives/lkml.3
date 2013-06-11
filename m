Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3FKQCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:02:39 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:15349
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754969Ab3FKQCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:02:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Message-ID: <51B749F5.3010907@freescale.com>
Date: Tue, 11 Jun 2013 13:01:57 -0300
From: Fabio Estevam <fabio.estevam@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oskar Schirmer <oskar@scara.com>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Zeng Zhaoming <zengzm.kernel@gmail.com>, <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2] sound/sgtl5000: fix codec register initial values
 and mask
References: <51B71608.3000302@freescale.com> <1370964151-6728-1-git-send-email-oskar@scara.com>
In-Reply-To: <1370964151-6728-1-git-send-email-oskar@scara.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 12:22 PM, Oskar Schirmer wrote:
> According to documentation bit 3:2 in register SSS_CTRL are
> reserved and zero, so initially setting the register to 0x0008
> does not make much sense. Instead, bit 4 should be marked set,
> as this is the power up default.
>
> Further, mask computation in declarative part is obviously wrong:
> Fix FRAC DIVISOR to provide an 11 bit mask correctly.
>
> Signed-off-by: Oskar Schirmer <oskar@scara.com>
> Tested-by: Fabio Estevam <fabio.estevam@freescale.com>

Looks good, but please copy Mark Brown. Just added him in Cc now.


> ---
>   sound/soc/codecs/sgtl5000.c |    2 +-
>   sound/soc/codecs/sgtl5000.h |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
> index d441559..10092ba 100644
> --- a/sound/soc/codecs/sgtl5000.c
> +++ b/sound/soc/codecs/sgtl5000.c
> @@ -38,7 +38,7 @@
>   static const struct reg_default sgtl5000_reg_defaults[] = {
>   	{ SGTL5000_CHIP_CLK_CTRL,		0x0008 },
>   	{ SGTL5000_CHIP_I2S_CTRL,		0x0010 },
> -	{ SGTL5000_CHIP_SSS_CTRL,		0x0008 },
> +	{ SGTL5000_CHIP_SSS_CTRL,		0x0010 },
>   	{ SGTL5000_CHIP_DAC_VOL,		0x3c3c },
>   	{ SGTL5000_CHIP_PAD_STRENGTH,		0x015f },
>   	{ SGTL5000_CHIP_ANA_HP_CTRL,		0x1818 },
> diff --git a/sound/soc/codecs/sgtl5000.h b/sound/soc/codecs/sgtl5000.h
> index 4b69229..52bd843 100644
> --- a/sound/soc/codecs/sgtl5000.h
> +++ b/sound/soc/codecs/sgtl5000.h
> @@ -347,7 +347,7 @@
>   #define SGTL5000_PLL_INT_DIV_MASK		0xf800
>   #define SGTL5000_PLL_INT_DIV_SHIFT		11
>   #define SGTL5000_PLL_INT_DIV_WIDTH		5
> -#define SGTL5000_PLL_FRAC_DIV_MASK		0x0700
> +#define SGTL5000_PLL_FRAC_DIV_MASK		0x07ff
>   #define SGTL5000_PLL_FRAC_DIV_SHIFT		0
>   #define SGTL5000_PLL_FRAC_DIV_WIDTH		11
>
>


