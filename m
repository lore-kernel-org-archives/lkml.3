Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab3HBJmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:42:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51126 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248Ab3HBJmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:42:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokTPBv5Z7uGffRJqKB-V=pMi8WAeWUuxNvt+3QV3YcRKg@mail.gmail.com>
References: <cover.1375279948.git.viresh.kumar@linaro.org>
	<CAK9yfHwZCBk5boyiak1FJ7WVJ+FxLjPk1Wa5eYbuZw8BaOV5jw@mail.gmail.com>
	<CAKohpokTPBv5Z7uGffRJqKB-V=pMi8WAeWUuxNvt+3QV3YcRKg@mail.gmail.com>
Date: Fri, 2 Aug 2013 15:12:22 +0530
Message-ID: <CAK9yfHy_qUysGHNqcyJWQiW4eBAFs-U-FAZa952FBnqNdB-=Bw@mail.gmail.com>
Subject: Re: [PATCH 00/15] cpufreq: initialize drivers .owner field with THIS_MODULE
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 July 2013 22:09, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 31 July 2013 22:06, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>> Hi Viresh,
>>
>> On 31 July 2013 19:49, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>> CPUFreq core does following at multiple places:
>>> module_{get|put}(cpufreq_driver->owner)).
>>>
>>> This is done to make sure module doesn't get unloaded if it is currently in use.
>>> This will work only if the .owner field of cpufreq driver is initialized with a
>>> valid pointer.
>>>
>>> This field wasn't initialized for many cpufreq driver, lets initialize it with
>>> THIS_MODULE.
>>
>>
>> Isn't it possible to do this inside cpufreq_register_driver function
>> in a similar way as done for platform_driver_register [1].
>>
>> [1] https://lkml.org/lkml/2013/5/25/5
>
> Don't know if its possible to set it to something other than THIS_MODULE.
> In which case we want something else to be done.

Even I am curious to know if it is possible to set the owner to
something other than THIS_MODULE.

-- 
With warm regards,
Sachin
