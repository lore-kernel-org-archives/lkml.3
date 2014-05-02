Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaEBFXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 01:23:03 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46070 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaEBFXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 01:23:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAGo_u6ohKZh+zKWSzGbvT+AKgnhSjzX7v9isqpd2pc-Cpmxocg@mail.gmail.com>
References: <1398992810-14957-1-git-send-email-nm@ti.com>
	<CAKohpokEuZ69HnnKE89maXk=21cgAMjEYjEvEcaoBpg4bLRsGg@mail.gmail.com>
	<CAGo_u6ohKZh+zKWSzGbvT+AKgnhSjzX7v9isqpd2pc-Cpmxocg@mail.gmail.com>
Date: Fri, 2 May 2014 10:52:59 +0530
Message-ID: <CAKohponv-p20=www51rW13RSG6=ACgDrRDfL9Xd26ePgjkpWfA@mail.gmail.com>
Subject: Re: [RFC PATCH] PM / OPP: move cpufreq specific OPP functions out of
 generic OPP library
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
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

On 2 May 2014 10:48, Nishanth Menon <nm@ti.com> wrote:
> On Thu, May 1, 2014 at 11:30 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>> diff --git a/drivers/cpufreq/cpufreq_opp.c b/drivers/cpufreq/cpufreq_opp.c
>>> new file mode 100644
>>> index 0000000..2602ff8
>>> --- /dev/null
>>> +++ b/drivers/cpufreq/cpufreq_opp.c
>>> @@ -0,0 +1,102 @@
>>> +/*
>>> + * Generic OPP Interface for CPUFREQ drivers
>>> + *
>>> + * Copyright (C) 2009-2014 Texas Instruments Incorporated.
>>> + *     Nishanth Menon
>>> + *     Romit Dasgupta
>>> + *     Kevin Hilman
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>
>> I hope you have just copy pasted routines to this file, and haven't done
>> even the most minor modification in those, as its hard to review it.
>
> there is code replacement ofcourse ->
> * the logic of walking down the list holding a mutex has been replaced
> with rcu locks,
> * instead of reading internal data structure and generating the list,
> use the existing search API that does exactly the same.
> * Documentation update for the same.

Hmm, actually if I would have written this patch, then probably I would
have done the same thing, but looking from the reviewers perspective,
it would be much more easy if we can separate things into patches.

So, maybe do these changes first in opp.c only and then finally a
patch that just moves things around.

> Both are needed if you have to move the code out. functionally, both
> are equivalent

That's an assumption and we never know when we might have screwed
the code :) .. And so more careful review of those parts is required :)

>>> diff --git a/drivers/cpufreq/cpufreq_opp.h b/drivers/cpufreq/cpufreq_opp.h
>>
>> Two problems, driver may lie in arch/ as well, though we don't recommend
>> them, secondly move these in cpufreq.h, don't need a header here for sure.
>
> There are none at the moment. ideally, we'd like to discourage folks

Yes, we do. :)

> putting cpufreq drivers in arch/ given the amount of effort you have
> undertaken in bringing them all here. but I have personally no strong
> objection to getting rid of the private header and using the generic
> cpufreq header.
>
> Otherwise, I assume you are ok with this approach and will post a
> formal patch by monday.

Yep.
