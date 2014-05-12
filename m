Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbaELVQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:16:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:56911 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbaELVQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:16:29 -0400
Date: Mon, 12 May 2014 23:16:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 3/3] futex: Prevent attaching to kernel threads
In-Reply-To: <20140512205444.GI13467@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1405122256190.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de> <20140512201701.194824402@linutronix.de> <20140512205444.GI13467@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014, Peter Zijlstra wrote:

> On Mon, May 12, 2014 at 08:45:35PM -0000, Thomas Gleixner wrote:
> > We happily allow userspace to declare a random kernel thread to be the
> > owner of a user space PI futex.
> > 
> > Found while analysing the fallout of Dave Jones syscall fuzzer.
> 
> Did you also still want to check the ppid for _PRIVATE futexes?

Yes.

I'm still twisting my brain how to confine the non shared case w/o
going through loops and hoops. I'm not really sure, whether we can do
something about that without making it extremly painful, but we really
should try hard.

If the non shared case turns out to be a hopeless case, then we go for
the easy private confinement or make the shared case actually painfull
enough that people who care about it figure it out :)

Thanks,

	tglx

