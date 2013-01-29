Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab3A2BmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:42:24 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:54880 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3A2BmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:42:22 -0500
MIME-Version: 1.0
In-Reply-To: <0000013c82cc2743-ce9b6845-1fc1-4d61-a887-344b3b88a758-000000@email.amazonses.com>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	<0000013c82983b45-daa2c9db-a8e8-4cc1-a3b8-73613689b144-000000@email.amazonses.com>
	<CAFTL4hzcijbtAGrfjpx6RvYUxc2K95j1VW+CeB3w3Ou2Ptpqpg@mail.gmail.com>
	<0000013c82cc2743-ce9b6845-1fc1-4d61-a887-344b3b88a758-000000@email.amazonses.com>
Date: Tue, 29 Jan 2013 02:42:20 +0100
Message-ID: <CAFTL4hzD1X1anOcnS1shZ+OZR5w+OiS36AYrHGaTJ1FD1-0dYw@mail.gmail.com>
Subject: Re: [GIT PULL] cputime: Full dynticks task/cputime accounting v7
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/28 Christoph Lameter <cl@linux.com>:
> On Mon, 28 Jan 2013, Frederic Weisbecker wrote:
>
>> 2013/1/28 Christoph Lameter <cl@linux.com>:
>> > On Mon, 28 Jan 2013, Frederic Weisbecker wrote:
>> >
>> >> My last concern is the dependency on CONFIG_64BIT. We rely on cputime_t
>> >> being u64 for reasonable nanosec granularity implementation. And therefore
>> >> we need a single instruction fetch to read kernel cpustat for atomicity
>> >> requirement against concurrent incrementation, which only 64 bit archs
>> >> can provide.
>> >
>> > Most x86 cpus support cmpxchg8b on 32bit which can be abused for
>> > 64 bit reads (see cmpxchg64 in cmpxchg_32.h). Simply do a cmpxchg with
>> > zero and use whatever it returns.
>> >
>> > A percpu version that uses the instruction is called
>> > this_cpu_cmpxchg_double().
>>
>> Yeah but we need to be able to do remote read. In fact atomic_read()
>> would do the trick.
>
> Well yes, cmpxchg64() could do the same without the need for an atomic
> variable.

Yeah I'll have a look at this.

>
>> >> There is just no emergency though as this new option depends on the context
>> >> tracking subsystem that only x86-64 (and soon ppc64) implements yet. And
>> >> this set is complex enough already. I think we can deal with that later.
>> >
>> > Ok then this may not be that useful.
>>
>> What is not useful?
>
> The information about the 64 bit reads that I posted.

Ah ok.

Thanks.
