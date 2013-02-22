Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab3BVIy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:54:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55975 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab3BVIyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:54:44 -0500
Message-ID: <1361523279.26780.45.camel@laptop>
Subject: Re: [patch v5 09/15] sched: add power aware scheduling in
 fork/exec/wake
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Date: Fri, 22 Feb 2013 09:54:39 +0100
In-Reply-To: <512631C7.8060103@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
	    <1361164062-20111-10-git-send-email-alex.shi@intel.com>
	   <1361353360.10155.9.camel@laptop> <5124BCEB.8030606@intel.com>
	  <1361367371.10155.32.camel@laptop> <5124DC76.2010801@intel.com>
	 <1361453587.26780.18.camel@laptop> <512631C7.8060103@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 22:40 +0800, Alex Shi wrote:
> > The name is a secondary issue, first you need to explain why you
> think
> > nr_running is a useful metric at all.
> > 
> > You can have a high nr_running and a low utilization (a burst of
> > wakeups, each waking a process that'll instantly go to sleep again),
> or
> > low nr_running and high utilization (a single process cpu bound
> > process).
> 
> It is true in periodic balance. But in fork/exec/waking timing, the
> incoming processes usually need to do something before sleep again.

You'd be surprised, there's a fair number of workloads that have
negligible runtime on wakeup.

> I use nr_running to measure how the group busy, due to 3 reasons:
> 1, the current performance policy doesn't use utilization too.

We were planning to fix that now that its available.

> 2, the power policy don't care load weight.

Then its broken, it should very much still care about weight. 

> 3, I tested some benchmarks, kbuild/tbench/hackbench/aim7 etc, some
> benchmark results looks clear bad when use utilization. if my memory
> right, the hackbench/aim7 both looks bad. I had tried many ways to
> engage utilization into this balance, like use utilization only, or
> use
> utilization * nr_running etc. but still can not find a way to recover
> the lose. But with nr_running, the performance seems doesn't lose much
> with power policy.

You're failing to explain why utilization performs bad and you don't
explain why nr_running is better. That things work simply isn't good
enough, you have to have at least a general idea (but much preferable a
very good idea) _why_ things work.


