Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbaEPMOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:14:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:33284 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbaEPMOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:14:10 -0400
Date: Fri, 16 May 2014 14:14:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, jjherne@linux.vnet.ibm.com,
        Sasha Levin <sasha.levin@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
In-Reply-To: <20140516120822.GA13288@mtj.dyndns.org>
Message-ID: <alpine.DEB.2.02.1405161412310.4039@ionos.tec.linutronix.de>
References: <537119EF.2060102@oracle.com> <20140512200135.GL1421@htj.dyndns.org> <53718119.1090000@cn.fujitsu.com> <537180B9.6080407@oracle.com> <53739F3B.4060608@linux.vnet.ibm.com> <53758B12.8060609@cn.fujitsu.com> <20140516115737.GP11096@twins.programming.kicks-ass.net>
 <20140516120822.GA13288@mtj.dyndns.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014, Tejun Heo wrote:
> On Fri, May 16, 2014 at 01:57:37PM +0200, Peter Zijlstra wrote:
> > This of course leaves the question how the workqueue code manages to
> > call set_cpu_allowed_ptr() on a cpu _before_ its online.
> > 
> > That too sounds fishy.. with the proposed patch the
> > set_cpus_allowed_ptr() will 'gracefully' fail, but calling it in the
> > first place is of course dubious too.
> 
> Right after being created, a workqueue worker invokes
> set_cpus_allowed_ptr() to the target cpumask without checking whether
> the cpu[s] are online or not and it's allowed to fail.  The guarantee
> there is that the worker is already registered by that point and if a
> CPU comes online after the registration, CPU_ONLINE notification will
> update the cpumask accordingly, so either way the worker is guaranteed
> to be on the right cpumask.

That's what the kthread_create_on_cpu/kthread_park/kthread_unpark
infrastructure is for.

Thanks,

	tglx
