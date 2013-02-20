Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935622Ab3BTNsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:48:13 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44620
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935405Ab3BTNsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:48:12 -0500
Message-ID: <1361368088.10155.36.camel@laptop>
Subject: Re: [patch v5 11/15] sched: add power/performance balance allow flag
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Date: Wed, 20 Feb 2013 14:48:08 +0100
In-Reply-To: <1361367469.10155.34.camel@laptop>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
	 <1361164062-20111-12-git-send-email-alex.shi@intel.com>
	 <1361353681.10155.10.camel@laptop> <5124BBEA.3040806@intel.com>
	 <1361367469.10155.34.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 14:37 +0100, Peter Zijlstra wrote:
> On Wed, 2013-02-20 at 20:04 +0800, Alex Shi wrote:
> 
> > >> @@ -5195,6 +5197,8 @@ static int load_balance(int this_cpu, struct rq
> > >> *this_rq,
> > >>                 .idle           = idle,
> > >>                 .loop_break     = sched_nr_migrate_break,
> > >>                 .cpus           = cpus,
> > >> +               .power_lb       = 0,
> > >> +               .perf_lb        = 1,
> > >>         };
> > >>  
> > >>         cpumask_copy(cpus, cpu_active_mask);
> > > 
> > > This construct allows for the possibility of power_lb=1,perf_lb=1, does
> > > that make sense? Why not have a single balance_policy enumeration?
> > 
> > (power_lb == 1 && perf_lb == 1) is incorrect and impossible to have.
> > 
> > (power_lb == 0 && perf_lb == 0) is possible and it means there is no any
> > balance on this cpu.
> > 
> > So, enumeration is not enough.
> 
> Huh.. both 0 doesn't make any sense either. If there's no balancing, we
> shouldn't be here to begin with.

Also, why is this in the lb_env at all, shouldn't we simply use the
global sched_balance_policy all over the place? Its not like we want to
change power/perf on a finer granularity.


