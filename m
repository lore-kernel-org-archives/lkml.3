Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaDVC55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 22:57:57 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:36863 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaDVC5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 22:57:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAG-99FPLOXWnjb_oiDbLmdrYnDnticN9r1drDm_8JHtG=4BSiA@mail.gmail.com>
References: <1397137433-19106-1-git-send-email-chander.kashyap@linaro.org>
	<CAG-99FPLOXWnjb_oiDbLmdrYnDnticN9r1drDm_8JHtG=4BSiA@mail.gmail.com>
Date: Tue, 22 Apr 2014 08:27:53 +0530
Message-ID: <CANuQgHFGTkT0h6_FmxRxg4kYQA2NWEuzch1pj4Ec+_XnRHV2EQ@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: governor: menu: move repeated correction factor
 check to init
From: Chander Kashyap <chander.kashyap@linaro.org>
To: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rafael.j.wysocki@intel.com, Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping

On 10 April 2014 19:57, Tuukka Tikkanen <tuukka.tikkanen@linaro.org> wrote:
> On 10 April 2014 16:43, Chander Kashyap <chander.kashyap@linaro.org> wrote:
>> In menu_select function we check for correction factor every time.
>> If it is zero we are initializing to unity. Hence move it to init function
>> and initialise by unity, hence avoid repeated comparisons.
>>
>> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
>> ---
>>  drivers/cpuidle/governors/menu.c |   15 ++++++++-------
>>  1 file changed, 8 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
>> index cf7f2f0..048f6d9 100644
>> --- a/drivers/cpuidle/governors/menu.c
>> +++ b/drivers/cpuidle/governors/menu.c
>> @@ -315,13 +315,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>>         multiplier = performance_multiplier();
>>
>>         /*
>> -        * if the correction factor is 0 (eg first time init or cpu hotplug
>> -        * etc), we actually want to start out with a unity factor.
>> -        */
>> -       if (data->correction_factor[data->bucket] == 0)
>> -               data->correction_factor[data->bucket] = RESOLUTION * DECAY;
>> -
>> -       /*
>>          * Force the result of multiplication to be 64 bits even if both
>>          * operands are 32 bits.
>>          * Make sure to round up for half microseconds.
>> @@ -453,9 +446,17 @@ static int menu_enable_device(struct cpuidle_driver *drv,
>>                                 struct cpuidle_device *dev)
>>  {
>>         struct menu_device *data = &per_cpu(menu_devices, dev->cpu);
>> +       int i;
>>
>>         memset(data, 0, sizeof(struct menu_device));
>>
>> +       /*
>> +        * if the correction factor is 0 (eg first time init or cpu hotplug
>> +        * etc), we actually want to start out with a unity factor.
>> +        */
>> +       for(i = 0; i < BUCKETS; i++)
>> +               data->correction_factor[i] = RESOLUTION * DECAY;
>> +
>>         return 0;
>>  }
>>
>> --
>> 1.7.9.5
>>
>
> Reviewed-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>



-- 
with warm regards,
Chander Kashyap
