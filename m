Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab3JHK0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:26:53 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:44327 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab3JHK0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:26:49 -0400
Date: Tue, 8 Oct 2013 12:26:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [raw v1 2/4] [NET] Use raw_cpu ops for SNMP stats
Message-ID: <20131008102645.GA22639@gmail.com>
References: <20131007183226.334180014@linux.com>
 <0000014194309205-d0af4d2d-a046-4189-b4f0-ffea37374988-000000@email.amazonses.com>
 <20131008072114.GA4455@gmail.com>
 <20131008102142.GT3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008102142.GT3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Oct 08, 2013 at 09:21:14AM +0200, Ingo Molnar wrote:
> > 
> > * Christoph Lameter <cl@linux.com> wrote:
> > 
> > > SNMP stats are not protected by preemption but by bh handling.
> > 
> > Most forms of bh exclusion work via the preemption count though, and 
> > softirq contexts themselves are generally not preemptible [to other CPUs] 
> > either.
> > 
> > So the warnings should, in most cases, not trigger.
> 
> Right, so softirqs run either in the irq tail at which point 
> preempt_count += SOFTIRQ_OFFSET and thus preemption is disabled, or it 
> runs in ksoftirqd which has strict cpu affinity which also disables the 
> warning, and it also increments preempt_count with SOFTIRQ_OFFSET to 
> exclude the softirq from interrupts while its running, also disabling 
> the warning.

A third context would be syscall-level code that runs with 
local_bh_disable()/enable() - but that too ought to have the preempt count 
elevated.

> So it should very much not trigger.. if it does you want to know about 
> it.

Yes. If nothing else then for the education value.

Thanks,

	Ingo
