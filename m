Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbaFSLYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:24:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58874 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756577AbaFSLYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:24:19 -0400
Message-ID: <53A2C86D.5040308@ti.com>
Date: Thu, 19 Jun 2014 14:24:29 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Julia Lawall <julia.lawall@lip6.fr>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        J Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH] CLK: TI: DRA7: return error code in failure case
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr> <1400473875-22228-4-git-send-email-Julia.Lawall@lip6.fr> <20140519074155.GO15585@mwanda> <5379BC0C.3070401@ti.com> <alpine.DEB.2.10.1405191924330.2564@hadrien> <5379F7AE.2040806@ti.com> <20140528214739.10062.75330@quantum>
In-Reply-To: <20140528214739.10062.75330@quantum>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 12:47 AM, Mike Turquette wrote:
> Quoting Tero Kristo (2014-05-19 05:23:10)
>> On 05/19/2014 02:25 PM, Julia Lawall wrote:
>>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>>
>>> Add a returned error code in the MAX_APLL_WAIT_TRIES case.  Remove the
>>> updating of the return variable r to 0 if MAX_APLL_WAIT_TRIES is not yet
>>> reached, because r is already 0 at this point.
>>>
>>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Acked-by: Tero Kristo <t-kristo@ti.com>
>>
>> Mike, do you want to queue this as a fix or shall I add this to be
>> queued for 3.16?
>
> It's not a visible regression, so let's go with 3.16.

Thanks, queued for 3.16-rc fixes now, sorry about the latency.

-Tero

>
> Regards,
> Mike
>
>>
>> -Tero
>>
>>>
>>> ---
>>> diff --git a/drivers/clk/ti/apll.c b/drivers/clk/ti/apll.c
>>> index b986f61..efc71a0 100644
>>> --- a/drivers/clk/ti/apll.c
>>> +++ b/drivers/clk/ti/apll.c
>>> @@ -77,13 +77,11 @@ static int dra7_apll_enable(struct clk_hw *hw)
>>>        if (i == MAX_APLL_WAIT_TRIES) {
>>>                pr_warn("clock: %s failed transition to '%s'\n",
>>>                        clk_name, (state) ? "locked" : "bypassed");
>>> -     } else {
>>> +             r = -EBUSY;
>>> +     } else
>>>                pr_debug("clock: %s transition to '%s' in %d loops\n",
>>>                         clk_name, (state) ? "locked" : "bypassed", i);
>>>
>>> -             r = 0;
>>> -     }
>>> -
>>>        return r;
>>>    }
>>>
>>

