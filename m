Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322Ab3EGC6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:58:03 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:44225 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213Ab3EGC6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:58:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130506234717.GA1703@somewhere>
References: <1367556468-4021-1-git-send-email-kosaki.motohiro@gmail.com>
 <1367556468-4021-3-git-send-email-kosaki.motohiro@gmail.com> <20130506234717.GA1703@somewhere>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 6 May 2013 22:57:38 -0400
Message-ID: <CAHGf_=rvYP8jFYHULbJJo4by7eqsPKE_qR+6xcBebLNsMn1=mw@mail.gmail.com>
Subject: Re: [PATCH 1/7] posix-cpu-timers: don't account cpu timer after
 stopped thread runtime accounting
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +     /*
>> +      * After turning over se.sum_exec_runtime to sig->sum_sched_runtime
>> +      * in __exit_signal(), we must not account exec_runtime for consistency.
>> +      */
>> +     if (unlikely(!tsk->sighand))
>> +             return;
>
> Ok, if we want the clock and timer to be consistent, do we also want the same check in
> account_group_user_time() and account_group_system_time()? The task can still account
> a tick after autoreaping itself between release_task() and the final schedule().

You are right.

That said, current the man pages don't describe this linux specific
extensions. So, nobody
(glibc, ltp, and me) tested them. Please give me a couple of days.
I'll test and fix this features
too.

timer_create(2): http://man7.org/linux/man-pages/man2/timer_create.2.html
