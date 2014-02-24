Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaBXRxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:53:54 -0500
Received: from smtp-out-075.synserver.de ([212.40.185.75]:1062 "EHLO
	smtp-out-167.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752314AbaBXRxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:53:52 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 23110
Message-ID: <530B8741.3010302@metafoo.de>
Date: Mon, 24 Feb 2014 18:54:09 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Nicolin Chen <Guangyu.Chen@freescale.com>
CC: broonie@kernel.org, brian.austin@cirrus.com, Paul.Handrigan@cirrus.com,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-doc@vger.kernel.org,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        rob@landley.net, galak@codeaurora.org, grant.likely@linaro.org
Subject: Re: [alsa-devel] [PATCH] ASoC: cs42888: Add codec driver support
References: <1393224929-7555-1-git-send-email-Guangyu.Chen@freescale.com>
In-Reply-To: <1393224929-7555-1-git-send-email-Guangyu.Chen@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Couple of trivial things.

On 02/24/2014 07:55 AM, Nicolin Chen wrote:
[...]
> +config SND_SOC_CS42888
> +	tristate "Cirrus Logic CS42888 CODEC"
> +	depends on I2C

should select REGMAP_I2C

> +
[...]
> +#define CS42888_NUM_SUPPLIES 4
> +static const char *cs42888_supply_names[CS42888_NUM_SUPPLIES] = {

const char *const

> +	"VA",
> +	"VD",
> +	"VLS",
> +	"VLC",
> +};
> +
> +static const char *cs42888_adc_single[] = { "Differential", "Single-Ended" };

const char * const

> +static const char *cs42888_szc[] = { "Immediate Change", "Zero Cross",
> +				     "Soft Ramp", "Soft Ramp on Zero Cross" };
> +

const char * constr

> +static const struct soc_enum cs42888_enum[] = {
> +	SOC_ENUM_SINGLE(CS42888_ADCCTL, 4, 2, cs42888_adc_single),
> +	SOC_ENUM_SINGLE(CS42888_ADCCTL, 3, 2, cs42888_adc_single),
> +	SOC_ENUM_SINGLE(CS42888_TXCTL, 5, 4, cs42888_szc),
> +	SOC_ENUM_SINGLE(CS42888_TXCTL, 0, 4, cs42888_szc),
> +};

Usually it makes things a bit more clearer when you have a variable with a 
unique name for each enum rather then putting them into one large array.

> +
[...]
> +static struct cs42888_ratios cs42888_ratios[] = {

const

[...]
> +static struct snd_soc_dai_ops cs42888_dai_ops = {

const

> +	.set_fmt	= cs42888_set_dai_fmt,
> +	.set_sysclk	= cs42888_set_dai_sysclk,
> +	.hw_params	= cs42888_hw_params,
> +	.digital_mute	= cs42888_digital_mute,
> +};
> +
[...]
> +
> +static struct reg_default cs42888_reg[] = {

const
[...]
> +
> +static struct snd_soc_codec_driver cs42888_driver = {

const

> +	.probe = cs42888_probe,
> +	.idle_bias_off = true,
> +
> +	.controls = cs42888_snd_controls,
> +	.num_controls = ARRAY_SIZE(cs42888_snd_controls),
> +	.dapm_widgets = cs42888_dapm_widgets,
> +	.num_dapm_widgets = ARRAY_SIZE(cs42888_dapm_widgets),
> +	.dapm_routes = cs42888_dapm_routes,
> +	.num_dapm_routes = ARRAY_SIZE(cs42888_dapm_routes),
> +};
> +

