Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3BRIQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 03:16:42 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55810 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3BRIQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:16:41 -0500
Date: Mon, 18 Feb 2013 13:43:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
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
Subject: Re: [RFC] sched: The removal of idle_balance()
Message-ID: <20130218081345.GA4157@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1360908819.23152.97.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1360908819.23152.97.camel@gandalf.local.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021808-3620-0000-0000-00000140F430
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The cache misses dropped by ~23% and migrations dropped by ~28%. I
> really believe that the idle_balance() hurts performance, and not just
> for something like hackbench, but the aggressive nature for migration
> that idle_balance() causes takes a large hit on a process' cache.
> 
> Think about it some more, just because we go idle isn't enough reason to
> pull a runable task over. CPUs go idle all the time, and tasks are woken
> up all the time. There's no reason that we can't just wait for the sched
> tick to decide its time to do a bit of balancing. Sure, it would be nice
> if the idle CPU did the work. But I think that frame of mind was an
> incorrect notion from back in the early 2000s and does not apply to
> today's hardware, or perhaps it doesn't apply to the (relatively) new
> CFS scheduler. If you want aggressive scheduling, make the task rt, and
> it will do aggressive scheduling.
> 

How is it that the normal tick based load balancing gets it correctly while
the idle_balance gets is wrong?  Can it because of the different
cpu_idle_type?

-- 
Thanks and Regards
Srikar Dronamraju

