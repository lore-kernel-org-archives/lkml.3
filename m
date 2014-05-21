Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaEUMrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 08:47:18 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:61095 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaEUMrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 08:47:17 -0400
MIME-Version: 1.0
In-Reply-To: <5368D645.7030206@st.com>
References: <1398172554-22053-1-git-send-email-valentin.ilie@gmail.com>
 <CAHuBVBZbLbAuVp3bwnWO45=9=irS8krPKiS905eC0K1Bgs4S9g@mail.gmail.com> <5368D645.7030206@st.com>
From: Valentin Ilie <valentin.ilie@gmail.com>
Date: Wed, 21 May 2014 15:46:56 +0300
X-Google-Sender-Auth: x-lT_Ove6wrlWBG7pfwrYpiF8x8
Message-ID: <CAHuBVBYHwPm8uD8n7hNeohwhwLBb_mqxH4N=z+6aE4k1WrSoHQ@mail.gmail.com>
Subject: Re: [PATCH] clk: st: Fix memory leak
To: Gabriel Fernandez <gabriel.fernandez@st.com>
Cc: Mike Turquette <mturquette@linaro.org>, pankaj.dev@st.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Even though the probability of getting a memory leak here is small I
think this patch is worth applying.

Thanks,
Valentin

On 6 May 2014 15:32, Gabriel Fernandez <gabriel.fernandez@st.com> wrote:
> Hi Valentin
> Thanks for the patch, i agree with it.
>
> Mike do you planned to integrate this patch ?
>
> Gabriel.
>
> Best Regards.
>
>
>
> On 05/06/2014 11:29 AM, Valentin Ilie wrote:
>>
>> On 22 April 2014 16:15, Valentin Ilie <valentin.ilie@gmail.com> wrote:
>>>
>>> When it fails to allocate div, gate should be free'd before return
>>>
>>> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
>>> ---
>>>   drivers/clk/st/clkgen-pll.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/clk/st/clkgen-pll.c b/drivers/clk/st/clkgen-pll.c
>>> index bca0a0b..a886702 100644
>>> --- a/drivers/clk/st/clkgen-pll.c
>>> +++ b/drivers/clk/st/clkgen-pll.c
>>> @@ -521,8 +521,10 @@ static struct clk * __init clkgen_odf_register(const
>>> char *parent_name,
>>>          gate->lock = odf_lock;
>>>
>>>          div = kzalloc(sizeof(*div), GFP_KERNEL);
>>> -       if (!div)
>>> +       if (!div) {
>>> +               kfree(gate);
>>>                  return ERR_PTR(-ENOMEM);
>>> +       }
>>>
>>>          div->flags = CLK_DIVIDER_ONE_BASED | CLK_DIVIDER_ALLOW_ZERO;
>>>          div->reg = reg + pll_data->odf[odf].offset;
>>> --
>>> 1.8.3.2
>>>
>> Can someone look into this?
>>
>



-- 
Valentin Ilie
+(40) 746 188 558
