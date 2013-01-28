Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3A1TSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 14:18:04 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:57555 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144Ab3A1TSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:18:02 -0500
Date: Mon, 28 Jan 2013 19:18:00 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
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
Subject: Re: [GIT PULL] cputime: Full dynticks task/cputime accounting v7
In-Reply-To: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
Message-ID: <0000013c82983b45-daa2c9db-a8e8-4cc1-a3b8-73613689b144-000000@email.amazonses.com>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Frederic Weisbecker wrote:

> My last concern is the dependency on CONFIG_64BIT. We rely on cputime_t
> being u64 for reasonable nanosec granularity implementation. And therefore
> we need a single instruction fetch to read kernel cpustat for atomicity
> requirement against concurrent incrementation, which only 64 bit archs
> can provide.

Most x86 cpus support cmpxchg8b on 32bit which can be abused for
64 bit reads (see cmpxchg64 in cmpxchg_32.h). Simply do a cmpxchg with
zero and use whatever it returns.

A percpu version that uses the instruction is called
this_cpu_cmpxchg_double().

> There is just no emergency though as this new option depends on the context
> tracking subsystem that only x86-64 (and soon ppc64) implements yet. And
> this set is complex enough already. I think we can deal with that later.

Ok then this may not be that useful.

