Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab3JHKWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:22:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32789 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab3JHKVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:21:55 -0400
Date: Tue, 8 Oct 2013 12:21:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [raw v1 2/4] [NET] Use raw_cpu ops for SNMP stats
Message-ID: <20131008102142.GT3081@twins.programming.kicks-ass.net>
References: <20131007183226.334180014@linux.com>
 <0000014194309205-d0af4d2d-a046-4189-b4f0-ffea37374988-000000@email.amazonses.com>
 <20131008072114.GA4455@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008072114.GA4455@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 09:21:14AM +0200, Ingo Molnar wrote:
> 
> * Christoph Lameter <cl@linux.com> wrote:
> 
> > SNMP stats are not protected by preemption but by bh handling.
> 
> Most forms of bh exclusion work via the preemption count though, and 
> softirq contexts themselves are generally not preemptible [to other CPUs] 
> either.
> 
> So the warnings should, in most cases, not trigger.

Right, so softirqs run either in the irq tail at which point
preempt_count += SOFTIRQ_OFFSET and thus preemption is disabled, or it
runs in ksoftirqd which has strict cpu affinity which also disables the
warning, and it also increments preempt_count with SOFTIRQ_OFFSET to
exclude the softirq from interrupts while its running, also disabling
the warning.

So it should very much not trigger.. if it does you want to know about
it.
