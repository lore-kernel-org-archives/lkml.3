Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab3KGPzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:55:51 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:46111 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab3KGPzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:55:48 -0500
Date: Thu, 7 Nov 2013 16:55:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com, anton@samba.org,
        mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, fweisbec@gmail.com, VICTORK@il.ibm.com,
        tglx@linutronix.de, oleg@redhat.com, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [tip:perf/core] tools/perf: Add required memory barriers
Message-ID: <20131107155544.GA9619@gmail.com>
References: <20131030104246.GH16117@laptop.programming.kicks-ass.net>
 <tip-a94d342b9cb09edfe888ea972af0883b6a8d992b@git.kernel.org>
 <alpine.DEB.2.02.1311060847340.27224@pianoman.cluster.toy>
 <20131106140011.GL10651@twins.programming.kicks-ass.net>
 <20131106144456.GI26785@twins.programming.kicks-ass.net>
 <20131106160720.GK26785@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1311061223290.28798@pianoman.cluster.toy>
 <20131106182437.GJ16117@laptop.programming.kicks-ass.net>
 <20131107082122.GC32438@gmail.com>
 <alpine.DEB.2.02.1311070918440.19262@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311070918440.19262@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vince@deater.net> wrote:

> On Thu, 7 Nov 2013, Ingo Molnar wrote:
> 
> > I don't want a library that is external and under-tested: for example 
> > quite a few of the PAPI breakages were found very late, after a new 
> > kernel has been released - that's the big disadvantage of 
> > librarization and decentralization. The decentralized library model 
> > might work if all you want to create is a second-class also-ran GUI, 
> > but it just doesn't work very well for actively developed kernel code.
> 
> I would argue that PAPI's problem was because it was trying to use 
> perf_event_open() which is a complex, poorly documented kernel interface 
> with a lot of code churn.  Usually it's the job of the kernel not to 
> break user-space, not the other way around.

As Linus said it on the Kernel Summit: breakages that don't get reported 
or don't get noticed essentially don't exist. We can only fix what gets 
reported in time.

> It's too late on the decentralized library issue.  PAPI has to support 
> kernels going back to 2.6.32 so it's going to have its own copy of the 
> mmap parsing code even if a new syscall gets introduced.
> 
> There are a lot of tools out there now that open-code a perf_event 
> interface.  I don't think it's really possible to say "anyone using the 
> syscall without using our kernel library is unsupported".

I'm not saying that at all - but you appear to expect perfect kernel code 
and fixes done before you report them: that's an impossible expectation.

It's your choice to live outside the space that we readily test and it's 
your choice to not test your bits with a new kernel in time. Others do not 
test your code with -rc kernels, they don't report the bugs, so some bugs 
that affect the PAPI library go unnoticed. Yet you try to blame it on us, 
which is really backwards ...

Thanks,

	Ingo
