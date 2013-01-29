Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3A2Bgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:36:49 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:37696 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3A2Bgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:36:46 -0500
MIME-Version: 1.0
In-Reply-To: <1359417749.17639.6.camel@gandalf.local.home>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	<1359417749.17639.6.camel@gandalf.local.home>
Date: Tue, 29 Jan 2013 02:36:44 +0100
Message-ID: <CAFTL4hxYoQScrdR+bdgat9_qmozMq5oQwo9RRPEbA5UK5NKF4Q@mail.gmail.com>
Subject: Re: [GIT PULL] cputime: Full dynticks task/cputime accounting v7
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/29 Steven Rostedt <rostedt@goodmis.org>:
> On Mon, 2013-01-28 at 20:03 +0100, Frederic Weisbecker wrote:
>> Ingo,
>>
>> Please pull the new full dynticks cputime accounting code that
>> can be found at:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>>       tags/full-dynticks-cputime-for-mingo
>>
>> My last concern is the dependency on CONFIG_64BIT. We rely on cputime_t
>> being u64 for reasonable nanosec granularity implementation. And therefore
>> we need a single instruction fetch to read kernel cpustat for atomicity
>> requirement against concurrent incrementation, which only 64 bit archs
>> can provide.
>>
>> It's probably no big deal to solve this issue. What we need is simply some
>> atomic accessors.
>>
>> There is just no emergency though as this new option depends on the context
>> tracking subsystem that only x86-64 (and soon ppc64) implements yet. And
>> this set is complex enough already. I think we can deal with that later.
>
> I've ran these through some basic tests and I don't see any issues. But
> why did you drop the 'comment' patch that you had in v6?

Because it's coming through paulmck's tree already.

>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Thanks a lot!
