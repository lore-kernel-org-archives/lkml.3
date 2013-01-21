Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3AUFpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 00:45:36 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:37874 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3AUFpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 00:45:34 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <2007041.tOt4VKpdOD@vostro.rjw.lan>
References: <1358538755-29109-1-git-send-email-nm@ti.com>
	<2007041.tOt4VKpdOD@vostro.rjw.lan>
Date: Mon, 21 Jan 2013 14:45:32 +0900
X-Google-Sender-Auth: LVg3ipIyYeKW_7v5Tur84iXel6E
Message-ID: <CAJ0PZbS6Ka7ZNJ+a4kXW89dYgwASWA_3pYQFPFtTNv8DwwQzLw@mail.gmail.com>
Subject: Re: [PATCH 0/4] OPP usage fixes for RCU locking
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nishanth Menon <nm@ti.com>, linux-pm <linux-pm@vger.kernel.org>,
        Kevin <khilman@deeprootsystems.com>,
        lkml <linux-kernel@vger.kernel.org>, lo <linux-omap@vger.kernel.org>,
        Jack <jack@embed.me.uk>, Alexander <holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 7:28 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, January 18, 2013 01:52:31 PM Nishanth Menon wrote:
>> Hi,
>> Despite being documented in function documentation and in
>> Documentation/power/opp.txt, many of the users of OPP APIs
>> dont honor RCU lock usage appropriately.
>>
>> This recently appeared in IRC discussion earlier today [1].
>> I did an audit of current usage and the following series
>> is a result of this.
>>
>> NOTE:
>> 1. The patch "PM / devfreq: exynos4_bus: honor RCU lock usage" has only
>>    been build tested as I dont have an exynos platform to try it on. I have
>>    tried to make it as least intrusive as possible and at least reviewed
>>    to ensure I haven't screwed anything up.
>>
>> Other than this, I have added appropriate tested by information in requisite
>> patches.
>
> Thanks for the fixes.
>
> MyungJoo, do you want me to take the devfreq ones too?
>
> Rafael

Yes, please take RCU-OPP patches. Having those patches splitted
doesn't seem beneficial.

I'll let other devfreq patches be based on this after you get them applied.




Cheers,
MyungJoo

>
>
>> Series is based off: v3.8-rc4 tag
>> Also available in the following location[2]:
>> https://github.com/nmenon/linux-2.6-playground branch: post/pm/opp-fixes-v1
>>
>> Nishanth Menon (4):
>>   cpufreq: OMAP: use RCU locks around usage of OPP
>>   cpufreq: cpufreq-cpu0: use RCU locks around usage of OPP
>>   PM / devfreq: add locking documentation for recommend_opp
>>   PM / devfreq: exynos4_bus: honor RCU lock usage
>>
>>  drivers/cpufreq/cpufreq-cpu0.c |    5 +++
>>  drivers/cpufreq/omap-cpufreq.c |    3 ++
>>  drivers/devfreq/devfreq.c      |    5 +++
>>  drivers/devfreq/exynos4_bus.c  |   94 ++++++++++++++++++++++++++++------------
>>  4 files changed, 80 insertions(+), 27 deletions(-)
>>
>> [1] http://www.beagleboard.org/irclogs/index.php?date=2013-01-18#T14:14:07
>> [2] https://github.com/nmenon/linux-2.6-playground/commits/post/pm/opp-fixes-v1
>>
>> Regards,
>> Nishanth Menon
>>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
