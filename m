Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaE0Sx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:53:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:6370 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753224AbaE0Sxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:53:55 -0400
Date: Tue, 27 May 2014 14:53:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 3.14-rt] sched/numa: Fix task_numa_free() lockdep splat
Message-ID: <20140527145349.0bc2030e@gandalf.local.home>
In-Reply-To: <20140527145201.6e79230f@gandalf.local.home>
References: <20140509181214.GK29014@linutronix.de>
	<1400297819.9493.11.camel@marge.simpson.net>
	<20140527141836.4f466086@gandalf.local.home>
	<20140527182541.GH11096@twins.programming.kicks-ass.net>
	<20140527145201.6e79230f@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014 14:52:01 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

 
> Ah crap. I did a search on all the callers of put_task_struct(), and
> somehow missed this one.  Yep, I was looking for places that called
> this while holding other irq safe locks.
> 

Anyway, this nicely answers Mike's question to why it causes lockdep
splat. There exists a location that calls put_task_struct() with irqs
disabled (not to mention holding irq unsafe locks).

I was having problems just finding a place that called it with irqs off.

-- Steve
