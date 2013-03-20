Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab3CTAZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:25:25 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:64905 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab3CTAZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:25:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130319154326.f8fd35776086c66617a08c90@linux-foundation.org>
References: <1363366442-11494-1-git-send-email-fweisbec@gmail.com>
	<1363366442-11494-2-git-send-email-fweisbec@gmail.com>
	<20130319154326.f8fd35776086c66617a08c90@linux-foundation.org>
Date: Wed, 20 Mar 2013 01:25:22 +0100
Message-ID: <CAFTL4hyOc62OJ6+-VRyLw8_6R4pWrNHw2k2y=U9HrAEKN8Zjww@mail.gmail.com>
Subject: Re: [PATCH 1/4] posix_cpu_timer: Consolidate expiry time type
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/19 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 15 Mar 2013 17:53:59 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> The posix cpu timer expiry time is stored in a union of
>> two types: a 64 bits field if we rely on scheduler precise
>> accounting, or a cputime_t if we rely on jiffies.
>>
>> This result in quite some duplicate code and special cases
>> to handle the two types.
>>
>> Just unify this into a single 64 bits field. cputime_t can
>> always fit into it.
>>
>
> x86_64 allnoconfig:
>
> kernel/posix-cpu-timers.c: In function 'posix_cpu_timer_schedule':
> kernel/posix-cpu-timers.c:1127: warning: 'now' may be used uninitialized in this function
>
> It looks like it's always been buggy, but your switch from `union
> cou_time_count' to `unsigned long long' made gcc notice it.

Ok, from a quick view it seems what's missing is a call to
cpu_timer_sample_group() to compute the residual time for further call
of timer_gettime(). I'll look at it deeper and send you a fix.

Thanks.
