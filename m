Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3LRVaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:30:00 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53365 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3LRV35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:29:57 -0500
Message-ID: <52B213D1.1000104@mit.edu>
Date: Wed, 18 Dec 2013 13:29:53 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, Alex Shi <alex.shi@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [RFC PATCH 00/13] nohz: Use sysidle detection to let the timekeeper
 sleep
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com> <52B102BB.1050907@linaro.org> <20131218174355.GA19788@localhost.localdomain>
In-Reply-To: <20131218174355.GA19788@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 09:43 AM, Frederic Weisbecker wrote:
> On Wed, Dec 18, 2013 at 10:04:43AM +0800, Alex Shi wrote:
>> On 12/18/2013 06:51 AM, Frederic Weisbecker wrote:
>>> So this is what this series brings, more details following:
>>>
>>> * Some code, naming and whitespace cleanups
>>>
>>> * Allow all CPUs outside the nohz_full range to handle the timekeeping
>>>   duty, not just CPU 0. Balancing the timekeeping duty should improve
>>>   powersavings.
>>
>> If the system just has one nohz_full cpu running, it will need another
>> cpu to do timerkeeper job. Then the system roughly needs 2 cpu living.
>> From powersaving POV, that is not good compare to normal nohz idle.
> 
> Sure, but everything has a tradeoff :)
> 
> We could theoretically run with the timekeeper purely idle if the other
> CPU in full dynticks mode runs in userspace for a long while and seldom
> do syscalls and faults. Timekeeping could be updated on kernel/user
> boundaries in this case without much impact on performances.
> 
> But then there is one strict condition for that: it can't read the timeofday
> through the vdso but only through a syscall.

Where's your ambition? :)

If the vdso timing functions could see that it's been too long since a
real timekeeping update, they could fall back to a syscall.  Otherwise,
they could using rdtsc or whatever is in use.

--Andy
