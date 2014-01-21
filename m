Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbaAUQDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 11:03:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:43524 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754607AbaAUQDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:03:03 -0500
Date: Tue, 21 Jan 2014 11:02:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        Dario Faggioli <raistlin@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        Linux Kernel <linux-kernel@vger.kernel.org>, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com
Subject: Re: [PATCH 01/13] sched: Add 3 new scheduler syscalls to support an
 extended scheduling parameters ABI
Message-ID: <20140121110255.7d9af63d@gandalf.local.home>
In-Reply-To: <20140121154603.GF3694@twins.programming.kicks-ass.net>
References: <20131217122720.950475833@infradead.org>
	<20131217123352.692059839@infradead.org>
	<CAHO5Pa3=+Zhg72tVfddSUvgirUyObir6atJVo4_16bVWB2Osgw@mail.gmail.com>
	<20140121153851.GZ31570@twins.programming.kicks-ass.net>
	<20140121154603.GF3694@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014 16:46:03 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Jan 21, 2014 at 04:38:51PM +0100, Peter Zijlstra wrote:
> >     SCHED_DEADLINE: Sporadic task model deadline scheduling
> > 	SCHED_DEADLINE is an implementation of GEDF (Global Earliest
> > 	Deadline First) with additional CBS (Constant Bandwidth Server).
> 
> We might want to re-word that to:
> 
> 	SCHED_DEADLINE currently is an implementation of GEDF, however
> 	any policy that correctly schedules the sporadic task model is
> 	a valid implementation.
> 
> To make sure we should not rely on the actual implementation; there's
> many possible algorithms to schedule the sporadic task model.

Probably should post some links to GEDF documentation too?

-- Steve

> 
> > 	The CBS guarantees that tasks that over-run their specified
> > 	budget are throttled and do not affect the correct performance
> > 	of other SCHED_DEADLINE tasks.
> > 
> > 	SCHED_DEADLINE tasks will fail FORK(2) with -EAGAIN
> > 
> > 	Setting SCHED_DEADLINE can fail with -EINVAL when admission
> > 	control tests fail.
> > 

