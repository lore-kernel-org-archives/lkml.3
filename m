Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3BVOSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:18:20 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:51032 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3BVOSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:18:14 -0500
Date: Fri, 22 Feb 2013 15:18:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 0/2] cpustat: use atomic operations to read/update stats
Message-ID: <20130222141810.GB9606@gmail.com>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
 <1361522767.26780.44.camel@laptop>
 <20130222125019.GC17948@somewhere.redhat.com>
 <1361542150.26780.64.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361542150.26780.64.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2013-02-22 at 13:50 +0100, Frederic Weisbecker wrote:
> > > Argh!! at what cost? 64bit atomics are like expensive. Wouldn't
> > adding
> > > a seqlock be saner?
> > 
> > Not sure. This requires a spinlock in the write side which is called
> > from
> > fast path like the timer interrupt.
> 
> A single spinlock is _way_ cheaper than a ton of cmpxchg8b()s 
> to update a few variables.

Every cmpxchg8b() will be roughly as expensive as a spinlock 
acquire+release fastpath.

Thanks,

	Ingo
