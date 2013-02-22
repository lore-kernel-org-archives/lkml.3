Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3BVOVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:21:37 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:39752 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab3BVOVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:21:35 -0500
Message-ID: <1361542891.3683.6.camel@edumazet-glaptop>
Subject: Re: [PATCH 0/2] cpustat: use atomic operations to read/update stats
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Date: Fri, 22 Feb 2013 06:21:31 -0800
In-Reply-To: <1361542150.26780.64.camel@laptop>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
	 <1361522767.26780.44.camel@laptop>
	 <20130222125019.GC17948@somewhere.redhat.com>
	 <1361542150.26780.64.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 15:09 +0100, Peter Zijlstra wrote:
> On Fri, 2013-02-22 at 13:50 +0100, Frederic Weisbecker wrote:
> > > Argh!! at what cost? 64bit atomics are like expensive. Wouldn't
> > adding
> > > a seqlock be saner?
> > 
> > Not sure. This requires a spinlock in the write side which is called
> > from
> > fast path like the timer interrupt.
> 
> A single spinlock is _way_ cheaper than a ton of cmpxchg8b()s to update
> a few variables.

We also have include/linux/u64_stats_sync.h since 2.6.36







