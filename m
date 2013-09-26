Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3IZAK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 20:10:26 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:45967 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3IZAKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 20:10:25 -0400
Message-ID: <52437B6E.1030402@linaro.org>
Date: Thu, 26 Sep 2013 02:10:22 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] clocksource: of: respect device tree node status
References: <523AD63A.8040906@gmail.com> <52430167.4000701@linaro.org> <52430278.3040604@gmail.com>
In-Reply-To: <52430278.3040604@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 05:34 PM, Sebastian Hesselbarth wrote:
> On 09/25/2013 05:29 PM, Daniel Lezcano wrote:
>> On 09/19/2013 12:47 PM, Sebastian Hesselbarth wrote:
>>> Clocksource devices provided by DT can be disabled (status != "okay").
>>> Instead of registering clocksource drivers for disabled nodes, respect
>>> the device's status by skiping disabled nodes.
>>>
>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>
>> Shall it be applied as a 3.12 fix ?
> 
> Daniel,
> 
> difficult to say. Although I am not aware of any mainline mach
> depends on it, I consider this a fix. So, if there are no objections
> please apply for 3.12.

Ok, applied to my tree.

Thanks
  -- Daniel

>>> ---
>>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>   drivers/clocksource/clksrc-of.c |    3 +++
>>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/clocksource/clksrc-of.c
>>> b/drivers/clocksource/clksrc-of.c
>>> index 37f5325..b9ddd9e 100644
>>> --- a/drivers/clocksource/clksrc-of.c
>>> +++ b/drivers/clocksource/clksrc-of.c
>>> @@ -30,6 +30,9 @@ void __init clocksource_of_init(void)
>>>       clocksource_of_init_fn init_func;
>>>        for_each_matching_node_and_match(np, __clksrc_of_table, &match) {
>>> +        if (!of_device_is_available(np))
>>> +            continue;
>>> +
>>>           init_func = match->data;
>>>           init_func(np);
>>>       }
>>
>>
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

