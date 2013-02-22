Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3BVOXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:23:12 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:60710 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab3BVOXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:23:11 -0500
Date: Fri, 22 Feb 2013 15:23:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Kevin Hilman <khilman@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 0/2] cpustat: use atomic operations to read/update stats
Message-ID: <20130222142302.GC18149@somewhere.redhat.com>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
 <1361522767.26780.44.camel@laptop>
 <20130222125019.GC17948@somewhere.redhat.com>
 <1361542150.26780.64.camel@laptop>
 <1361542891.3683.6.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361542891.3683.6.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 06:21:31AM -0800, Eric Dumazet wrote:
> On Fri, 2013-02-22 at 15:09 +0100, Peter Zijlstra wrote:
> > On Fri, 2013-02-22 at 13:50 +0100, Frederic Weisbecker wrote:
> > > > Argh!! at what cost? 64bit atomics are like expensive. Wouldn't
> > > adding
> > > > a seqlock be saner?
> > > 
> > > Not sure. This requires a spinlock in the write side which is called
> > > from
> > > fast path like the timer interrupt.
> > 
> > A single spinlock is _way_ cheaper than a ton of cmpxchg8b()s to update
> > a few variables.
> 
> We also have include/linux/u64_stats_sync.h since 2.6.36

Interesting, we should probably use that instead.
