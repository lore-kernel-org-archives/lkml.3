Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab3LTS0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:26:15 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:38583 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751296Ab3LTS0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:26:14 -0500
Date: Fri, 20 Dec 2013 13:26:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        mingo@redhat.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Subject: Re: [PATCH 09/13] sched: Add bandwidth management for sched_dl
Message-ID: <20131220132611.69a1a70d@gandalf.local.home>
In-Reply-To: <20131220132323.524cf2b1@gandalf.local.home>
References: <20131217122720.950475833@infradead.org>
	<20131217123353.180539582@infradead.org>
	<20131218165508.GB30183@twins.programming.kicks-ass.net>
	<20131220171343.GL2480@laptop.programming.kicks-ass.net>
	<20131220123707.44fb7192@gandalf.local.home>
	<20131220174200.GX16438@laptop.programming.kicks-ass.net>
	<20131220132323.524cf2b1@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013 13:23:23 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> 	CPU 0			CPU 1
> 	-----			-----
>  sched_setattr()
>  dl_overflow()
>  cpus = __dl_span_weight()
> 
> 			  cpu_down()
> 			  raw_spin_lock()
>  raw_spin_lock() /* blocks */
> 
> 
> 			  overflow = __dl_overflow(cpus-1);
> 			  raw_spin_unlock();
> 
>  /* gets lock */
>  __dl_overflow(cpus) /* all OK! */

Forgot to add:

 /* new deadline commitment added here */

> 
> 
> 
> 			  /* cpus goes to cpus - 1 making
> 			     __dl_overflow() not OK anymore */
> 

			also should have stated:

			"__dl_overflow(cpus-1) not OK anymore"


-- Steve
