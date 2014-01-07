Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbaAGIzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:55:46 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:40202 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaAGIzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:55:45 -0500
MIME-Version: 1.0
In-Reply-To: <20140107084734.GP30183@twins.programming.kicks-ass.net>
References: <CAKohponch=o3nBKTmakA87OiN=HbgnEwJUL23mGkjQiNoJWjWw@mail.gmail.com>
	<20131211132212.GA7862@localhost.localdomain>
	<CAKohponKxw8F6djaXaw0MEzGRWGTSQ=peiYuTGBCOHE0VaJR5Q@mail.gmail.com>
	<87wqj34eqs.fsf@linaro.org>
	<CAKohpo=Btb8ChRJ4Be9gbDE-nOxSaCVkQ_Qg5g7AVRxOMbXEQQ@mail.gmail.com>
	<87r49al12j.fsf@linaro.org>
	<CAKohpokDBga18BhZm=r+EOoY40=+E7Ndtfooq9rXbqc=wUg2Ng@mail.gmail.com>
	<CAKohpo=bzfnb6aBDRX6AfjVoRquTaboO5wmiHfjb=bD0bAgBcA@mail.gmail.com>
	<20140107084734.GP30183@twins.programming.kicks-ass.net>
Date: Tue, 7 Jan 2014 14:25:44 +0530
Message-ID: <CAKohpon7Vf=zHt5OBpf=LCaj9GVW8F34Tx3ypEbP6DDOHD+ugA@mail.gmail.com>
Subject: Re: [LNG] Re: [Query] Ticks happen in pair for NO_HZ_FULL cores ?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kevin Hilman <khilman@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 January 2014 14:17, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Dec 23, 2013 at 01:48:02PM +0530, Viresh Kumar wrote:
>> *But wouldn't it make sense if we can tell scheduler that don't queue
>> these works on a CPU that is running in NO_HZ_FULL mode?*
>
> No,.. that's the wrong way around.

Hmm.. Just to make it clear I didn't meant that any input from workqueue
code should go to scheduler but something like this:

Scheduler will check following before pushing a task on any CPU:
- If that CPU is part of NO_HZ_FULL cpu list?
- If yes, is that CPU running only one task for now? i.e. running task for
best performance case?
- If yes, then don't queue new task to that CPU, whether task belongs to
workqueue or not doesn't matter.

> That looks to be a normal unpinned timer, it should migrate to a 'busy'
> cpu once the one its running on it going idle.
>
> ISTR people trying to make that active and also migrating on nohz full
> or somesuch, just like the workqueues. Forgot what happened with that;
> if it got dropped it should probably be ressurected.

I will search for that in archives..
