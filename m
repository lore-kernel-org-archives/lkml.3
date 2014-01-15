Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaAORQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:16:15 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:51461 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaAORQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:16:13 -0500
Message-ID: <52D6C258.6010204@atmel.com>
Date: Wed, 15 Jan 2014 18:16:08 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, <broonie@kernel.org>
CC: <plagnioj@jcrosoft.com>, <linux-sound@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-arm-kernel@lists.infradead.org>,
        "Liam Girdwood" <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, "Takashi Iwai" <tiwai@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ASoC: atmel_wm8904: make it available to choose clock
References: <1389669956-2304-1-git-send-email-voice.shen@atmel.com> <1389669956-2304-3-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1389669956-2304-3-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/2014 04:25, Bo Shen :
> Make it available to choose the clock from TK pin or RK pin. This
> is hardware design decided.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
> 
>  sound/soc/atmel/atmel_wm8904.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/sound/soc/atmel/atmel_wm8904.c b/sound/soc/atmel/atmel_wm8904.c
> index b4e3690..b85088d 100644
> --- a/sound/soc/atmel/atmel_wm8904.c
> +++ b/sound/soc/atmel/atmel_wm8904.c
> @@ -108,6 +108,7 @@ static int atmel_asoc_wm8904_dt_init(struct platform_device *pdev)
>  	struct device_node *codec_np, *cpu_np;
>  	struct snd_soc_card *card = &atmel_asoc_wm8904_card;
>  	struct snd_soc_dai_link *dailink = &atmel_asoc_wm8904_dailink;
> +	struct atmel_ssc_info *ssc_info;
>  	int ret;
>  
>  	if (!np) {
> @@ -115,6 +116,15 @@ static int atmel_asoc_wm8904_dt_init(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> +	ssc_info = devm_kzalloc(&pdev->dev, sizeof(*ssc_info), GFP_KERNEL);

Isn't an atmel_ssc_info structure table already instantiated in
sound/soc/atmel/atmel_ssc_dai.c ...
I see, you copy the information contained in this field in the proper
ssc_info of the DAI in the previous patch... Well, isn't it a better way
to pass parameters to the DAI than this one?


> +	if (!ssc_info)
> +		return -ENOMEM;
> +
> +	ssc_info->clk_from_rk_pin =
> +		of_property_read_bool(np, "clk_from_rk_pin");
> +
> +	card->drvdata = (void *)ssc_info;
> +
>  	ret = snd_soc_of_parse_card_name(card, "atmel,model");
>  	if (ret) {
>  		dev_err(&pdev->dev, "failed to parse card name\n");
> 


-- 
Nicolas Ferre
