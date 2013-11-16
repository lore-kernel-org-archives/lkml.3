Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab3KPEdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 23:33:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:25412 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab3KPEdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 23:33:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="409722457"
Message-ID: <5286F57F.6000908@intel.com>
Date: Sat, 16 Nov 2013 12:33:03 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: Re: [Update PATCH 1/1] Cpufreq: Make governor data on nonboot cpus
 across system suspend/resume
References: <1384495294-10565-1-git-send-email-tianyu.lan@intel.com> <1384503334-18809-1-git-send-email-tianyu.lan@intel.com> <CAKohpokjtaCJj3QCDyoQ+1UviLX8ZSnpWk05Jh4U02pmrq897g@mail.gmail.com>
In-Reply-To: <CAKohpokjtaCJj3QCDyoQ+1UviLX8ZSnpWk05Jh4U02pmrq897g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 06:22 PM, Viresh Kumar wrote:
> On 15 November 2013 13:45, Lan Tianyu <tianyu.lan@intel.com> wrote:
>> Currently, governor of nonboot cpus will be put to EXIT when system suspend.
>> Since all these cpus will be unplugged and the governor usage_count decreases
>> to zero. The governor data and its sysfs interfaces will be freed or released.
>> This makes user config of these governors loss during suspend and resume.
>>
>> This doesn't happen on the governor covering boot cpu because it isn't
>> unplugged during system suspend.
>>
>> To fix this issue, skipping governor exit during system suspend and check
>> policy governor data to determine whether the governor is really needed
>> to be initialized when do init. If not, return EALREADY to indicate the
>> governor has been initialized and should do nothing. __cpufreq_governor()
>> convert EALREADY to 0 as return value for INIT event since governor is
>> still under INIT state and can do START operation.
>>
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>> ---
>
> Hi Lan..
>

Hi Viresh:

> Apologies!!
>
> I already had a solution for this as this was reported by few Broadcom people
> as well. But I haven't send it to mainline yet as it was untested. It
> looked similar
> to what you had..
>
> And so I would have taken your patch (as you have sent it first to the list and
> there is no real advantage of my patch over yours, they were almost same) :)
>
> But then I went chasing another bug posted by Nishant:
>
> https://lkml.org/lkml/2013/10/24/369
>
> And the final solution I have to write solved all the problems you and he
> reported.
>
> Please have a look at that patch (you are cc'd) and give it a try to see
> if it fixes your problem..

Never mind. I think it should work and will try it.

>
> Btw, One question about your setup:
> - you must have a multi cluster/socket SoC as you have atleast one more
> policy structure than used for group containing boot cpu..

Actually, I test on a laptop and find this issue when reading code to 
fix other bug. :)

All cpus have their own policys.

> - Are you using separate governor for both groups?

Just to produce the bug, I set one non-boot cpu to conservative gov. All 
other remain default "ondemand".

> - Or are you using CPUFREQ_HAVE_GOVERNOR_PER_POLICY stuff
> to use same governor with separate tunables for both groups?
>

No, I am not using this.

> Just wanted to know if somebody else is also using
> CPUFREQ_HAVE_GOVERNOR_PER_POLICY :)
>


-- 
Best Regards
Tianyu Lan
