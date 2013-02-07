Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136Ab3BGRSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:18:07 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:38026 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759101Ab3BGRSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:18:05 -0500
MIME-Version: 1.0
In-Reply-To: <1360256447.2621.75.camel@gandalf.local.home>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
	<1360205415.2621.60.camel@gandalf.local.home>
	<CAFTL4hzJ9FLNTqiBdB0SCWvxgN=p=M54e1PNWe6cp+C9A=DXxA@mail.gmail.com>
	<1360256447.2621.75.camel@gandalf.local.home>
Date: Thu, 7 Feb 2013 18:18:03 +0100
Message-ID: <CAFTL4hzXe=rYniSrth--n2Vp+wEYRt69r9+SPFu-Bac-_ZwM3Q@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/7 Steven Rostedt <rostedt@goodmis.org>:
> On Thu, 2013-02-07 at 17:41 +0100, Frederic Weisbecker wrote:
>
>> I'm not convinced that "single task" must be a fundamental component
>> of this. It's an implementation detail. We should be able to keep the
>> tick off in the future when more than one task are on the runqueue and
>> hrtick is on. May be this will never show up as a performance gain but
>> we don't know yet.
>>
>> Ok let's talk about that single task constraint in the Kconfig help so
>> that the user knows the practical constraint as of today. But I
>> suggest we keep that as an internal detail that we can deal with in
>> the future.
>
> Hmm, but isn't time slices still implemented by ticks?

Not with hrtick.

> I would think
> implementing multiple tasks would be another huge change.

I don't think so. Really hrtick should take of everything.

>
> Maybe have:
>
> NO_HZ_IDLE
> NO_HZ_SINGLE_TASK
> NO_HZ_MULTI_TASK
> NO_HZ_COMPLETE

I still see single task, multitask or complete as implementation
constraints. Once we make hrtick support dynticks, it should be
dynamically handled: if hrtick is enabled then stop the tick even on
multitask, otherwise only stop it when we have one task.

Then when we remove jiffies, the complete coverage comes along.

>
> And as Ingo has suggested, maybe in the future we can remove SINGLE and
> MULTI and have just COMPLETE.

But really, turning these constraints into single built-in optable
choices doesn't make much sense to me.

> But anyway, the current method has a strict requirement of a single
> task, and that is user visible. I would want to keep the config name
> implying that requirement.

As long as it's specified in the Kconfig help, does it matter? It''s a
constraint amongst many others: you need to keep one CPU with a
periodic tick, you need to avoid posix cpu timers, etc...
