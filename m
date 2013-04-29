Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364Ab3D2Shv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:37:51 -0400
Received: from mail-gh0-f173.google.com ([209.85.160.173]:56247 "EHLO
	mail-gh0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759336Ab3D2Shr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:37:47 -0400
Message-ID: <517EBC71.4070709@gmail.com>
Date: Mon, 29 Apr 2013 14:31:13 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Olivier Langlois <olivier@trillion01.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] process cputimer is moving faster than its corresponding
 clock
References: <1365184746.874.103.camel@Wailaba2>  <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>  <1365763837.17140.52.camel@laptop> <1365782115.17140.68.camel@laptop>  <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>  <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>  <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>  <1366951210.7911.28.camel@Wailaba2> <1366957639.7911.42.camel@Wailaba2>  <517AD0AE.1030404@gmail.com> <1367037606.7911.66.camel@Wailaba2>  <517DFFE9.4050808@gmail.com> <1367255407.8833.4.camel@Wailaba2>  <517EB45D.60007@gmail.com> <1367259631.8833.27.camel@Wailaba2>
In-Reply-To: <1367259631.8833.27.camel@Wailaba2>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/29/13 2:20 PM), Olivier Langlois wrote:
> 
>>
>>>> I'm confused. glibc's rt/tst-cputimer1 doesn't have thread exiting code. I have
>>>> no seen any issue in this accounting.
>>>
>>> glibc launch a helper thread to receive timer signal and will also
>>> create a new thread upon signal reception when a timer is created with
>>> sigev_notify = SIGEV_THREAD;
>>>
>>> please see:
>>>
>>> glibc-2.17/nptl/sysdeps/unix/sysv/linux/timer_create.c
>>> glibc-2.17/nptl/sysdeps/unix/sysv/linux/timer_routines.c
>>
>> I know. I taled thread exiting. not thread creating. And, as far as I can see, only test sig1 can fail,
>> not thr[12].
>>
> Apart from glibc helper thread, the threads created for handling timer
> firing all do exit immediatly as soon as user callback returns.

And, libc ensure its exiting finished before starting actual tests. Why such thread exiting
affect timers code? It shouldn't. becuase signal.cputimer is initialized timer_settime().
The initialization is incorrect, we should fix initialization.


> I count 12 thread exits during tst-cputimer1 execution. The errors do
> add up hence you're more likely to see errors after 2.5 sec and up from
> start of execution. I have seen sig1, thr[12] fails. I see no reason why
> one could not fail.




