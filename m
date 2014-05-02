Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaEBMQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 08:16:04 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48423 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaEBMQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 08:16:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponv-p20=www51rW13RSG6=ACgDrRDfL9Xd26ePgjkpWfA@mail.gmail.com>
References: <1398992810-14957-1-git-send-email-nm@ti.com>
	<CAKohpokEuZ69HnnKE89maXk=21cgAMjEYjEvEcaoBpg4bLRsGg@mail.gmail.com>
	<CAGo_u6ohKZh+zKWSzGbvT+AKgnhSjzX7v9isqpd2pc-Cpmxocg@mail.gmail.com>
	<CAKohponv-p20=www51rW13RSG6=ACgDrRDfL9Xd26ePgjkpWfA@mail.gmail.com>
Date: Fri, 2 May 2014 07:15:58 -0500
X-Google-Sender-Auth: KIeV9Q0pLu3p10h4PGlLkDKOTGY
Message-ID: <CAGo_u6oT6nK0-Sj8yp9C2r8FkQ8SXF8LvhbHxDjAoGs+Pd=szA@mail.gmail.com>
Subject: Re: [RFC PATCH] PM / OPP: move cpufreq specific OPP functions out of
 generic OPP library
From: Nishanth Menon <nm@ti.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 12:22 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 2 May 2014 10:48, Nishanth Menon <nm@ti.com> wrote:
>> On Thu, May 1, 2014 at 11:30 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>>> diff --git a/drivers/cpufreq/cpufreq_opp.c b/drivers/cpufreq/cpufreq_opp.c
>>>> new file mode 100644
>>>> index 0000000..2602ff8
>>>> --- /dev/null
>>>> +++ b/drivers/cpufreq/cpufreq_opp.c
>>>> @@ -0,0 +1,102 @@
>>>> +/*
>>>> + * Generic OPP Interface for CPUFREQ drivers
>>>> + *
>>>> + * Copyright (C) 2009-2014 Texas Instruments Incorporated.
>>>> + *     Nishanth Menon
>>>> + *     Romit Dasgupta
>>>> + *     Kevin Hilman
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License version 2 as
>>>> + * published by the Free Software Foundation.
>>>> + */
>>>
>>> I hope you have just copy pasted routines to this file, and haven't done
>>> even the most minor modification in those, as its hard to review it.
>>
>> there is code replacement ofcourse ->
>> * the logic of walking down the list holding a mutex has been replaced
>> with rcu locks,
>> * instead of reading internal data structure and generating the list,
>> use the existing search API that does exactly the same.
>> * Documentation update for the same.
>
> Hmm, actually if I would have written this patch, then probably I would
> have done the same thing, but looking from the reviewers perspective,
> it would be much more easy if we can separate things into patches.
>
> So, maybe do these changes first in opp.c only and then finally a
> patch that just moves things around.
>
>> Both are needed if you have to move the code out. functionally, both
>> are equivalent
>
> That's an assumption and we never know when we might have screwed
> the code :) .. And so more careful review of those parts is required :)

True. Will do the same as suggested for the formal series. Thanks for
your feedback and review.

Regards,
Nishanth Menon
