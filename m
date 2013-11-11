Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3KKQYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:24:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38155 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab3KKQYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:24:40 -0500
Date: Mon, 11 Nov 2013 17:24:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Vince Weaver <vince@deater.net>, hpa@zytor.com, anton@samba.org,
        mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, fweisbec@gmail.com, VICTORK@il.ibm.com,
        tglx@linutronix.de, oleg@redhat.com, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [tip:perf/core] tools/perf: Add required memory barriers
Message-ID: <20131111162402.GA26898@twins.programming.kicks-ass.net>
References: <20131030104246.GH16117@laptop.programming.kicks-ass.net>
 <tip-a94d342b9cb09edfe888ea972af0883b6a8d992b@git.kernel.org>
 <alpine.DEB.2.02.1311060847340.27224@pianoman.cluster.toy>
 <20131106140011.GL10651@twins.programming.kicks-ass.net>
 <20131106144456.GI26785@twins.programming.kicks-ass.net>
 <20131106160720.GK26785@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1311061223290.28798@pianoman.cluster.toy>
 <20131106182437.GJ16117@laptop.programming.kicks-ass.net>
 <20131107082122.GC32438@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107082122.GC32438@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 09:21:22AM +0100, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > Requiring the user of a kernel interface to have a deep knowledge of 
> > > optimizing compilers, barriers, and CPU memory models is just asking 
> > > for trouble.
> > 
> > It shouldn't be all that hard to put this in a (lgpl) library others can 
> > link to -- that way you can build it once (using GCC).
> 
> I'd suggest to expose it via a new perf syscall, using vsyscall methods to 
> not have to enter the kernel for the pure user-space bits. It should also 
> have a real usecase in tools/perf/ so that it's constantly tested, with 
> matching 'perf test' entries, etc.

Oh man, I've never poked at the entire vsyscall stuff before; let alone
done it for ARM, ARM64, PPC64 etc..

Keeping it in userspace like we have is so much easier.
