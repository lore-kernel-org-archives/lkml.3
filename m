Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3AaQ3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:29:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52985 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3AaQ3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:29:51 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUXeUE24MkUg_4hVKvi54EUWGM43hOMz_A8sLJ46Xzgp+g@mail.gmail.com>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	<1359399845-10568-9-git-send-email-fweisbec@gmail.com>
	<CA+icZUWdGCytVsNKK+gA7Sh-RKT-GPCHoRtPNfDw4_Hfh+ynyA@mail.gmail.com>
	<CAFTL4hyzAR0ztncwA0Hx=9P4MKYgUp1Uro8Lt2VjYPdM5Bd1Qg@mail.gmail.com>
	<CA+icZUWJSZT+TUMynsFKd-_3x-TMB=NeK+6f2cWsi6-g82rWKA@mail.gmail.com>
	<CAFTL4hyBhnPL3NkN=V+6pUQr9jQN6E+XREq0y+A6-fVQW4V5bQ@mail.gmail.com>
	<CA+icZUXeUE24MkUg_4hVKvi54EUWGM43hOMz_A8sLJ46Xzgp+g@mail.gmail.com>
Date: Thu, 31 Jan 2013 17:29:50 +0100
Message-ID: <CAFTL4hwHfVBmxJ4AJG1RcQrWo7PB=+DTbtf5wx9NSBKRrniu4w@mail.gmail.com>
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
> I still dunno all parts of dynticks and their correlation.
> AFAICS they seem to be independent, can't say if it is "complete" with
> dynticks-cputime-only.

Dynticks cputime and dynticks printk are both standalone and
independant. In mainline, both printk and cputime accounting rely on
the tick. With these two patchsets we can now use these without the
tick.

But that's not enough to shut down the timer safely. There are still
some other subsystems that depend on the tick: posix cpu timers, perf
events, scheduler, RCU (although RCU is mostly handled now),
timekeeping....
Quite some of these subsystems are handled in my nohz tree
(https://lwn.net/Articles/533677/) which also contains the code that
actually shutdown the tick when possible.

>
> Was that dynticks stuff ever advertised for Linux-Next inclusion?

No, the code is not yet clean and complete enough for -next.

> Or wnt through any "mingo-next" tree?
> AFAICS, better chances these ways!

So indeed, I'm trying to get the things merged by Ingo. And for that I
try to cut my tree into individual features (tickless printk, tickless
cputime accounting, next step is probably posix cpu timers, ...).
Cutting things that way makes them much easier to review and merge. In
the meantime I continue to release my full dynticks tree (such as
3.8-rc4-nohz3): this is where I experiment the next remaining pieces
to handle in the future, it's mostly a draft.
