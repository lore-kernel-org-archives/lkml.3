Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbbAZLbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:31:01 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:17548 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbbAZLa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:30:59 -0500
Message-ID: <54C62570.5050600@imgtec.com>
Date: Mon, 26 Jan 2015 11:30:56 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, <tiwai@suse.de>, <perex@perex.cz>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 4/4] sound: jz4740: Enable codec clock during dai_probe
References: <1422267511-6649-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1422267511-6649-5-git-send-email-Zubair.Kakakhel@imgtec.com> <54C61980.9030205@metafoo.de>
In-Reply-To: <54C61980.9030205@metafoo.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 26/01/15 10:40, Lars-Peter Clausen wrote:
> On 01/26/2015 11:18 AM, Zubair Lutfullah Kakakhel wrote:
>> As we are moving away from platform to DT, we cant rely on the board
>> file to do this now. So enable it here.
> 
> I don't understand this changelog. The board file never did this. The driver enables the clock in the startup() callback.

My bad.

I couldn't get the ci20 audio to work without this change.

I double checked. The clock is indeed enabled.

But the rate needs to be set for the ci20.

clk_set_rate(i2s->clk_i2s, 12000000);

Where should I put it? I couldn’t trace how the rate is set for the jz4740..

ZubairLK

> 
>>
>> Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
>> ---
>>   sound/soc/jz4740/jz4740-i2s.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/sound/soc/jz4740/jz4740-i2s.c b/sound/soc/jz4740/jz4740-i2s.c
>> index 3c309fc..a7e4a7b 100644
>> --- a/sound/soc/jz4740/jz4740-i2s.c
>> +++ b/sound/soc/jz4740/jz4740-i2s.c
>> @@ -376,6 +376,10 @@ static int jz4740_i2s_dai_probe(struct snd_soc_dai *dai)
>>           JZ_AIC_CONF_I2S |
>>           JZ_AIC_CONF_INTERNAL_CODEC;
>>
>> +    /* enable codec sysclk */
>> +    clk_set_rate(i2s->clk_i2s, 12000000);
>> +    clk_prepare_enable(i2s->clk_i2s);
>> +
>>       jz4740_i2s_write(i2s, JZ_REG_AIC_CONF, JZ_AIC_CONF_RESET);
>>       jz4740_i2s_write(i2s, JZ_REG_AIC_CONF, conf);
>>
>>
> 
