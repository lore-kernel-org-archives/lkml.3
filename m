Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbaGQRHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:07:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60763 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaGQRHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:07:13 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux-sound@vger.kernel.org" <linux-sound@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v7] ASoC: tas2552: Support TI TAS2552 Amplifier
Thread-Topic: [PATCH v7] ASoC: tas2552: Support TI TAS2552 Amplifier
Thread-Index: AQHPn5+zOIrOvAJDbUuqECPNOC5yFQ==
Date: Thu, 17 Jul 2014 17:07:07 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49D84EBF@DFLE09.ent.ti.com>
References: <1405368645-4168-1-git-send-email-dmurphy@ti.com>
 <20140717165816.GA17528@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark


On 07/17/2014 11:58 AM, Mark Brown wrote:
> On Mon, Jul 14, 2014 at 03:10:45PM -0500, Dan Murphy wrote:
>
> There's a few smallish issues below but this is basically good so I've
> applied it, please send incremental fixed for the things below.
>
>> +	/* Turn on Class D amplifier */
>> +	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_CLASSD_EN_MASK,
>> +						TAS2552_CLASSD_EN);
>> +
> Why is this being done in hw_params() and not using DAPM?
>
>> +static int tas2552_runtime_suspend(struct device *dev)
>> +{
>> +	struct tas2552_data *tas2552 = dev_get_drvdata(dev);
>> +
>> +	tas2552_sw_shutdown(tas2552, 0);
>> +
>> +	if (tas2552->enable_gpio)
>> +		gpiod_set_value(tas2552->enable_gpio, 0);
>> +
>> +	regcache_cache_only(tas2552->regmap, true);
>> +	regcache_mark_dirty(tas2552->regmap);
> It's better to do the GPIO set after making the device cache only in
> order to be sure nothing can come in and try to use the register map
> between the two.
>
>> +static void tas2552_shutdown(struct snd_pcm_substream *substream,
>> +			   struct snd_soc_dai *dai)
>> +{
>> +	struct snd_soc_codec *codec = dai->codec;
>> +
>> +	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_PLL_ENABLE, 0);
>> +}
> I'd also expect the PLL power to be managed via DAPM.
>
>> +	ret = pm_runtime_get_sync(codec->dev);
>> +	if (ret < 0) {
>> +		dev_err(codec->dev, "Enabling device failed: %d\n",
>> +			ret);
>> +		goto probe_fail;
>> +	}
> There's no matching put for this in remove().
>
>> +	snd_soc_write(codec, TAS2552_CFG_2, TAS2552_CLASSD_EN |
>> +				  TAS2552_BOOST_EN | TAS2552_APT_EN |
>> +				  TAS2552_LIM_EN);
>> +	return 0;
> The class D is still being enabled here.

Thanks will send updates in a day or two.

-- 
------------------
Dan Murphy

