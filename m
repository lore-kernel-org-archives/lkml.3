Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3GHOio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 10:38:44 -0400
Received: from smtp-out-123.synserver.de ([212.40.185.123]:1086 "EHLO
	smtp-out-123.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3GHOin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 10:38:43 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1773
Message-ID: <51DACF15.9080303@metafoo.de>
Date: Mon, 08 Jul 2013 16:39:17 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH v2 1/5] sound: sam9x5_wm8731: machine driver
 for at91sam9x5 wm8731 boards
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com> <1373290193-25300-2-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1373290193-25300-2-git-send-email-richard.genoud@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 03:29 PM, Richard Genoud wrote:
[...]
> +/*
> + * Logic for a wm8731 as connected on a at91sam9x5 based board.
> + */
> +static int at91sam9x5ek_wm8731_init(struct snd_soc_pcm_runtime *rtd)
> +{
[...]
> +	codec_dai->driver->playback.rates &= SNDRV_PCM_RATE_8000 |
> +		SNDRV_PCM_RATE_32000 |
> +		SNDRV_PCM_RATE_48000 |
> +		SNDRV_PCM_RATE_96000;
> +	codec_dai->driver->capture.rates &= SNDRV_PCM_RATE_8000 |
> +		SNDRV_PCM_RATE_32000 |
> +		SNDRV_PCM_RATE_48000 |
> +		SNDRV_PCM_RATE_96000;

That's not right. The driver structure is shared between all instances of
the codec, a single instance should not modify it. If you need to constrain
the list of supported rates use snd_pcm_hw_constraint_list().

> +
> +	/* set the codec system clock for DAC and ADC */
> +	ret = snd_soc_dai_set_sysclk(codec_dai, WM8731_SYSCLK_XTAL,
> +				     MCLK_RATE, SND_SOC_CLOCK_IN);
> +	if (ret < 0) {
> +		dev_err(dev, "ASoC: Failed to set WM8731 SYSCLK: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* signal a DAPM event */
> +	snd_soc_dapm_sync(dapm);

This should not be necessary.

> +	return 0;
> +}

