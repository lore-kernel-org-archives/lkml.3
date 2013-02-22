Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab3BVCO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:14:26 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:63167 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab3BVCOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:14:24 -0500
MIME-Version: 1.0
In-Reply-To: <2852709.b79tkCt2uQ@vostro.rjw.lan>
References: <cover.1360568193.git.viresh.kumar@linaro.org>
	<0289db340545c87d8e4aac7184dd91177eeb9a43.1360568193.git.viresh.kumar@linaro.org>
	<2852709.b79tkCt2uQ@vostro.rjw.lan>
Date: Fri, 22 Feb 2013 07:44:23 +0530
Message-ID: <CAKohpompwGaJziPcrwqH2pUgpiOPa1is_z0506+hO06FXQ8MFA@mail.gmail.com>
Subject: Re: [PATCH V2 3/4] cpufreq: Add Kconfig option to enable/disable have_multiple_policies
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-dev@lists.linaro.org,
        francescolavra.fl@gmail.com, toddpoynor@google.com,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 February 2013 05:23, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, February 11, 2013 01:20:02 PM Viresh Kumar wrote:

>> +config CPU_FREQ_HAVE_MULTIPLE_POLICIES
>> +     bool
>> +
>
> So I suppose some architectures will select this, right?

Yes. And they have to enable have_multiple_policies too from their
drivers init code.

> What architecture they are?

Atleast all big.LITTLE SoCs. Or any other SoC that has multiple policy
structs alive at any time.


> I'm not really sure I like this. ->

>>  static inline struct kobject *
>>  get_governor_parent_kobj(struct cpufreq_policy *policy)
>>  {
>> +#ifdef CONFIG_CPU_FREQ_HAVE_MULTIPLE_POLICIES
>>       if (policy->have_multiple_policies)
>>               return &policy->kobj;
>>       else
>> +#endif
>>               return cpufreq_global_kobject;
>
> -> I wonder why don't you arrange things so that policy->kobj is always
> returned, but it points to cpufreq_global_kobject in case there's only one
> (i.e. make policy->kobj a pointer)?

policy->kobj is a struct instance rather than a pointer and it is widely used
within cpufreq.c. If you don't like this one then we can add another entry
into struct policy like: gov_sysfs_parent.
