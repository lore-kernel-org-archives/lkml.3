Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3BRPZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:25:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5821 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab3BRPZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:25:43 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MPEKn9ueenIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=zGjexpQmzOwA:10 a=tk1wMlCsNWfesXFyr2wA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361201142.23152.152.camel@gandalf.local.home>
Subject: Re: [RFC] sched: The removal of idle_balance()
From: Steven Rostedt <rostedt@goodmis.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Clark Williams <clark@redhat.com>,
        Andrew Theurer <habanero@us.ibm.com>
Date: Mon, 18 Feb 2013 10:25:42 -0500
In-Reply-To: <20130218081345.GA4157@linux.vnet.ibm.com>
References: <1360908819.23152.97.camel@gandalf.local.home>
	 <20130218081345.GA4157@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 13:43 +0530, Srikar Dronamraju wrote:
> > The cache misses dropped by ~23% and migrations dropped by ~28%. I
> > really believe that the idle_balance() hurts performance, and not just
> > for something like hackbench, but the aggressive nature for migration
> > that idle_balance() causes takes a large hit on a process' cache.
> > 
> > Think about it some more, just because we go idle isn't enough reason to
> > pull a runable task over. CPUs go idle all the time, and tasks are woken
> > up all the time. There's no reason that we can't just wait for the sched
> > tick to decide its time to do a bit of balancing. Sure, it would be nice
> > if the idle CPU did the work. But I think that frame of mind was an
> > incorrect notion from back in the early 2000s and does not apply to
> > today's hardware, or perhaps it doesn't apply to the (relatively) new
> > CFS scheduler. If you want aggressive scheduling, make the task rt, and
> > it will do aggressive scheduling.
> > 
> 
> How is it that the normal tick based load balancing gets it correctly while
> the idle_balance gets is wrong?  Can it because of the different
> cpu_idle_type?
> 

Currently looks to be a fluke in my box, as this performance increase
can't be duplicated elsewhere (yet). But from looking at my traces, it
seems that my box does the idle balance at just the wrong time, and
causes these issues.

-- Steve


