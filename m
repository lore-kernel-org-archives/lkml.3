Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaAPOoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:44:25 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:18838 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752335AbaAPOoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:44:23 -0500
Date: Thu, 16 Jan 2014 09:44:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH v3 tip/core/timers 0/5] Crude timer-wheel latency hacks
Message-ID: <20140116094420.41d435c5@gandalf.local.home>
In-Reply-To: <20140116040203.GA5206@linux.vnet.ibm.com>
References: <20140116040203.GA5206@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 20:02:03 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> Hello!
> 
> The following five patches provide some crude timer-wheel latency patches.
> I understand that a more comprehensive solution is in progress, but in the
> meantime, these patches work well in cases where a given CPU has either
> zero or one timers pending, which is a common case for NO_HZ_FULL kernels.
> Note that these patches do not help in the case where a given timer wheel
> has a pair of widely separated timers, while the more comprehensive
> solution is likely to handle more gracefully.  So, on the off-chance
> that this is helpful to someone, the individual patches are as follows:
> 
> 1.	Add ->all_timers field to tbase_vec to count all timers, not
> 	just the non-deferrable ones.
> 
> 2.	Avoid jiffy-at-a-time stepping when the timer wheel is empty.
> 
> 3.	Avoid jiffy-at-a-time stepping when the timer wheel transitions
> 	to empty.
> 
> 4.	Avoid jiffy-at-a-time stepping after a timer is added to an
> 	initially empty timer wheel.
> 
> 5.	Make internal_add_timer() update ->next_timer if ->active_timers == 0,
> 	courtesy of Oleg Nesterov.
> 

Although I think the "(void)" is ugly and uncalled for (there's lots of
functions that return a value in the kernel that don't have that). But,
it's not up to me to argue this.

For all 5 patches,

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
