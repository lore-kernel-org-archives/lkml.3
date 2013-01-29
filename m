Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3A2ACu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 19:02:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3544 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab3A2ACs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 19:02:48 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=9Wk9NYerj9wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=O1YP5waFyKMA:10 a=VwQbUJbxAAAA:8 a=1DEZ-KsVtZKxAn39NgcA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359417749.17639.6.camel@gandalf.local.home>
Subject: Re: [GIT PULL] cputime: Full dynticks task/cputime accounting v7
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Date: Mon, 28 Jan 2013 19:02:29 -0500
In-Reply-To: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 20:03 +0100, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the new full dynticks cputime accounting code that
> can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	tags/full-dynticks-cputime-for-mingo
> 
> My last concern is the dependency on CONFIG_64BIT. We rely on cputime_t
> being u64 for reasonable nanosec granularity implementation. And therefore
> we need a single instruction fetch to read kernel cpustat for atomicity
> requirement against concurrent incrementation, which only 64 bit archs
> can provide.
> 
> It's probably no big deal to solve this issue. What we need is simply some
> atomic accessors.
> 
> There is just no emergency though as this new option depends on the context
> tracking subsystem that only x86-64 (and soon ppc64) implements yet. And
> this set is complex enough already. I think we can deal with that later.

I've ran these through some basic tests and I don't see any issues. But
why did you drop the 'comment' patch that you had in v6?

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


