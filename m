Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3KKVKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:10:15 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:46782 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3KKVKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:10:06 -0500
Date: Mon, 11 Nov 2013 22:10:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20131111211002.GB19284@gmail.com>
References: <20131030104246.GH16117@laptop.programming.kicks-ass.net>
 <tip-a94d342b9cb09edfe888ea972af0883b6a8d992b@git.kernel.org>
 <alpine.DEB.2.02.1311060847340.27224@pianoman.cluster.toy>
 <20131106140011.GL10651@twins.programming.kicks-ass.net>
 <20131106144456.GI26785@twins.programming.kicks-ass.net>
 <20131106160720.GK26785@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1311061223290.28798@pianoman.cluster.toy>
 <20131106182437.GJ16117@laptop.programming.kicks-ass.net>
 <20131107082122.GC32438@gmail.com>
 <20131111162402.GA26898@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111162402.GA26898@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Nov 07, 2013 at 09:21:22AM +0100, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > > Requiring the user of a kernel interface to have a deep knowledge of 
> > > > optimizing compilers, barriers, and CPU memory models is just asking 
> > > > for trouble.
> > > 
> > > It shouldn't be all that hard to put this in a (lgpl) library others can 
> > > link to -- that way you can build it once (using GCC).
> > 
> > I'd suggest to expose it via a new perf syscall, using vsyscall methods to 
> > not have to enter the kernel for the pure user-space bits. It should also 
> > have a real usecase in tools/perf/ so that it's constantly tested, with 
> > matching 'perf test' entries, etc.
> 
> Oh man, I've never poked at the entire vsyscall stuff before; let alone
> done it for ARM, ARM64, PPC64 etc..
> 
> Keeping it in userspace like we have is so much easier.

... and so much more broken in fantastic ways, right? ;-)

Thanks,

	Ingo
