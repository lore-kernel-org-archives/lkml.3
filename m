Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab3KFOxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:53:24 -0500
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:52915 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932579Ab3KFOxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:53:20 -0500
Date: Wed, 6 Nov 2013 09:55:17 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <peterz@infradead.org>
cc: mingo@kernel.org, hpa@zytor.com, anton@samba.org,
        mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, fweisbec@gmail.com, VICTORK@il.ibm.com,
        tglx@linutronix.de, oleg@redhat.com, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] tools/perf: Add required memory barriers
In-Reply-To: <20131106142840.GH26785@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1311060938220.27607@pianoman.cluster.toy>
References: <20131030104246.GH16117@laptop.programming.kicks-ass.net> <tip-a94d342b9cb09edfe888ea972af0883b6a8d992b@git.kernel.org> <alpine.DEB.2.02.1311060847340.27224@pianoman.cluster.toy> <20131106140011.GL10651@twins.programming.kicks-ass.net>
 <20131106142840.GH26785@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020208.527A57DF.01C4,ss=1,re=0.100,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013, Peter Zijlstra wrote:

> On Wed, Nov 06, 2013 at 03:00:11PM +0100, Peter Zijlstra wrote:
> > On Wed, Nov 06, 2013 at 08:50:47AM -0500, Vince Weaver wrote:
> > 
> > > remember that there are users trying to use this outside of the kernel 
> > > where we don't necessarily have access to internal kernl macros.  Some of 
> > > these users aren't necessarily GPLv2 compatible either (PAPI for example 
> > > is more or less BSD licensed) so just cutting and pasting chunks of 
> > > internal kernel macros isn't always the best route either.
> > 
> > Other license stuff is not my problem; that said I doubt there's much
> > copyright to claim on a volatile cast.

perhaps, but everytime some internal kernel stuff goes into the visible 
API it makes it harder to use.  I don't think most other system calls leak 
kernel interfaces like this.

It's also an issue because people build PAPI with non-gcc compilers like 
Intel and clang so there's no guarantee kernel macro tricks are going to 
work for everyone.

Having perf in the kernel tree really makes it hard for you guys to keep a 
clean API/ABI it seems.

> Also, does PAPI actually use the buffer then? I thought that was
> strictly self monitoring.

PAPI has always supported a simplistic sampling mode, where you 
enable a one-shot overflow signal handler to be triggered after X events, 
and then read out the instruction pointer from the mmap buffer.  Then 
usually you re-enable for the next sample.  (You may dimly remember this 
because this usage style is very different than perf's so it breaks often 
w/o anyone but us noticing).

Not very effective and not taking full advantage of all perf_event has to 
support, but it's a cross-platform legacy interface supported easily by 
most implementations.

We've been planning to do a proper sampled perf_event interface but it's 
been hard trying to hammer out a clean interface that fits well with the 
existing PAPI design.

Vince
