Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaG2IVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:21:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47224 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbaG2IVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:21:25 -0400
Message-ID: <53D759E6.3060607@ti.com>
Date: Tue, 29 Jul 2014 11:23:02 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: ti: clk-7xx: Correct ABE DPLL configuration
References: <1396446525-20302-1-git-send-email-peter.ujfalusi@ti.com> <533C1AC2.1000307@ti.com> <533CFFB3.9070201@ti.com> <5358D534.2070205@ti.com> <535927DF.90404@ti.com> <5368E604.4040107@ti.com> <53C3AC94.5050904@ti.com> <20140729062748.4906.1529@quantum>
In-Reply-To: <20140729062748.4906.1529@quantum>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 09:27 AM, Mike Turquette wrote:
> Quoting Peter Ujfalusi (2014-07-14 03:10:28)
>> On 05/06/2014 04:39 PM, Peter Ujfalusi wrote:
>>>>> Tero: can I have your ack for this patch or do you have further concerns?
>>>>
>>>> Yea looks good to me, except for the fact that there is some work on getting
>>>> default rate/parent support through DT. I would like a comment from Mike about
>>>> the estimate when this can get in, and whether we should merge intermediate
>>>> solutions still like this.
>
> Tero,
>
> On May 19 you said, "Thanks, queued for 3.16/ti-clk-drv." but I never
> received that as part of the TI clock fixes. :-(
>
> I've taken Sylwester's patch in for the DT-based assigned clock rates
> and parents. You can find it in clk-next. (maybe you are still on
> vacation? I don't know...)
>
>>>>
>>>> Anyway, you can consider this patch acked by me, I'll let Mike to decide what
>>>> to do with it though.
>>>
>>> Do you have anything against this patch? Since right now there is no other
>>> ways to fix the ABE DPLL for dra7 it would be great if we could have this in
>>> till we have the final solution. Also I'd like to point out that the original
>>> frequency the ABE DPLL was not correct and renders the audio to be not usable
>>> on the platform.
>>
>> Mike: can we have this patch still pushed for 3.16? I can resend it right away
>> if you  lost the original patch.
>
> Peter,
>
> I have your original patch. No need to resend. Let's see if Tero
> comments this week, otherwise I can take it with his previously supplied
> Ack and send it off. Probably needs to be sent by Thursday at the
> latest.

Oh yea, seems this got lost into the myriad of branches I have. I can 
push this on top of my for-v3.17/ti-clk-drv if you like.

-Tero

>
> Regards,
> Mike
>
>>
>> Thanks,
>> Péter
>>
>>
>>>
>>>>>>
>>>>>>>
>>>>>>> -Tero
>>>>>>>
>>>>>>>>
>>>>>>>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>>>>>>>> ---
>>>>>>>>     drivers/clk/ti/clk-7xx.c | 7 ++++++-
>>>>>>>>     1 file changed, 6 insertions(+), 1 deletion(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
>>>>>>>> index f7e40734c819..19a55bf407dd 100644
>>>>>>>> --- a/drivers/clk/ti/clk-7xx.c
>>>>>>>> +++ b/drivers/clk/ti/clk-7xx.c
>>>>>>>> @@ -16,7 +16,7 @@
>>>>>>>>     #include <linux/clkdev.h>
>>>>>>>>     #include <linux/clk/ti.h>
>>>>>>>>
>>>>>>>> -#define DRA7_DPLL_ABE_DEFFREQ                361267200
>>>>>>>> +#define DRA7_DPLL_ABE_DEFFREQ                180633600
>>>>>>>>     #define DRA7_DPLL_GMAC_DEFFREQ                1000000000
>>>>>>>>
>>>>>>>>
>>>>>>>> @@ -322,6 +322,11 @@ int __init dra7xx_dt_clk_init(void)
>>>>>>>>         if (rc)
>>>>>>>>             pr_err("%s: failed to configure ABE DPLL!\n", __func__);
>>>>>>>>
>>>>>>>> +    dpll_ck = clk_get_sys(NULL, "dpll_abe_m2x2_ck");
>>>>>>>> +    rc = clk_set_rate(dpll_ck, DRA7_DPLL_ABE_DEFFREQ * 2);
>>>>>>>> +    if (rc)
>>>>>>>> +        pr_err("%s: failed to configure ABE DPLL m2x2!\n", __func__);
>>>>>>>> +
>>>>>>>>         dpll_ck = clk_get_sys(NULL, "dpll_gmac_ck");
>>>>>>>>         rc = clk_set_rate(dpll_ck, DRA7_DPLL_GMAC_DEFFREQ);
>>>>>>>>         if (rc)
>>>>>>>>
>>>>>>>
>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>

