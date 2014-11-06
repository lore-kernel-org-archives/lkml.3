Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbaKFN11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:27:27 -0500
Received: from smtp-out-006.synserver.de ([212.40.185.6]:1068 "EHLO
	smtp-out-002.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750828AbaKFN10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:27:26 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17272
Message-ID: <545B773E.3020103@metafoo.de>
Date: Thu, 06 Nov 2014 14:27:26 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Peter Rosin <peda@lysator.liu.se>, alsa-devel@alsa-project.org
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Peter Rosin <peda@axentia.se>, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 1/2] ASoC: tfa9879: New driver for NXP Semiconductors
 TFA9879 amplifier.
References: <1415278441-27866-1-git-send-email-peda@lysator.liu.se> <1415278441-27866-2-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1415278441-27866-2-git-send-email-peda@lysator.liu.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 01:54 PM, Peter Rosin wrote:
[...]
> +#define TFA9879_REG(codec, reg, field, value)				\
> +	snd_soc_update_bits(codec, TFA9879_ ## reg,			\
> +			    TFA9879_ ## field ## _MASK,			\
> +			    (value) << TFA9879_ ## field ## _SHIFT)
> +

I'm not sure I like this macro. Just using snd_soc_update_bits should make 
it easier to review the patch since people understand its sematnics.

[...]
> +static int tfa9879_probe(struct snd_soc_codec *codec)
> +{
> +	struct tfa9879_priv *tfa9879 = snd_soc_codec_get_drvdata(codec);
> +
> +	codec->control_data = tfa9879->regmap;

This is no longer necessary and won't even build with the latest ASoC tree.

> +
> +	return 0;
> +}
> +
[...]
> +static struct snd_soc_dai_ops tfa9879_dai_ops = {

const

> +	.prepare = tfa9879_prepare,
> +	.hw_params = tfa9879_hw_params,
> +	.shutdown = tfa9879_shutdown,
> +	.digital_mute = tfa9879_digital_mute,
> +	.set_fmt = tfa9879_set_fmt,
> +};
[...]

