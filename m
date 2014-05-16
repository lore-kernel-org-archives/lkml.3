Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbaEPJzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:55:00 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:42470 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbaEPJy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:54:57 -0400
MIME-Version: 1.0
In-Reply-To: <5375DE80.4030707@intel.com>
References: <CANuQgHFdYhTc8YZ2MbQv0r_CsJGDLwHOqy9NuVDEfVUOTsbRpA@mail.gmail.com>
	<1398170284-7551-1-git-send-email-chander.kashyap@linaro.org>
	<CANuQgHGLgrbYME7Y8zJQ6ACt7ByviZJMMEk+RbhqwXvnsm+8_g@mail.gmail.com>
	<5375DE80.4030707@intel.com>
Date: Fri, 16 May 2014 15:24:56 +0530
Message-ID: <CANuQgHHm9t2_4cv-wjDiLZpLOjR1HqzCpWMJHe8Znuj=97-HJw@mail.gmail.com>
Subject: Re: [RESEND][PATCH] cpuidle: governor: menu: move repeated correction
 factor check to init
From: Chander Kashyap <chander.kashyap@linaro.org>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2014 15:16, Rafael J. Wysocki <rafael.j.wysocki@intel.com> wrote:
> On 5/16/2014 10:16 AM, Chander Kashyap wrote:
>>
>> On 22 April 2014 18:08, Chander Kashyap <chander.kashyap@linaro.org>
>> wrote:
>>>
>>> In menu_select function we check for correction factor every time.
>>> If it is zero we are initializing to unity. Hence move it to init
>>> function
>>> and initialise by unity, hence avoid repeated comparisons.
>>>
>>> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
>>> Reviewed-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
>>> ---
>>>   drivers/cpuidle/governors/menu.c |   15 ++++++++-------
>>>   1 file changed, 8 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/cpuidle/governors/menu.c
>>> b/drivers/cpuidle/governors/menu.c
>>> index 71b5232..9b7918c 100644
>>> --- a/drivers/cpuidle/governors/menu.c
>>> +++ b/drivers/cpuidle/governors/menu.c
>>> @@ -311,13 +311,6 @@ static int menu_select(struct cpuidle_driver *drv,
>>> struct cpuidle_device *dev)
>>>          data->bucket = which_bucket(data->next_timer_us);
>>>
>>>          /*
>>> -        * if the correction factor is 0 (eg first time init or cpu
>>> hotplug
>>> -        * etc), we actually want to start out with a unity factor.
>>> -        */
>>> -       if (data->correction_factor[data->bucket] == 0)
>>> -               data->correction_factor[data->bucket] = RESOLUTION *
>>> DECAY;
>>> -
>>> -       /*
>>>           * Force the result of multiplication to be 64 bits even if both
>>>           * operands are 32 bits.
>>>           * Make sure to round up for half microseconds.
>>> @@ -466,9 +459,17 @@ static int menu_enable_device(struct cpuidle_driver
>>> *drv,
>>>                                  struct cpuidle_device *dev)
>>>   {
>>>          struct menu_device *data = &per_cpu(menu_devices, dev->cpu);
>>> +       int i;
>>>
>>>          memset(data, 0, sizeof(struct menu_device));
>>>
>>> +       /*
>>> +        * if the correction factor is 0 (eg first time init or cpu
>>> hotplug
>>> +        * etc), we actually want to start out with a unity factor.
>>> +        */
>>> +       for(i = 0; i < BUCKETS; i++)
>>> +               data->correction_factor[i] = RESOLUTION * DECAY;
>>> +
>>>          return 0;
>>>   }
>>>
>> ping.
>
>
> I believe this is in linux-next today, care to check?
>
> Rafael
>

Thanks, Rafael

-- 
with warm regards,
Chander Kashyap
