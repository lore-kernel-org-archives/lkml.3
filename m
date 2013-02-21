Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab3BUKgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:36:24 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:36438 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab3BUKgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:36:22 -0500
Message-ID: <5125F87B.7020205@parallels.com>
Date: Thu, 21 Feb 2013 14:35:39 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Matthew Helsley <matt.helsley@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] posix timers: Extend kernel API to report more info
 about timers
References: <511D0E50.7090505@parallels.com> <CA+RrjuURQTCP8yMa4nWxNQg=qxxsu6vrko2UVK4f8pFYbK6SYQ@mail.gmail.com>
In-Reply-To: <CA+RrjuURQTCP8yMa4nWxNQg=qxxsu6vrko2UVK4f8pFYbK6SYQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 05:21 AM, Matthew Helsley wrote:
> On Thu, Feb 14, 2013 at 8:18 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
>> Hi.
>>
>> I'm working on the checkpoint-restore project (http://criu.org), briefly
>> it's aim is to collect information about process' state and saving it so
>> that later it is possible to recreate the processes in the very same state
>> as they were, using the collected information.
>>
>> One part of the task's state is the posix timers that this task has created.
>> Currently kernel doesn't provide any API for getting information about
>> what timers are currently created by process and in which state they are.
>> I'd like to extend the posix timers API to provide more information about
>> timers.
>>
>> Another problem with timers is the timer ID. Currently IDs are generated
>> from global IDR and this makes it impossible to restore a timer from
>> the saved state in general, as the required ID may be already busy at the
>> time of restore.
>>
>> That said, I propose to
>>
>> 1. Change the way timer IDs are generated. This was done some time ago, so
>>    I'm just re-sending this patch;
> 
> Seems fine in principle. Aside: I noticed there were some
> important-looking patches to the idr usage in timer id allocation
> today...

Hm, OK, will try to find one.

>> 2. Add a system call that will list timer IDs created by the calling process;
> 
> If timers were listed in /proc like fds then you wouldn't need this
> syscall. If we keep adding new syscalls like this CRIU will be
> needlessly x86-specific when it could have been written more portably.
> 
>> 3. Add a system call that will allow to get the sigevent information about
>>    particular timer in the sigaction-like manner.
> 
> You mentioned "extending the POSIX timer API". Isn't that something
> best left to standards bodies lest your changes conflict with theirs?
> Again, if this were a /proc interface you wouldn't have that issue
> (you'll have others ;)).
> 
>>
>> This is actually an RFC to start discussion about how the described problems
>> can be addressed. Thus, if the approach with new system calls is not acceptable,
>> I'm OK to implement this in any other form.
> 
> My preference is for "other form" for the reasons above.

No problem, proc is OK for me as well. I will look at what can be done here.

Thanks for the feedback!

> Cheers,
>     -Matt Helsley
> .
> 


