Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbaIDG3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 02:29:54 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:53544 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707AbaIDG3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 02:29:53 -0400
Message-ID: <1409812189.7539.27.camel@marge.simpson.net>
Subject: Re: [tracing]  trying to make sense of trace output, can't figure
 out where time is going
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Chris Friesen <chris.friesen@windriver.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Date: Thu, 04 Sep 2014 08:29:49 +0200
In-Reply-To: <540782F7.7030603@windriver.com>
References: <540782F7.7030603@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-03 at 15:07 -0600, Chris Friesen wrote:

> kvm-23696   4d...3.. 507584570us : sched_switch: prev_comm=kvm prev_pid=23696 prev_prio=120 prev_state=R+ ==> next_comm=ksoftirqd/4 next_pid=80 next_prio=98
> ksoftirq-80      4....111 507584570us!: softirq_entry: vec=1 [action=TIMER]

> I'm trying to figure out what would cause that jump between the first
> two ksoftirqd logs.
> 
> Some stuff in /proc/cmdline that might be relevent (it's a bit of a mishmash,
> I know):
> 
> intel_iommu=off isolcpus=1-15 rcu_nocbs=1-15 irqaffinity=0
> intel_idle.max_cstate=0 processor.max_cstate=1 idle=poll
> 
> 
> In the BIOS we've disabled speedstep, CPU C states, and NMI on
> error.
> 
> Is there a different tracer that would give more insight?  The irqs-off or
> preemption-off tracers perhaps?

I'd try to take a snapshot with the function tracer.  Add a couple
trace_printk()s, set a tracing_off() trap for TIMER sirq processing
taking ages, stare at resulting 8x10 color glossy.

-Mike


