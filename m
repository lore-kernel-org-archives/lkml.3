Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaAPFsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 00:48:12 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39331 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaAPFsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 00:48:07 -0500
X-Originating-IP: 50.43.14.201
Date: Wed, 15 Jan 2014 21:47:53 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH v3 tip/core/timers 0/5] Crude timer-wheel latency hacks
Message-ID: <20140116054753.GC16901@leaf>
References: <20140116040203.GA5206@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116040203.GA5206@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 08:02:03PM -0800, Paul E. McKenney wrote:
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

For all five patches in v3:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
