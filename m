Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3IZKSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:18:52 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50799 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab3IZKSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:18:50 -0400
Message-ID: <52440A07.4050101@linaro.org>
Date: Thu, 26 Sep 2013 12:18:47 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>, takasi-y@ops.dti.ne.jp
CC: SH-Linux <linux-sh@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/6] clocksource: em_sti: convert to clk_prepare/unprepare
References: <52410F86.4040301@renesas.com> <20130924130924.61d4ecedf3d4fca5952d55fc@ops.dti.ne.jp> <20130924044236.GC3619@verge.net.au>
In-Reply-To: <20130924044236.GC3619@verge.net.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 06:42 AM, Simon Horman wrote:
> [ CCed Daniel Lezcano and Thomas Gleixner, the clocksource maintainers ]
>
> On Tue, Sep 24, 2013 at 01:09:24PM +0900, takasi-y@ops.dti.ne.jp wrote:
>> From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
>>
>> Add calls to clk_prepare and unprepare so that EMMA Mobile EV2 can
>> migrate to the common clock framework.
>>
>> Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>

I am not a clk framework expert but at the first glance sounds correct.

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

>> ---
>>   drivers/clocksource/em_sti.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
>> index 3a5909c..9d17083 100644
>> --- a/drivers/clocksource/em_sti.c
>> +++ b/drivers/clocksource/em_sti.c
>> @@ -78,7 +78,7 @@ static int em_sti_enable(struct em_sti_priv *p)
>>   	int ret;
>>
>>   	/* enable clock */
>> -	ret = clk_enable(p->clk);
>> +	ret = clk_prepare_enable(p->clk);
>>   	if (ret) {
>>   		dev_err(&p->pdev->dev, "cannot enable clock\n");
>>   		return ret;
>> @@ -107,7 +107,7 @@ static void em_sti_disable(struct em_sti_priv *p)
>>   	em_sti_write(p, STI_INTENCLR, 3);
>>
>>   	/* stop clock */
>> -	clk_disable(p->clk);
>> +	clk_disable_unprepare(p->clk);
>>   }
>>
>>   static cycle_t em_sti_count(struct em_sti_priv *p)
>> --
>> 1.8.1.5
>>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

