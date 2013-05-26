Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab3EZVi6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 17:38:58 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:37808 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3EZVi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 17:38:57 -0400
Message-ID: <51A280ED.7030209@gmail.com>
Date: Sun, 26 May 2013 17:38:53 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/7] posix-cpu-timers: don't account cpu timer after stopped
 thread runtime accounting
References: <1367556468-4021-1-git-send-email-kosaki.motohiro@gmail.com> <1367556468-4021-3-git-send-email-kosaki.motohiro@gmail.com> <20130506234717.GA1703@somewhere> <CAHGf_=rvYP8jFYHULbJJo4by7eqsPKE_qR+6xcBebLNsMn1=mw@mail.gmail.com> <CAFTL4hxL+Y9GrEd3_EqvUL6P0qDUhCNrDdNQc0ODj8y4aYztxw@mail.gmail.com>
In-Reply-To: <CAFTL4hxL+Y9GrEd3_EqvUL6P0qDUhCNrDdNQc0ODj8y4aYztxw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/7/13 11:24 AM), Frederic Weisbecker wrote:
> 2013/5/7 KOSAKI Motohiro <kosaki.motohiro@gmail.com>:
>>>> +     /*
>>>> +      * After turning over se.sum_exec_runtime to sig->sum_sched_runtime
>>>> +      * in __exit_signal(), we must not account exec_runtime for consistency.
>>>> +      */
>>>> +     if (unlikely(!tsk->sighand))
>>>> +             return;
>>>
>>> Ok, if we want the clock and timer to be consistent, do we also want the same check in
>>> account_group_user_time() and account_group_system_time()? The task can still account
>>> a tick after autoreaping itself between release_task() and the final schedule().
>>
>> You are right.
>>
>> That said, current the man pages don't describe this linux specific
>> extensions. So, nobody
>> (glibc, ltp, and me) tested them. Please give me a couple of days.
>> I'll test and fix this features
>> too.
>>
>> timer_create(2): http://man7.org/linux/man-pages/man2/timer_create.2.html
> 
> Ah, indeed timer_create() seem to only create CPUCLOCK_SCHED timers. So that
> issue with timer_gettime becoming asynchonous with clock_gettime can't happen
> with PROF and VIRT clocks
> 
> I see itimers can use those clocks. But there don't seem to be a
> similar issue with
> getitimer/setitimer as they don't have matching clock reads.

OK. I've found PROF and VIRT clock of posix timer have a bug and I could narrow down
and fixed it. Please see my next iteration.

Thanks.


