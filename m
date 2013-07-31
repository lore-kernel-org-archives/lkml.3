Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348Ab3GaQj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:39:59 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:49972 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760243Ab3GaQj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:39:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAK9yfHwZCBk5boyiak1FJ7WVJ+FxLjPk1Wa5eYbuZw8BaOV5jw@mail.gmail.com>
References: <cover.1375279948.git.viresh.kumar@linaro.org>
	<CAK9yfHwZCBk5boyiak1FJ7WVJ+FxLjPk1Wa5eYbuZw8BaOV5jw@mail.gmail.com>
Date: Wed, 31 Jul 2013 22:09:56 +0530
Message-ID: <CAKohpokTPBv5Z7uGffRJqKB-V=pMi8WAeWUuxNvt+3QV3YcRKg@mail.gmail.com>
Subject: Re: [PATCH 00/15] cpufreq: initialize drivers .owner field with THIS_MODULE
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 July 2013 22:06, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Hi Viresh,
>
> On 31 July 2013 19:49, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> CPUFreq core does following at multiple places:
>> module_{get|put}(cpufreq_driver->owner)).
>>
>> This is done to make sure module doesn't get unloaded if it is currently in use.
>> This will work only if the .owner field of cpufreq driver is initialized with a
>> valid pointer.
>>
>> This field wasn't initialized for many cpufreq driver, lets initialize it with
>> THIS_MODULE.
>
>
> Isn't it possible to do this inside cpufreq_register_driver function
> in a similar way as done for platform_driver_register [1].
>
> [1] https://lkml.org/lkml/2013/5/25/5

Don't know if its possible to set it to something other than THIS_MODULE.
In which case we want something else to be done.
