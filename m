Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab3GRMQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 08:16:00 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55896 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731Ab3GRMP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 08:15:59 -0400
Date: Thu, 18 Jul 2013 17:45:46 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jason Low <jason.low2@hp.com>,
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
Message-ID: <20130718121546.GB3745@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130717072504.GY17211@twins.programming.kicks-ass.net>
 <1374048701.6000.21.camel@j-VirtualBox>
 <20130717093913.GP23818@dyad.programming.kicks-ass.net>
 <1374076741.7412.35.camel@j-VirtualBox>
 <20130717161815.GR23818@dyad.programming.kicks-ass.net>
 <51E6D9B7.1030705@redhat.com>
 <20130717180156.GS23818@dyad.programming.kicks-ass.net>
 <1374120144.1816.45.camel@j-VirtualBox>
 <20130718093218.GH27075@twins.programming.kicks-ass.net>
 <51E7D89A.8010009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <51E7D89A.8010009@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071812-7182-0000-0000-000007C48B35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel <riel@redhat.com> [2013-07-18 07:59:22]:

> On 07/18/2013 05:32 AM, Peter Zijlstra wrote:
> >On Wed, Jul 17, 2013 at 09:02:24PM -0700, Jason Low wrote:
> >
> >>I ran a few AIM7 workloads for the 8 socket HT enabled case and I needed
> >>to set N to more than 20 in order to get the big performance gains.
> >>
> >>One thing that I thought of was to have N be based on how often idle
> >>balance attempts does not pull task(s).
> >>
> >>For example, N can be calculated based on the number of idle balance
> >>attempts for the CPU  since the last "successful" idle balance attempt.
> >>So if the previous 30 idle balance attempts resulted in no tasks moved,
> >>then n = 30 / 5. So idle balance gets less time to run as the number of
> >>unneeded idle balance attempts increases, and thus N will not be set too
> >>high during situations where idle balancing is "successful" more often.
> >>Any comments on this idea?
> >
> >It would be good to get a solid explanation for why we need such high N.
> >But yes that might work.
> 
> I have some idea, though no proof :)
> 
> I suspect a lot of the idle balancing time is spent waiting for
> and acquiring the runqueue locks of remote CPUs.
> 

We take locks if and only if we see imbalance and want to pull the
tasks.
However if the newly idle balance is not finding an imbalance then this
may not be an issue.

Probably /proc/schedstats will give a better picture.

> If we spend half our idle time causing contention to remote
> runqueue locks, we could be a big factor in keeping those other
> CPUs from getting work done.
> 
> -- 
> All rights reversed
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Thanks and Regards
Srikar Dronamraju

