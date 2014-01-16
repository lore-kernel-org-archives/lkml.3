Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaAPBbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:31:19 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:8930 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbaAPBbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:31:15 -0500
Message-ID: <52D7366B.1030909@atmel.com>
Date: Thu, 16 Jan 2014 09:31:23 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <nicolas.ferre@atmel.com>, <plagnioj@jcrosoft.com>,
        <linux-sound@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ASoC: atmel_wm8904: make it available to choose clock
References: <1389669956-2304-1-git-send-email-voice.shen@atmel.com> <1389669956-2304-3-git-send-email-voice.shen@atmel.com> <20140114203650.GX15567@sirena.org.uk>
In-Reply-To: <20140114203650.GX15567@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 01/15/2014 04:36 AM, Mark Brown wrote:
> On Tue, Jan 14, 2014 at 11:25:55AM +0800, Bo Shen wrote:
>> Make it available to choose the clock from TK pin or RK pin. This
>> is hardware design decided.
>
>> --- a/sound/soc/atmel/atmel_wm8904.c
>> +++ b/sound/soc/atmel/atmel_wm8904.c
>> @@ -108,6 +108,7 @@ static int atmel_asoc_wm8904_dt_init(struct platform_device *pdev)
>>   	struct device_node *codec_np, *cpu_np;
>>   	struct snd_soc_card *card = &atmel_asoc_wm8904_card;
>>   	struct snd_soc_dai_link *dailink = &atmel_asoc_wm8904_dailink;
>> +	struct atmel_ssc_info *ssc_info;
>>   	int ret;
>>
>>   	if (!np) {
>> @@ -115,6 +116,15 @@ static int atmel_asoc_wm8904_dt_init(struct platform_device *pdev)
>>   		return -EINVAL;
>>   	}
>>
>> +	ssc_info = devm_kzalloc(&pdev->dev, sizeof(*ssc_info), GFP_KERNEL);
>> +	if (!ssc_info)
>> +		return -ENOMEM;
>> +
>> +	ssc_info->clk_from_rk_pin =
>> +		of_property_read_bool(np, "clk_from_rk_pin");
>> +
>> +	card->drvdata = (void *)ssc_info;
>
> Shouldn't this code be in the DAI driver?  Otherwise this series looks
> fine to me, though the DT folks might have something to say I guess.

   For audio on Atmel SoC, it depends on three device nodes, one is SSC 
node, one is the codec node and the sound node.
   The sound node will parse by machine driver, and machine driver is 
mainly for hardware connection. As the "clk_from_rk_pin" is decided by 
hardware, so, I put it here.
   If I move the code to dai driver, it will parse the sound node in dai 
driver, I think it will make the code a little bit not explicit. What do 
you think?

Best Regards,
Bo Shen

