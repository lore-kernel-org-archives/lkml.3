Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaESJJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:09:26 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:60432 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbaESJJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:09:16 -0400
Message-ID: <5379CA47.4020900@linaro.org>
Date: Mon, 19 May 2014 11:09:27 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/2] clocksource: fix type confusion for clocksource_mmio_readX_Y
References: <1398219120-23029-1-git-send-email-Li.Xiubo@freescale.com> <7dd1dc731dd24e15a170ef95aeee2a2e@BY2PR03MB505.namprd03.prod.outlook.com>
In-Reply-To: <7dd1dc731dd24e15a170ef95aeee2a2e@BY2PR03MB505.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 04:35 AM, Li.Xiubo@freescale.com wrote:
> Hi,
> 
> I'd like to know the status about this patch series...
> :£©

I think the patches are ok. I have them in my queue for 3.16.

>> -----Original Message-----
>> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
>> Sent: Wednesday, April 23, 2014 10:12 AM
>> To: daniel.lezcano@linaro.org; tglx@linutronix.de; linux-
>> kernel@vger.kernel.org
>> Cc: Xiubo Li-B47053
>> Subject: [PATCHv2 1/2] clocksource: fix type confusion for
>> clocksource_mmio_readX_Y
>>
>> The types' definations are:
>>     o  cycle_t       -> u64
>>     o  readl_relaxed -> u32
>>     o  readw_relaxed -> u16
>>
>> So let clocksource_mmio_readX_Ys return a cast to cycle_t, though
>> this maybe look reduntant sometimes, it make sense and they will be
>> more readable and less confusion...
>>
>> This patch clarifies the functions type and fix it.
>>
>> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>> ---
>>   drivers/clocksource/mmio.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
>> index c0e2512..19a6b3f 100644
>> --- a/drivers/clocksource/mmio.c
>> +++ b/drivers/clocksource/mmio.c
>> @@ -22,22 +22,22 @@ static inline struct clocksource_mmio
>> *to_mmio_clksrc(struct clocksource *c)
>>
>>   cycle_t clocksource_mmio_readl_up(struct clocksource *c)
>>   {
>> -	return readl_relaxed(to_mmio_clksrc(c)->reg);
>> +	return (cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
>>   }
>>
>>   cycle_t clocksource_mmio_readl_down(struct clocksource *c)
>>   {
>> -	return ~readl_relaxed(to_mmio_clksrc(c)->reg);
>> +	return ~(cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
>>   }
>>
>>   cycle_t clocksource_mmio_readw_up(struct clocksource *c)
>>   {
>> -	return readw_relaxed(to_mmio_clksrc(c)->reg);
>> +	return (cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg);
>>   }
>>
>>   cycle_t clocksource_mmio_readw_down(struct clocksource *c)
>>   {
>> -	return ~(unsigned)readw_relaxed(to_mmio_clksrc(c)->reg);
>> +	return ~(cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg);
>>   }
>>
>>   /**
>> --
>> 1.8.4
> 


-- 
 <http://www.linaro.org/> Linaro.org ©¦ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

