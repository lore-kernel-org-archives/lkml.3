Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab3F0HxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:53:07 -0400
Received: from mx10.lb01.inode.at ([62.99.145.10]:2720 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753137Ab3F0HuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:50:04 -0400
X-Greylist: delayed 65017 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jun 2013 03:50:04 EDT
Message-ID: <51CBEEA4.5090106@streamunlimited.com>
Date: Thu, 27 Jun 2013 09:49:56 +0200
From: Marek Belisko <marek.belisko@streamunlimited.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Marek Belisko <marek.belisko@gmail.com>, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        lgirdwood@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, zonque@gmail.com
Subject: Re: [PATCH] ASoC: Add PCM1681 codec driver.
References: <1372251928-15706-1-git-send-email-marek.belisko@streamunlimited.com> <20130626143001.GP27646@sirena.org.uk>
In-Reply-To: <20130626143001.GP27646@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: marek.belisko@streamunlimited.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
On 06/26/2013 04:30 PM, Mark Brown wrote:
> On Wed, Jun 26, 2013 at 03:05:28PM +0200, Marek Belisko wrote:
>
>> +#define PCM1681_ATT_CONTROL(X)	(X <= 6 ? X : X + 9) /* Attenuation level */
>
> Write a function for this.
This macro is used when creating controls for channels volume so this 
cannot be rewritten to function. I also thinking about updating macro 
name to PCM1681_CHANNEL_VOL(X).
>
>> +static bool pcm1681_writeable_reg(struct device *dev, unsigned register reg)
>> +{
>> +	return pcm1681_accessible_reg(dev, reg) &&
>> +		(reg != PCM1681_ZERO_DETECT_STATUS);
>> +}
>
>> +static int pcm1681_digital_mute(struct snd_soc_dai *dai, int mute)
>> +{
>> +	struct snd_soc_codec *codec = dai->codec;
>> +	struct pcm1681_private *priv = snd_soc_codec_get_drvdata(codec);
>> +	int ret, val = 0;
>> +
>> +	if (mute)
>> +		val = PCM1681_SOFT_MUTE_ALL;
>> +
>
> This would be clearer if written as an if .. else - otherwise it looks
> like an uninitalised value might be used.
OK.
>
>> +static int pcm1681_hw_params(struct snd_pcm_substream *substream,
>> +			     struct snd_pcm_hw_params *params,
>> +			     struct snd_soc_dai *dai)
>> +{
>> +	struct snd_soc_codec *codec = dai->codec;
>> +	struct pcm1681_private *priv = snd_soc_codec_get_drvdata(codec);
>> +	int val = 0;
>> +	int pcm_format = params_format(params);
>> +
>> +	priv->rate = params_rate(params);
>> +
>
> Shouldn't there be a call to set the deemphasis here?
Right. I'll add it here.
>
>> +static int pcm1681_probe(struct snd_soc_codec *codec)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int pcm1681_remove(struct snd_soc_codec *codec)
>> +{
>> +	return 0;
>> +}
>
> Remove empty functions.
Will do.
>

Thanks,

marek

-- 
Marek Belisko

Software Developer
StreamUnlimited Engineering GmbH
Gutheil Schodergasse 8-12
A-1100 Vienna, Austria

Office: +421 267200087

e-mail: marek.belisko@streamunlimited.com
http://www.streamunlimited.com

Meet us at:

IFA - Berlin, 6-11 September
CEDIA - Denver, 25-28 September
