Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab3BVOQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:16:42 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:49646 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab3BVOQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:16:40 -0500
Date: Fri, 22 Feb 2013 15:16:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 0/2] cpustat: use atomic operations to read/update stats
Message-ID: <20130222141635.GA9606@gmail.com>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
 <1361522767.26780.44.camel@laptop>
 <20130222125019.GC17948@somewhere.redhat.com>
 <1361540926.26780.56.camel@laptop>
 <20130222135411.GA9202@gmail.com>
 <1361541894.26780.62.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361541894.26780.62.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2013-02-22 at 14:54 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Fri, 2013-02-22 at 13:50 +0100, Frederic Weisbecker wrote:
> > 
> > > > atomic64_read() and atomic64_set() are supposed to take care 
> > > > of that, without even the need for _inc() or _add() parts 
> > > > that use LOCK.
> > > 
> > > Are you sure? Generally atomic*_set() is not actually an 
> > > atomic operation.
> > 
> > as per Documentation/atomic_ops.h:
> 
> I think the interesting part is:
> 
> "The setting is atomic in that the return values of the atomic 
> operations by all threads are guaranteed to be correct 
> reflecting either the value that has been set with this 
> operation or set with another operation.  A proper implicit or 
> explicit memory barrier is needed before the value set with 
> the operation is guaranteed to be readable with atomic_read 
> from another thread."
> 
> Which does give us the wanted guarantee, however:
> 
> I checked arch/x86/include/asm/atomic64_32.h and we use 
> cmpxchg8b for everything from _set() to _read(), which 
> translates into 'horridly stupendifyingly slow' for a number 
> of machines, but coherent.

That's a valid concern - and cmpxchg8b is the only 64-bit op 
available on most 32-bit x86 CPUs which does not involve the 
FPU.

Wondering how significant this range of x86 problem boxes will 
be by the time any of these changes reaches upstream and distros 
- and how much 'horridly stupendifyingly slow' is in terms of 
cycles expended.

Thanks,

	Ingo
