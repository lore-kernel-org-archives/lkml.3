Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3IYPem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:34:42 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:62397 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab3IYPel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:34:41 -0400
Message-ID: <52430278.3040604@gmail.com>
Date: Wed, 25 Sep 2013 17:34:16 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] clocksource: of: respect device tree node status
References: <523AD63A.8040906@gmail.com> <52430167.4000701@linaro.org>
In-Reply-To: <52430167.4000701@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 05:29 PM, Daniel Lezcano wrote:
> On 09/19/2013 12:47 PM, Sebastian Hesselbarth wrote:
>> Clocksource devices provided by DT can be disabled (status != "okay").
>> Instead of registering clocksource drivers for disabled nodes, respect
>> the device's status by skiping disabled nodes.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>
> Shall it be applied as a 3.12 fix ?

Daniel,

difficult to say. Although I am not aware of any mainline mach
depends on it, I consider this a fix. So, if there are no objections
please apply for 3.12.

Sebastian

>> ---
>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   drivers/clocksource/clksrc-of.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/clocksource/clksrc-of.c
>> b/drivers/clocksource/clksrc-of.c
>> index 37f5325..b9ddd9e 100644
>> --- a/drivers/clocksource/clksrc-of.c
>> +++ b/drivers/clocksource/clksrc-of.c
>> @@ -30,6 +30,9 @@ void __init clocksource_of_init(void)
>>       clocksource_of_init_fn init_func;
>>        for_each_matching_node_and_match(np, __clksrc_of_table, &match) {
>> +        if (!of_device_is_available(np))
>> +            continue;
>> +
>>           init_func = match->data;
>>           init_func(np);
>>       }
>
>

