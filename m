Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaKRNcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:32:15 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37079 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbaKRNcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:32:14 -0500
MIME-Version: 1.0
In-Reply-To: <20141117143945.25d4d7d0@gandalf.local.home>
References: <1416240664-7200-1-git-send-email-pang.xunlei@linaro.org>
	<20141117143945.25d4d7d0@gandalf.local.home>
Date: Tue, 18 Nov 2014 21:32:13 +0800
Message-ID: <CADcy93Ve8LogFqTz6_nev43CrrtCqgP23_-Twpze6L3V1rnkbw@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched/deadline: Modify cpudl.free_cpus to reflect rd->span
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 November 2014 03:39, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 18 Nov 2014 00:11:03 +0800
>
>> index 539ca3c..9a69353
>> --- a/kernel/sched/cpudeadline.c
>> +++ b/kernel/sched/cpudeadline.c
>> @@ -107,7 +107,9 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
>>       int best_cpu = -1;
>>       const struct sched_dl_entity *dl_se = &p->dl;
>>
>> -     if (later_mask && cpumask_and(later_mask, later_mask, cp->free_cpus)) {
>> +     if (later_mask && cpumask_and(later_mask, cp->free_cpus,
>> +                     &p->cpus_allowed) && cpumask_and(later_mask,
>> +                     later_mask, cpu_active_mask)) {
>
> I did a quick review of this patch, and it looks fine to me. But the
> above looks ugly. Please change it to something more readable like:

Yes, the following looks beautiful. I'll adjust it, thanks!
>
>         if (later_mask &&
>             cpumask_and(later_mask, cp->free_cpus, &p->cpus_allowed) &&
>             cpumask_and(later_mask, later_mask, cpu_active_mask)) {
>
> Thanks,
>
> -- Steve
>
>
>>               best_cpu = cpumask_any(later_mask);
>>               goto out;
>>       } else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
>> @@ -186,6 +188,17 @@ out:
>>  }
>>
>
