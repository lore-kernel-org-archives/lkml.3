Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaA0HG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 02:06:28 -0500
Received: from smtp-out-178.synserver.de ([212.40.185.178]:1056 "EHLO
	smtp-out-209.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750895AbaA0HG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 02:06:27 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 27563
Message-ID: <52E6056F.2050008@metafoo.de>
Date: Mon, 27 Jan 2014 08:06:23 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: broonie@kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        nicolas.ferre@atmel.com, Liam Girdwood <lgirdwood@gmail.com>,
        linux-sound@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH v2 1/3] ASoC: atmel_ssc_dai: make option
 to choose clock
References: <1390805726-1841-1-git-send-email-voice.shen@atmel.com> <1390805726-1841-2-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1390805726-1841-2-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 07:55 AM, Bo Shen wrote:
> When SSC works in slave mode, according to the hardware design, the
> clock can get from TK pin, also can get from RK pin. So, add one
> parameter to choose where the clock from.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
> Changes in v2: None
> 
>  sound/soc/atmel/atmel_ssc_dai.c | 16 ++++++++++++----
>  sound/soc/atmel/atmel_ssc_dai.h |  1 +
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
> index 8697ced..03eb0be 100644
> --- a/sound/soc/atmel/atmel_ssc_dai.c
> +++ b/sound/soc/atmel/atmel_ssc_dai.c
> @@ -340,6 +340,7 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
>  	struct snd_soc_dai *dai)
>  {
>  	int id = dai->id;
> +	struct snd_soc_card *card = dai->card;
>  	struct atmel_ssc_info *ssc_p = &ssc_info[id];
>  	struct atmel_pcm_dma_params *dma_params;
>  	int dir, channels, bits;
> @@ -347,6 +348,9 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
>  	int start_event;
>  	int ret;
>  
> +	ssc_p->clk_from_rk_pin =
> +		((struct atmel_ssc_info *)(card->drvdata))->clk_from_rk_pin;

This is a layering violation. The DAI driver is not supposed to make any
assumptions what drvdata is attached to the card. Use the set_sysclk API to
set the source clock.

- Lars
