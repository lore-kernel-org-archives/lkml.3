Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3FZNws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:52:48 -0400
Received: from mailbackup.inode.at ([213.229.60.24]:54564 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab3FZNwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:52:46 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jun 2013 09:52:45 EDT
Message-ID: <51CAF0A7.3050104@streamunlimited.com>
Date: Wed, 26 Jun 2013 15:46:15 +0200
From: Marek Belisko <marek.belisko@streamunlimited.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>
CC: Marek Belisko <marek.belisko@gmail.com>, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        lgirdwood@gmail.com, broonie@kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Add PCM1681 codec driver.
References: <1372251928-15706-1-git-send-email-marek.belisko@streamunlimited.com> <51CAE9C8.3030005@gmail.com>
In-Reply-To: <51CAE9C8.3030005@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: marek.belisko@streamunlimited.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,
On 06/26/2013 03:16 PM, Daniel Mack wrote:
> Hi Marek,
>
> On 26.06.2013 15:05, Marek Belisko wrote:
>> PCM1681 can be controlled via I2C, SPI or in bootstrap mode. This code add
>> support only for I2C mode.
>>
>> Signed-off-by: Marek Belisko <marek.belisko@streamunlimited.com>
>> ---
>>   .../devicetree/bindings/sound/ti,pcm1681.txt       |   15 +
>>   sound/soc/codecs/Kconfig                           |    4 +
>>   sound/soc/codecs/Makefile                          |    2 +
>>   sound/soc/codecs/pcm1681.c                         |  328 ++++++++++++++++++++
>>   4 files changed, 349 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/sound/ti,pcm1681.txt
>>   create mode 100644 sound/soc/codecs/pcm1681.c
>>
>> diff --git a/Documentation/devicetree/bindings/sound/ti,pcm1681.txt b/Documentation/devicetree/bindings/sound/ti,pcm1681.txt
>> new file mode 100644
>> index 0000000..4df1718
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/sound/ti,pcm1681.txt
>> @@ -0,0 +1,15 @@
>> +Texas Instruments PCM1681 8-channel PWM Processor
>> +
>> +Required properties:
>> +
>> + - compatible:		Should contain "ti,pcm1681".
>> + - reg:			The i2c address. Should contain <0x4c>.
>> +
>> +Examples:
>> +
>> +	i2c_bus {
>> +		pcm1681@4c {
>> +			compatible = "ti,pcm1681";
>> +			reg = <0x4c>;
>> +		};
>> +	};
>> diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
>> index badb6fb..e2daf82 100644
>> --- a/sound/soc/codecs/Kconfig
>> +++ b/sound/soc/codecs/Kconfig
>> @@ -54,6 +54,7 @@ config SND_SOC_ALL_CODECS
>>   	select SND_SOC_MC13783 if MFD_MC13XXX
>>   	select SND_SOC_ML26124 if I2C
>>   	select SND_SOC_HDMI_CODEC
>> +	select SND_SOC_PCM1681 if I2C
>>   	select SND_SOC_PCM3008
>>   	select SND_SOC_RT5631 if I2C
>>   	select SND_SOC_RT5640 if I2C
>> @@ -292,6 +293,9 @@ config SND_SOC_MAX9850
>>   config SND_SOC_HDMI_CODEC
>>          tristate
>>
>> +config SND_SOC_PCM1681
>> +       tristate
>> +
>>   config SND_SOC_PCM3008
>>          tristate
>>
>> diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
>> index 70fd806..4a068d2 100644
>> --- a/sound/soc/codecs/Makefile
>> +++ b/sound/soc/codecs/Makefile
>> @@ -42,6 +42,7 @@ snd-soc-max9850-objs := max9850.o
>>   snd-soc-mc13783-objs := mc13783.o
>>   snd-soc-ml26124-objs := ml26124.o
>>   snd-soc-hdmi-codec-objs := hdmi.o
>> +snd-soc-pcm1681-objs := pcm1681.o
>>   snd-soc-pcm3008-objs := pcm3008.o
>>   snd-soc-rt5631-objs := rt5631.o
>>   snd-soc-rt5640-objs := rt5640.o
>> @@ -171,6 +172,7 @@ obj-$(CONFIG_SND_SOC_MAX9850)	+= snd-soc-max9850.o
>>   obj-$(CONFIG_SND_SOC_MC13783)	+= snd-soc-mc13783.o
>>   obj-$(CONFIG_SND_SOC_ML26124)	+= snd-soc-ml26124.o
>>   obj-$(CONFIG_SND_SOC_HDMI_CODEC) += snd-soc-hdmi-codec.o
>> +obj-$(CONFIG_SND_SOC_PCM1681)	+= snd-soc-pcm1681.o
>>   obj-$(CONFIG_SND_SOC_PCM3008)	+= snd-soc-pcm3008.o
>>   obj-$(CONFIG_SND_SOC_RT5631)	+= snd-soc-rt5631.o
>>   obj-$(CONFIG_SND_SOC_RT5640)	+= snd-soc-rt5640.o
>> diff --git a/sound/soc/codecs/pcm1681.c b/sound/soc/codecs/pcm1681.c
>> new file mode 100644
>> index 0000000..6122fd1
>> --- /dev/null
>> +++ b/sound/soc/codecs/pcm1681.c
>> @@ -0,0 +1,328 @@
>> +/*
>> + * PCM1681 ASoC codec driver
>> + *
>> + * Copyright (c) StreamUnlimited GmbH 2013
>> + *	Marek Belisko <marek.belisko@streamunlimited.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version 2
>> + * of the License, or (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/delay.h>
>> +#include <linux/gpio.h>
>> +#include <linux/i2c.h>
>> +#include <linux/regmap.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_gpio.h>
>> +#include <sound/pcm.h>
>> +#include <sound/pcm_params.h>
>> +#include <sound/soc.h>
>> +#include <sound/tlv.h>
>> +
>> +#define PCM1681_PCM_FORMATS (SNDRV_PCM_FMTBIT_S16_LE  |		\
>> +			     SNDRV_PCM_FMTBIT_S24_LE)
>> +
>> +#define PCM1681_PCM_RATES   (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_16000 | \
>> +			     SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_44100  | \
>> +			     SNDRV_PCM_RATE_48000 | SNDRV_PCM_RATE_88200  | \
>> +			     SNDRV_PCM_RATE_96000 | SNDRV_PCM_RATE_192000)
>> +
>> +#define PCM1681_SOFT_MUTE_ALL		0xff
>> +#define PCM1681_DEEMPH_RATE_MASK	0x18
>> +#define PCM1681_DEEMPH_MASK		0x01
>> +
>> +#define PCM1681_ATT_CONTROL(X)	(X <= 6 ? X : X + 9) /* Attenuation level */
>> +#define PCM1681_SOFT_MUTE	0x07	/* Soft mute control register */
>> +#define PCM1681_DAC_CONTROL	0x08	/* DAC operation control */
>> +#define PCM1681_FMT_CONTROL	0x09	/* Audio interface data format */
>> +#define PCM1681_DEEMPH_CONTROL	0x0a	/* De-emphasis control */
>> +#define PCM1681_ZERO_DETECT_STATUS	0x0e	/* Zero detect status reg */
>> +
>> +static const struct reg_default pcm1681_reg_defaults[] = {
>> +	{ 0x01,	0xff },
>> +	{ 0x02,	0xff },
>> +	{ 0x03,	0xff },
>> +	{ 0x04,	0xff },
>> +	{ 0x05,	0xff },
>> +	{ 0x06,	0xff },
>> +	{ 0x07,	0x00 },
>> +	{ 0x08,	0x00 },
>> +	{ 0x09,	0x06 },
>> +	{ 0x0A,	0x00 },
>> +	{ 0x0B,	0xff },
>> +	{ 0x0C,	0x0f },
>> +	{ 0x0D,	0x00 },
>> +	{ 0x10,	0xff },
>> +	{ 0x11,	0xff },
>> +	{ 0x12,	0x00 },
>> +	{ 0x13,	0x00 },
>> +};
>> +
>> +static bool pcm1681_accessible_reg(struct device *dev, unsigned int reg)
>> +{
>> +	return !((reg == 0x00) || (reg == 0x0f));
>> +}
>> +
>> +static bool pcm1681_writeable_reg(struct device *dev, unsigned register reg)
>> +{
>> +	return pcm1681_accessible_reg(dev, reg) &&
>> +		(reg != PCM1681_ZERO_DETECT_STATUS);
>> +}
>> +
>> +struct pcm1681_private {
>> +	struct regmap *regmap;
>> +	unsigned int format;
>> +	/* Current deemphasis status */
>> +	unsigned int deemph;
>> +	/* Current rate for deemphasis control */
>> +	unsigned int rate;
>> +};
>> +
>> +static int pcm1681_deemph[] = { 44100, 48000, 32000 };
>> +
>> +static int pcm1681_set_deemph(struct snd_soc_codec *codec)
>> +{
>> +	struct pcm1681_private *priv = snd_soc_codec_get_drvdata(codec);
>> +	int i = 0, val = -1, ret;
>> +
>> +	if (priv->deemph)
>> +		for (i = 0; i < ARRAY_SIZE(pcm1681_deemph); i++)
>> +			if (pcm1681_deemph[i] == priv->rate)
>> +				val = i;
>> +
>> +	/* enable choosen frequency */
>> +	if (val != -1)
>> +		regmap_update_bits(priv->regmap, PCM1681_DEEMPH_CONTROL,
>> +					PCM1681_DEEMPH_RATE_MASK, val);
>> +
>> +	/* enable/disable deemphasis functionality */
>> +	ret = regmap_update_bits(priv->regmap, PCM1681_DEEMPH_CONTROL,
>> +				PCM1681_DEEMPH_MASK, priv->deemph);
>> +
>> +	return ret;
>> +}
>> +
>> +static int pcm1681_get_deemph(struct snd_kcontrol *kcontrol,
>> +			      struct snd_ctl_elem_value *ucontrol)
>> +{
>> +	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
>> +	struct pcm1681_private *priv = snd_soc_codec_get_drvdata(codec);
>> +
>> +	ucontrol->value.enumerated.item[0] = priv->deemph;
>> +
>> +	return 0;
>> +}
>> +
>> +static int pcm1681_put_deemph(struct snd_kcontrol *kcontrol,
>> +			      struct snd_ctl_elem_value *ucontrol)
>> +{
>> +	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
>> +	struct pcm1681_private *priv = snd_soc_codec_get_drvdata(codec);
>> +
>> +	priv->deemph = ucontrol->value.enumerated.item[0];
>> +
>> +	return pcm1681_set_deemph(codec);
>> +}
>> +
>> +static int pcm1681_set_dai_fmt(struct snd_soc_dai *codec_dai,
>> +			      unsigned int format)
>> +{
>> +	struct snd_soc_codec *codec = codec_dai->codec;
>> +	struct pcm1681_private *priv = snd_soc_codec_get_drvdata(codec);
>> +
>> +	/* The PCM1681 can only be slave to all clocks */
>> +	if ((format & SND_SOC_DAIFMT_MASTER_MASK) != SND_SOC_DAIFMT_CBS_CFS) {
>> +		dev_err(codec->dev, "Invalid clocking mode\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	priv->format = format;
>> +
>> +	return 0;
>> +}
>> +
>> +static int pcm1681_digital_mute(struct snd_soc_dai *dai, int mute)
>> +{
>> +	struct snd_soc_codec *codec = dai->codec;
>> +	struct pcm1681_private *priv = snd_soc_codec_get_drvdata(codec);
>> +	int ret, val = 0;
>> +
>> +	if (mute)
>> +		val = PCM1681_SOFT_MUTE_ALL;
>> +
>> +	ret = regmap_write(priv->regmap, PCM1681_SOFT_MUTE, val);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return 0;
>> +}
>> +
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
>> +	switch (priv->format & SND_SOC_DAIFMT_FORMAT_MASK) {
>> +	case SND_SOC_DAIFMT_RIGHT_J:
>> +		if (pcm_format == SNDRV_PCM_FORMAT_S24_LE)
>> +			val = 0x00;
>> +		else if (pcm_format == SNDRV_PCM_FORMAT_S16_LE)
>> +			val = 0x03;
>> +		break;
>> +	case SND_SOC_DAIFMT_I2S:
>> +		val = 0x04;
>> +		break;
>> +	case SND_SOC_DAIFMT_LEFT_J:
>> +		val = 0x05;
>> +		break;
>> +	default:
>> +		dev_err(codec->dev, "Invalid DAI format\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	regmap_update_bits(priv->regmap, PCM1681_FMT_CONTROL, 0x0f, val);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct snd_soc_dai_ops pcm1681_dai_ops = {
>> +	.set_fmt	= pcm1681_set_dai_fmt,
>> +	.hw_params	= pcm1681_hw_params,
>> +	.digital_mute	= pcm1681_digital_mute,
>> +};
>> +
>> +static const DECLARE_TLV_DB_SCALE(pcm1681_dac_tlv, -6350, 50, 1);
>> +
>> +static const struct snd_kcontrol_new pcm1681_controls[] = {
>> +	SOC_DOUBLE_R_TLV("PCM1681 Channel 1/2 Playback Volume",
>> +			PCM1681_ATT_CONTROL(1), PCM1681_ATT_CONTROL(2), 0,
>> +			0x7f, 0, pcm1681_dac_tlv),
>> +	SOC_DOUBLE_R_TLV("PCM1681 Channel 3/4 Playback Volume",
>> +			PCM1681_ATT_CONTROL(3), PCM1681_ATT_CONTROL(4), 0,
>> +			0x7f, 0, pcm1681_dac_tlv),
>> +	SOC_DOUBLE_R_TLV("PCM1681 Channel 5/6 Playback Volume",
>> +			PCM1681_ATT_CONTROL(5), PCM1681_ATT_CONTROL(6), 0,
>> +			0x7f, 0, pcm1681_dac_tlv),
>> +	SOC_DOUBLE_R_TLV("PCM1681 Channel 7/8 Playback Volume",
>> +			PCM1681_ATT_CONTROL(7), PCM1681_ATT_CONTROL(8), 0,
>> +			0x7f, 0, pcm1681_dac_tlv),
>> +	SOC_SINGLE_BOOL_EXT("PCM1681 De-emphasis Switch", 0,
>> +			    pcm1681_get_deemph, pcm1681_put_deemph),
>> +};
>> +
>> +struct snd_soc_dai_driver pcm1681_dai = {
>> +	.name = "pcm1681-hifi",
>> +	.playback = {
>> +		.stream_name = "Playback",
>> +		.channels_min = 2,
>> +		.channels_max = 8,
>> +		.rates = PCM1681_PCM_RATES,
>> +		.formats = PCM1681_PCM_FORMATS,
>> +	},
>> +	.ops = &pcm1681_dai_ops,
>> +};
>> +
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id pcm1681_dt_ids[] = {
>> +	{ .compatible = "ti,pcm1681", },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(of, pcm1681_dt_ids);
>> +#endif
>> +
>> +static const struct regmap_config pcm1681_regmap = {
>> +	.reg_bits		= 8,
>> +	.val_bits		= 8,
>> +	.max_register		= ARRAY_SIZE(pcm1681_reg_defaults),
>> +	.reg_defaults		= pcm1681_reg_defaults,
>> +	.num_reg_defaults	= ARRAY_SIZE(pcm1681_reg_defaults),
>> +	.writeable_reg		= pcm1681_writeable_reg,
>> +	.readable_reg		= pcm1681_accessible_reg,
>> +};
>> +
>> +static int pcm1681_probe(struct snd_soc_codec *codec)
>> +{
>> +	return 0;
>
> Is there really nothing the driver has to do in order to bring the codec
> into full operation mode?
This codec have only POWER-ON-RESET function. It means codec need system 
clock (normally MCLK) for some amount of time to get out of reset and 
then you can communicate with it.
>
>> +}
>> +
>> +static int pcm1681_remove(struct snd_soc_codec *codec)
>> +{
>> +	return 0;
>> +}
>> +
>> +static struct snd_soc_codec_driver soc_codec_dev_pcm1681 = {
>> +	.probe			= pcm1681_probe,
>> +	.remove			= pcm1681_remove,
>> +	.controls		= pcm1681_controls,
>> +	.num_controls		= ARRAY_SIZE(pcm1681_controls),
>> +};
>> +
>> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
>> +static const struct i2c_device_id pcm1681_i2c_id[] = {
>> +	{"pcm1681", 0},
>> +	{}
>> +};
>> +MODULE_DEVICE_TABLE(i2c, pcm1681_i2c_id);
>> +
>> +static int pcm1681_i2c_probe(struct i2c_client *client,
>> +			      const struct i2c_device_id *id)
>> +{
>> +	int ret;
>> +	struct pcm1681_private *priv;
>> +
>> +	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
>> +	if (!priv)
>> +		return -ENOMEM;
>> +
>> +	priv->regmap = devm_regmap_init_i2c(client, &pcm1681_regmap);
>> +	if (IS_ERR(priv->regmap)) {
>> +		ret = PTR_ERR(priv->regmap);
>> +		dev_err(&client->dev, "Failed to create regmap: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	i2c_set_clientdata(client, priv);
>> +
>
> Is there any way to probe the device is there at all? I'd like to bail
> early in case the bus or i2c address doesn't match for example.
Probing is done here because we assume that codec is out of reset.
>
> Also, I wonder whether there are any reset lines that might be connected
> to GPIOs of the MCU. If so, it would be good idea to add support for
> that in this driver. But that can be done at some later point as well.
No other pins which can be handled.
>
>
> Best,
> Daniel
>

Regards,

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
