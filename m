Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbaEPMI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:08:27 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:42627 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbaEPMI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:08:26 -0400
Date: Fri, 16 May 2014 08:08:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, jjherne@linux.vnet.ibm.com,
        Sasha Levin <sasha.levin@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
Message-ID: <20140516120822.GA13288@mtj.dyndns.org>
References: <537119EF.2060102@oracle.com>
 <20140512200135.GL1421@htj.dyndns.org>
 <53718119.1090000@cn.fujitsu.com>
 <537180B9.6080407@oracle.com>
 <53739F3B.4060608@linux.vnet.ibm.com>
 <53758B12.8060609@cn.fujitsu.com>
 <20140516115737.GP11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516115737.GP11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Fri, May 16, 2014 at 01:57:37PM +0200, Peter Zijlstra wrote:
> This of course leaves the question how the workqueue code manages to
> call set_cpu_allowed_ptr() on a cpu _before_ its online.
> 
> That too sounds fishy.. with the proposed patch the
> set_cpus_allowed_ptr() will 'gracefully' fail, but calling it in the
> first place is of course dubious too.

Right after being created, a workqueue worker invokes
set_cpus_allowed_ptr() to the target cpumask without checking whether
the cpu[s] are online or not and it's allowed to fail.  The guarantee
there is that the worker is already registered by that point and if a
CPU comes online after the registration, CPU_ONLINE notification will
update the cpumask accordingly, so either way the worker is guaranteed
to be on the right cpumask.

Thanks.

-- 
tejun
