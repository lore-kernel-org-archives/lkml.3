Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab3KRP4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:56:44 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:36739 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3KRP4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:56:36 -0500
Message-ID: <528A38B1.5010107@koalo.de>
Date: Mon, 18 Nov 2013 16:56:33 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv3] ASoC: Add support for BCM2835
References: <5289F9DF.8060406@koalo.de> <1384776479.14845.208.camel@smile>
In-Reply-To: <1384776479.14845.208.camel@smile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +static int bcm2835_i2s_hw_params(struct snd_pcm_substream *substream,
>> +				 struct snd_pcm_hw_params *params,
>> +				 struct snd_soc_dai *dai)
>> +{
>> +	struct bcm2835_i2s_dev *dev = snd_soc_dai_get_drvdata(dai);
>> +
>> +	unsigned int sampling_rate = params_rate(params);
>> +	unsigned int data_length, data_delay, bclk_ratio;
>> +	unsigned int ch1pos, ch2pos, mode, format;
>> +	unsigned int mash = BCM2835_CLK_MASH_1;
>> +	unsigned int divi, divf, target_frequency;
>> +	int clk_src = -1;
>> +	unsigned int master = dev->fmt & SND_SOC_DAIFMT_MASTER_MASK;
>> +	uint32_t bit_master =	(master == SND_SOC_DAIFMT_CBS_CFS
>> +					|| master == SND_SOC_DAIFMT_CBS_CFM);
>> +
>> +	uint32_t frame_master =	(master == SND_SOC_DAIFMT_CBS_CFS
> 
> So, if master == SND_SOC_DAIFMT_CBS_CFS both bit_master and frame_master
> will be true. Is it correct?

Yes. That is exactly what CBS_CFS expresses:
Codec Bit Slave and Codec Frame Slave
So the interface is bit master as well as frame master.
Did I miss anything?
