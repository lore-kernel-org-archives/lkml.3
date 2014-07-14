Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaGNKK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:10:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37991 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbaGNKKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:10:33 -0400
Message-ID: <53C3AC94.5050904@ti.com>
Date: Mon, 14 Jul 2014 13:10:28 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tero Kristo <t-kristo@ti.com>, Mike Turquette <mturquette@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: ti: clk-7xx: Correct ABE DPLL configuration
References: <1396446525-20302-1-git-send-email-peter.ujfalusi@ti.com> <533C1AC2.1000307@ti.com> <533CFFB3.9070201@ti.com> <5358D534.2070205@ti.com> <535927DF.90404@ti.com> <5368E604.4040107@ti.com>
In-Reply-To: <5368E604.4040107@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 04:39 PM, Peter Ujfalusi wrote:
>>> Tero: can I have your ack for this patch or do you have further concerns?
>>
>> Yea looks good to me, except for the fact that there is some work on getting
>> default rate/parent support through DT. I would like a comment from Mike about
>> the estimate when this can get in, and whether we should merge intermediate
>> solutions still like this.
>>
>> Anyway, you can consider this patch acked by me, I'll let Mike to decide what
>> to do with it though.
> 
> Do you have anything against this patch? Since right now there is no other
> ways to fix the ABE DPLL for dra7 it would be great if we could have this in
> till we have the final solution. Also I'd like to point out that the original
> frequency the ABE DPLL was not correct and renders the audio to be not usable
> on the platform.

Mike: can we have this patch still pushed for 3.16? I can resend it right away
if you  lost the original patch.

Thanks,
Péter


> 
>>>>
>>>>>
>>>>> -Tero
>>>>>
>>>>>>
>>>>>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>>>>>> ---
>>>>>>    drivers/clk/ti/clk-7xx.c | 7 ++++++-
>>>>>>    1 file changed, 6 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
>>>>>> index f7e40734c819..19a55bf407dd 100644
>>>>>> --- a/drivers/clk/ti/clk-7xx.c
>>>>>> +++ b/drivers/clk/ti/clk-7xx.c
>>>>>> @@ -16,7 +16,7 @@
>>>>>>    #include <linux/clkdev.h>
>>>>>>    #include <linux/clk/ti.h>
>>>>>>
>>>>>> -#define DRA7_DPLL_ABE_DEFFREQ                361267200
>>>>>> +#define DRA7_DPLL_ABE_DEFFREQ                180633600
>>>>>>    #define DRA7_DPLL_GMAC_DEFFREQ                1000000000
>>>>>>
>>>>>>
>>>>>> @@ -322,6 +322,11 @@ int __init dra7xx_dt_clk_init(void)
>>>>>>        if (rc)
>>>>>>            pr_err("%s: failed to configure ABE DPLL!\n", __func__);
>>>>>>
>>>>>> +    dpll_ck = clk_get_sys(NULL, "dpll_abe_m2x2_ck");
>>>>>> +    rc = clk_set_rate(dpll_ck, DRA7_DPLL_ABE_DEFFREQ * 2);
>>>>>> +    if (rc)
>>>>>> +        pr_err("%s: failed to configure ABE DPLL m2x2!\n", __func__);
>>>>>> +
>>>>>>        dpll_ck = clk_get_sys(NULL, "dpll_gmac_ck");
>>>>>>        rc = clk_set_rate(dpll_ck, DRA7_DPLL_GMAC_DEFFREQ);
>>>>>>        if (rc)
>>>>>>
>>>>>
>>>>
>>>>
>>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

