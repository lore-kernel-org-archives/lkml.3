Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3AaKMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:12:48 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:51761 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab3AaKMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:12:45 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUWJSZT+TUMynsFKd-_3x-TMB=NeK+6f2cWsi6-g82rWKA@mail.gmail.com>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	<1359399845-10568-9-git-send-email-fweisbec@gmail.com>
	<CA+icZUWdGCytVsNKK+gA7Sh-RKT-GPCHoRtPNfDw4_Hfh+ynyA@mail.gmail.com>
	<CAFTL4hyzAR0ztncwA0Hx=9P4MKYgUp1Uro8Lt2VjYPdM5Bd1Qg@mail.gmail.com>
	<CA+icZUWJSZT+TUMynsFKd-_3x-TMB=NeK+6f2cWsi6-g82rWKA@mail.gmail.com>
Date: Thu, 31 Jan 2013 11:12:43 +0100
Message-ID: <CAFTL4hyBhnPL3NkN=V+6pUQr9jQN6E+XREq0y+A6-fVQW4V5bQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] cputime: Safely read cputime of full dynticks CPUs
From: Frederic Weisbecker <fweisbec@gmail.com>
To: sedat.dilek@gmail.com
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/31 Sedat Dilek <sedat.dilek@gmail.com>:
> On Thu, Jan 31, 2013 at 1:38 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> 2013/1/28 Sedat Dilek <sedat.dilek@gmail.com>:
>>> On Mon, Jan 28, 2013 at 8:04 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>>> While remotely reading the cputime of a task running in a
>>>> full dynticks CPU, the values stored in utime/stime fields
>>>> of struct task_struct may be stale. Its values may be those
>>>> of the last kernel <-> user transition time snapshot and
>>>> we need to add the tickless time spent since this snapshot.
>>>>
>>>> To fix this, flush the cputime of the dynticks CPUs on
>>>> kernel <-> user transition and record the time / context
>>>> where we did this. Then on top of this snapshot and the current
>>>> time, perform the fixup on the reader side from task_times()
>>>> accessors.
>>>>
>>>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: Ingo Molnar <mingo@kernel.org>
>>>> Cc: Li Zhong <zhong@linux.vnet.ibm.com>
>>>> Cc: Namhyung Kim <namhyung.kim@lge.com>
>>>> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>>> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>>> Cc: Steven Rostedt <rostedt@goodmis.org>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> [fixed kvm module related build errors]
>>>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>>>>
>>>
>>> Can you explain a bit what is the difference between "3.8-rc4-nohz3"
>>> and "full-dynticks-cputime-for-mingo" patchsets?
>>
>> 3.8-rc4-nohz3 is the latest experimental tree that implements full
>> dynticks. It includes an earlier version of full dynticks cputime and
>> many other things to make the full dynticks possible: nohz printk,
>> many tweaks on the scheduler and timers...etc
>>
>
> So, dynticks-cputime will go into 3.9?

I can't say "will" but I hope.

> What about the other parts? Coming later?

May be the printk part will go into 3.9. Linus ignored my pull request
so may be we'll get more chances if it goes through Ingo.

And the rest will come later.
