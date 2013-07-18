Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab3GRNJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:09:53 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49795 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3GRNJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:09:51 -0400
Date: Thu, 18 Jul 2013 18:36:37 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Jason Low <jason.low2@hp.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [RFC] sched: Limit idle_balance() when it is being used too
 frequently
Message-ID: <20130718130637.GA5138@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130717093913.GP23818@dyad.programming.kicks-ass.net>
 <1374076741.7412.35.camel@j-VirtualBox>
 <20130717161815.GR23818@dyad.programming.kicks-ass.net>
 <51E6D9B7.1030705@redhat.com>
 <20130717180156.GS23818@dyad.programming.kicks-ass.net>
 <1374120144.1816.45.camel@j-VirtualBox>
 <20130718093218.GH27075@twins.programming.kicks-ass.net>
 <51E7D89A.8010009@redhat.com>
 <20130718121546.GB3745@linux.vnet.ibm.com>
 <20130718123531.GO27075@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130718123531.GO27075@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071813-2398-0000-0000-0000008499C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2013-07-18 14:35:31]:

> On Thu, Jul 18, 2013 at 05:45:46PM +0530, Srikar Dronamraju wrote:
> > We take locks if and only if we see imbalance and want to pull the
> > tasks.
> > However if the newly idle balance is not finding an imbalance then this
> > may not be an issue.
> > 
> > Probably /proc/schedstats will give a better picture.
> 
> Right, so we're interested in move_tasks() calls that fail to 'deliver'.
> There's a few conditions in there that can cause us to not move a task,
> most of them not counted.
> 
> The few that are; are from can_mirgrate_task():
> 
>   se.statistics.nr_failed_migrations_affine
>   se.statistics.nr_failed_migrations_running
>   se.statistics.nr_failed_migrations_hot
> 
> If we see significant increments on those we'll be taking locks. 
> 

Agree. 

Even I think number of times no busy group was found, number of times no
busy queue was found also will tell us that locks are not being taken.

In schedstats, I generally see them as overwhelming majority.


> The only one I can see a good way around is the hot one, we could ignore
> hotness in favour of newidle -- although I could see that being
> detrimental, we'll just have to try or so ;-)
> 
> _running shouldn't be much of a problem since we don't bother if
> nr_running <= 1. And _affine is out of our reach anyway.
> 

-- 
Thanks and Regards
Srikar Dronamraju

