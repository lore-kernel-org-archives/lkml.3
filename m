Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab3FRIkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:40:33 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35596 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab3FRIk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:40:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130618102429.5ff68931@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1371195540-2991-1-git-send-email-l.majewski@samsung.com>
	<1371195540-2991-2-git-send-email-l.majewski@samsung.com>
	<CAKohpokQAsuAqWi7rNx9RaFz8KVRNXVkBD22KC5_Qh05k66qqA@mail.gmail.com>
	<20130617091549.398b865f@amdc308.digital.local>
	<CAKohpo=nfuqwCoQJRczmNRNXCOTL5FSJQEzjKpVdXU+wu-KJ1g@mail.gmail.com>
	<20130617110811.1e1805d2@amdc308.digital.local>
	<CAKohpo=oy3SQXgvNvOydggZ5NZu9yyVtKrdFQjNOGVmzhSaQUw@mail.gmail.com>
	<20130617115809.5206c42c@amdc308.digital.local>
	<CAKohpo=yPcH0FW7T38cd3E1xOpzC0AhJ5mtyVaQyuj_S8iLovw@mail.gmail.com>
	<20130617155156.4c729b5a@amdc308.digital.local>
	<CAKohpo=_=u35wTb-ZUXrR2hNno+ryAqq4gSC3EiJr=-bmgb9JQ@mail.gmail.com>
	<20130618102429.5ff68931@amdc308.digital.local>
Date: Tue, 18 Jun 2013 14:10:28 +0530
Message-ID: <CAKohpo=Th-V4+i7r0+EoDL2fvoy-vMZrRa7wg5mJSQ7HjK_0YQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] cpufreq: Add boost frequency support in core
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 June 2013 13:54, Lukasz Majewski <l.majewski@samsung.com> wrote:
> On Tue, 18 Jun 2013 08:42:13 +0200, Viresh Kumar wrote:

>> Its not about how long.. One cpu type can work longer with boost freq
>> compared to other.
>>
>> What we probably need is:
>> - Enabled boost from sysfs if required (now below steps will come into
>>   picture)
>> - See how many cpus are running, if only one then start using boost
>> freqs
>
> You are right here.
>
> I'd like to propose following solution:
> 1. For acpi (where boost_enable come into play) - do not consider
> number of active cpus (this is done in HW anyway)
>
> 2. For SW solution evaluate how many CPUs are running. If only one is
> running then allow enabling boost from sysfs.

Looks fine.

> But following situation is also possible: User enable boost when one
> core is only running and then for some reason other core is woken up.
> What shall be done then?
> Shall we then disable boost immediately when cpufreq detects that
> more than one core is running? Or leave this situation to be handled by
> thermal subsystem?

Obviously disable boost ASAP. Every SoC might not have a thermal
framework glue to do it.

> As a side note:
> Logic proposed at point 2, is already implemented at LAB
> (enable LAB only when one core is running and disable it when more
> than one come into play).

Hmm.. So, eventually that will go away now :)

>> - Now thermal should be come into picture to save chip in case a
>> single cpu running at boost can burn it out.
>
> I will extent v4 to embrace code which switches off boost at thermal.

Gud.
