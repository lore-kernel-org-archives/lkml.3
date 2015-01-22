Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbbAVMQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:16:18 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:65238 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbbAVMQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:16:15 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-99-54c0e97bfd1c
Message-id: <54C0EA03.703@samsung.com>
Date: Thu, 22 Jan 2015 13:16:03 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Inha Song <ideal.song@samsung.com>
Cc: alsa-devel@alsa-project.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, kgene@kernel.org,
        sbkim73@samsung.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v3 1/4] ASoC: samsung: Add machine driver for
 Trats2
References: <1421925482-15861-1-git-send-email-ideal.song@samsung.com>
 <1421925482-15861-2-git-send-email-ideal.song@samsung.com>
In-reply-to: <1421925482-15861-2-git-send-email-ideal.song@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t/xq7rVLw+EGBy8zWpx5eIhJoupD5+w
	Wcw/co7Vov/NQlaLA392MFrs+nuf0eLcq5WMFv2PXzNbfLvSwWSx6fE1VovLu+awWcw4v4/J
	4vZlXoul1y8yWUyYvpbFonNXP6tF694j7BYXV3xhsni5+Q2Tg7DHhs9NbB5r5q1h9Ghp7mHz
	uNzXy+Sxc9Zddo+Vy7+weWxa1cnmcefaHjaPzUvqPfa9Xcbm0bdlFaPH5tPVHp83yQXwRnHZ
	pKTmZJalFunbJXBlvN4wn61gl3BFx6n9rA2MW/i7GDk5JARMJO7uWsYMYYtJXLi3nq2LkYtD
	SGApo8SeS2/BEkICnxgl7h7WBLF5BdQkFq/bxgJiswioSqxZegvMZhMwlOg92scIYosKREic
	vLuHHaJeUOLH5HtgNSJAvTPu9DKBLGAWOMgs8ajlIFiDsEC4xINDqxghNjczSnzYeZoNJMEp
	4C5xsWUd0CQOoA49ifsXtUDCzALyEpvXvGWewCgwC8mOWQhVs5BULWBkXsUomlqaXFCclJ5r
	pFecmFtcmpeul5yfu4kREqdfdzAuPWZ1iFGAg1GJhzdiw4EQIdbEsuLK3EOMEhzMSiK82+4D
	hXhTEiurUovy44tKc1KLDzEycXBKNTAadzLp/L1lec5dR1pMdaOFWPqP6xZhdxtqrj9r+Lqo
	UUzW63S9H2v3qodF+w7cuv+F6em9vfNeJqxqCfGe9VQk4+Mu7W9l4ra3P1vmP37pWvOqMGGj
	/aOm5iWS9zrubJeQ9DwtNENCT8Gp8kH2+6/fXHI/ZfQ96HPOiBM+6K7P9qnxgfrOWU+VWIoz
	Eg21mIuKEwGEWzUIsQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/15 12:17, Inha Song wrote:
> diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
> index fc67f97..8031423 100644
> --- a/sound/soc/samsung/Kconfig
> +++ b/sound/soc/samsung/Kconfig
> @@ -245,3 +245,11 @@ config SND_SOC_ARNDALE_RT5631_ALC5631
>          depends on SND_SOC_SAMSUNG
>          select SND_SAMSUNG_I2S
>          select SND_SOC_RT5631
> +
> +config SND_SOC_SAMSUNG_TRATS2_WM1811
> +	tristate "SoC I2S Audio support for WM1811 on Tizen Trats2 board"
> +	depends on SND_SOC_SAMSUNG
> +	select SND_SOC_WM8994
> +	select SND_SAMSUNG_I2S

Shouldn't you also select the MFD part of WM8994 here ?

> +++ b/sound/soc/samsung/trats2_wm1811.c
> @@ -0,0 +1,218 @@

> +static struct snd_soc_dai_link trats2_dai[] = {
> +	{
> +		.name		= "WM1811 AIF1",
> +		.stream_name	= "Pri_Dai",

Could we have a less cryptic name here, e.g. "HiFi Primary" ?

> +		.codec_dai_name = "wm8994-aif1",
> +		.codec_name	= "wm8994-codec",
> +		.ops		= &trats2_aif1_ops,
> +		.dai_fmt	= SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
> +				  SND_SOC_DAIFMT_CBM_CFM,
> +	},
> +};

> +static int trats2_audio_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct snd_soc_card *card = &trats2_card;
> +	struct device_node *codec_node;
> +	struct snd_soc_dai_link *dai_link = card->dai_link;
> +	struct trats2_machine_priv *priv = snd_soc_card_get_drvdata(card);
> +	int ret;
> +
> +	if (!np) {
> +		dev_err(&pdev->dev, "of node is missing.\n");
> +		return -ENODEV;

I'd say this whole np test could be dropped, we will fail right below
at the snd_soc_of_parse_card_name() function call if np is NULL.
Such a situation seems highly unlikely anyway.

> +	}
> +
> +	card->dev = &pdev->dev;
> +
> +	ret = snd_soc_of_parse_card_name(card, "samsung,model");
> +	if (ret) {
> +		dev_err(&pdev->dev,
> +			"Card name is not provided\n");

I guess it would fit in a single line.

> +		return ret;
> +	}
> +

> +static struct platform_driver trats2_audio_driver = {
> +	.driver = {
> +		.name		= "trats2-audio",
> +		.owner		= THIS_MODULE,

You can drop this .owner field assignment, it's also done in
module_platform_driver() macro.

> +		.pm		= &snd_soc_pm_ops,
> +		.of_match_table	= trats2_audio_of_match,
> +	},
> +	.probe	= trats2_audio_probe,
> +	.remove	= trats2_audio_remove,
> +};
> +
> +module_platform_driver(trats2_audio_driver);

--
Regards,
Sylwester
