Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaG2QNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:13:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48565 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaG2QNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:13:01 -0400
MIME-Version: 1.0
In-Reply-To: <53D759E6.3060607@ti.com>
References: <1396446525-20302-1-git-send-email-peter.ujfalusi@ti.com>
 <533C1AC2.1000307@ti.com> <533CFFB3.9070201@ti.com> <5358D534.2070205@ti.com>
 <535927DF.90404@ti.com> <5368E604.4040107@ti.com> <53C3AC94.5050904@ti.com>
 <20140729062748.4906.1529@quantum> <53D759E6.3060607@ti.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Tue, 29 Jul 2014 09:12:38 -0700
Message-ID: <CAPtuhTjMAZcHecO0dr+3zDurCfQH32pmYUQ+zNXhRdS_+vJZsg@mail.gmail.com>
Subject: Re: [PATCH] clk: ti: clk-7xx: Correct ABE DPLL configuration
To: Tero Kristo <t-kristo@ti.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 1:23 AM, Tero Kristo <t-kristo@ti.com> wrote:
> On 07/29/2014 09:27 AM, Mike Turquette wrote:
>>
>> Quoting Peter Ujfalusi (2014-07-14 03:10:28)
>>>
>>> On 05/06/2014 04:39 PM, Peter Ujfalusi wrote:
>>>>>>
>>>>>> Tero: can I have your ack for this patch or do you have further
>>>>>> concerns?
>>>>>
>>>>>
>>>>> Yea looks good to me, except for the fact that there is some work on
>>>>> getting
>>>>> default rate/parent support through DT. I would like a comment from
>>>>> Mike about
>>>>> the estimate when this can get in, and whether we should merge
>>>>> intermediate
>>>>> solutions still like this.
>>
>>
>> Tero,
>>
>> On May 19 you said, "Thanks, queued for 3.16/ti-clk-drv." but I never
>> received that as part of the TI clock fixes. :-(
>>
>> I've taken Sylwester's patch in for the DT-based assigned clock rates
>> and parents. You can find it in clk-next. (maybe you are still on
>> vacation? I don't know...)
>>
>>>>>
>>>>> Anyway, you can consider this patch acked by me, I'll let Mike to
>>>>> decide what
>>>>> to do with it though.
>>>>
>>>>
>>>> Do you have anything against this patch? Since right now there is no
>>>> other
>>>> ways to fix the ABE DPLL for dra7 it would be great if we could have
>>>> this in
>>>> till we have the final solution. Also I'd like to point out that the
>>>> original
>>>> frequency the ABE DPLL was not correct and renders the audio to be not
>>>> usable
>>>> on the platform.
>>>
>>>
>>> Mike: can we have this patch still pushed for 3.16? I can resend it right
>>> away
>>> if you  lost the original patch.
>>
>>
>> Peter,
>>
>> I have your original patch. No need to resend. Let's see if Tero
>> comments this week, otherwise I can take it with his previously supplied
>> Ack and send it off. Probably needs to be sent by Thursday at the
>> latest.
>
>
> Oh yea, seems this got lost into the myriad of branches I have. I can push
> this on top of my for-v3.17/ti-clk-drv if you like.

That is the easiest thing for me. I think that Peter wanted to take
this as a fix for 3.16 though. Peter is that correct?

Regards,
Mike

>
> -Tero
>
>
>>
>> Regards,
>> Mike
>>
>>>
>>> Thanks,
>>> Péter
>>>
>>>
>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> -Tero
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>>>>>>>>> ---
>>>>>>>>>     drivers/clk/ti/clk-7xx.c | 7 ++++++-
>>>>>>>>>     1 file changed, 6 insertions(+), 1 deletion(-)
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
>>>>>>>>> index f7e40734c819..19a55bf407dd 100644
>>>>>>>>> --- a/drivers/clk/ti/clk-7xx.c
>>>>>>>>> +++ b/drivers/clk/ti/clk-7xx.c
>>>>>>>>> @@ -16,7 +16,7 @@
>>>>>>>>>     #include <linux/clkdev.h>
>>>>>>>>>     #include <linux/clk/ti.h>
>>>>>>>>>
>>>>>>>>> -#define DRA7_DPLL_ABE_DEFFREQ                361267200
>>>>>>>>> +#define DRA7_DPLL_ABE_DEFFREQ                180633600
>>>>>>>>>     #define DRA7_DPLL_GMAC_DEFFREQ                1000000000
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> @@ -322,6 +322,11 @@ int __init dra7xx_dt_clk_init(void)
>>>>>>>>>         if (rc)
>>>>>>>>>             pr_err("%s: failed to configure ABE DPLL!\n",
>>>>>>>>> __func__);
>>>>>>>>>
>>>>>>>>> +    dpll_ck = clk_get_sys(NULL, "dpll_abe_m2x2_ck");
>>>>>>>>> +    rc = clk_set_rate(dpll_ck, DRA7_DPLL_ABE_DEFFREQ * 2);
>>>>>>>>> +    if (rc)
>>>>>>>>> +        pr_err("%s: failed to configure ABE DPLL m2x2!\n",
>>>>>>>>> __func__);
>>>>>>>>> +
>>>>>>>>>         dpll_ck = clk_get_sys(NULL, "dpll_gmac_ck");
>>>>>>>>>         rc = clk_set_rate(dpll_ck, DRA7_DPLL_GMAC_DEFFREQ);
>>>>>>>>>         if (rc)
>>>>>>>>>
>>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>
