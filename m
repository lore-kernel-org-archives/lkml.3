Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab3LWISF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 03:18:05 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:58098 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3LWISD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 03:18:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpokDBga18BhZm=r+EOoY40=+E7Ndtfooq9rXbqc=wUg2Ng@mail.gmail.com>
References: <CAKohponch=o3nBKTmakA87OiN=HbgnEwJUL23mGkjQiNoJWjWw@mail.gmail.com>
	<20131211132212.GA7862@localhost.localdomain>
	<CAKohponKxw8F6djaXaw0MEzGRWGTSQ=peiYuTGBCOHE0VaJR5Q@mail.gmail.com>
	<87wqj34eqs.fsf@linaro.org>
	<CAKohpo=Btb8ChRJ4Be9gbDE-nOxSaCVkQ_Qg5g7AVRxOMbXEQQ@mail.gmail.com>
	<87r49al12j.fsf@linaro.org>
	<CAKohpokDBga18BhZm=r+EOoY40=+E7Ndtfooq9rXbqc=wUg2Ng@mail.gmail.com>
Date: Mon, 23 Dec 2013 13:48:02 +0530
Message-ID: <CAKohpo=bzfnb6aBDRX6AfjVoRquTaboO5wmiHfjb=bD0bAgBcA@mail.gmail.com>
Subject: Re: [LNG] Re: [Query] Ticks happen in pair for NO_HZ_FULL cores ?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Kevin Hilman <khilman@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Ingo/Peter..

On 18 December 2013 20:03, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 18 December 2013 19:21, Kevin Hilman <khilman@linaro.org> wrote:
>> Ah, I see.  So you're basically asking why we can't evaluate whether to
>> turn off the tick more often, for example right after the workqueues are
>> done.  I suppose Frederic may have some views on that, but there's
>> likely additional overhead from those checks as well as that workqueues
>> may not be the only thing keeping us out of NO_HZ.
>
> I see that sched_switch is called at the end most of the times so an check
> there might be useful ?

Wrong time, probably many people on vacation now. But I am working, so
will continue reporting my problems, in case somebody is around :)

My usecase: I am working on making ARM better for Networking servers.
In our usecase we need to isolate few of the cores in our SoC, so that they
run a single user space task per CPU. And userspace will take care of
data plane side of things for them.

Now, we want to use NO_HZ_FULL with CPUSets (And this is what I have
been trying since sometime), so that we don't get any, any interruption on
those cores. They should keep running that task unless that task tries
to switch to kernel space.

I am getting interrupted by few of the workqueues (other than per-cpu
ones). One of them was bdi writeback one, that we discussed earlier.

I have done some work in the past about Power efficient workqueues
(Mentioned by Tejun few mails back), which used to switch those works
on UNBOUND workqueues and so scheduler would decide on the CPU
it want's to queue those works on.

With an idle CPU, it works fine as scheduler doesn't wake up a idle CPU
for servicing that work.

*But wouldn't it make sense if we can tell scheduler that don't queue
these works on a CPU that is running in NO_HZ_FULL mode?*

Also any suggestions on how to get rid of __prandom_timer events on
such CPUs?

Thanks in Advance..

--
viresh
