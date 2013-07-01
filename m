Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3GAT40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:56:26 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45317 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3GAT4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:56:25 -0400
Date: Mon, 1 Jul 2013 12:56:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 0/7] v2 Provide infrastructure for
 full-system idle
Message-ID: <20130701195603.GT3773@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130628200949.GA17458@linux.vnet.ibm.com>
 <0000013f9bc32a5e-258db1be-840b-4b2f-9b3f-e1e3d5253cfc-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013f9bc32a5e-258db1be-840b-4b2f-9b3f-e1e3d5253cfc-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070119-2876-0000-0000-00000A6E8B7D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 07:43:47PM +0000, Christoph Lameter wrote:
> On Fri, 28 Jun 2013, Paul E. McKenney wrote:
> 
> > Unfortunately, timekeeping CPU continues taking scheduling-clock
> > interrupts even when all other CPUs are completely idle, which is
> > not so good for energy efficiency and battery lifetime.  Clearly, it
> > would be good to turn off the timekeeping CPU's scheduling-clock tick
> > when all CPUs are completely idle.  This is conceptually simple, but
> > we also need good performance and scalability on large systems, which
> > rules out implementations based on frequently updated global counts of
> > non-idle CPUs as well as implementations that frequently scan all CPUs.
> > Nevertheless, we need a single global indicator in order to keep the
> > overhead of checking acceptably low.
> 
> Can we turn off timekeeping when no cpu needs time in adaptive mode?
> Setting breakpoints in the VDSO could force timekeeping on again whenever
> something needs time. Would this not be simpler?

Might be.  But what causes the breakpoints to be set on a system where
there is one CPU-bound nohz_full user-mode task with all other CPUs idle?
Or are you suggesting taking a breakpoint trap on each timekeeping access
to VDSO?

							Thanx, Paul

