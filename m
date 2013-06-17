Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab3FQNj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:39:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44096 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3FQNj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:39:57 -0400
Date: Mon, 17 Jun 2013 15:39:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch v8 6/9] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
Message-ID: <20130617133934.GX3204@twins.programming.kicks-ass.net>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
 <1370589652-24549-7-git-send-email-alex.shi@intel.com>
 <CAPM31RKwNUh+nNcsEftD4pyP+gdwXhRK7wCRNWa8Y0sE0hf-DQ@mail.gmail.com>
 <CAPM31R+DBFt1wr10GCGEHDW_J_-79imdTCYEBF7YiKdFc1V7iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31R+DBFt1wr10GCGEHDW_J_-79imdTCYEBF7YiKdFc1V7iQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 05:17:17AM -0700, Paul Turner wrote:
> On Mon, Jun 17, 2013 at 3:51 AM, Paul Turner <pjt@google.com> wrote:
> > On Fri, Jun 7, 2013 at 12:20 AM, Alex Shi <alex.shi@intel.com> wrote:
> >> They are the base values in load balance, update them with rq runnable
> >> load average, then the load balance will consider runnable load avg
> >> naturally.
> >>
> >> We also try to include the blocked_load_avg as cpu load in balancing,
> >> but that cause kbuild performance drop 6% on every Intel machine, and
> >> aim7/oltp drop on some of 4 CPU sockets machines.
> >>
> >
> > This looks fine.
> >
> > Did you try including blocked_load_avg in only get_rq_runnable_load()
> > [ and not weighted_cpuload() which is called by new-idle ]?
> 
> Looking at this more this feels less correct since you're taking
> averages of averages.
> 
> This was previously discussed at:
>   https://lkml.org/lkml/2013/5/6/109
> 
> And  you later replied suggesting this didn't seem to hurt; what's the
> current status there?

Wasn't there a follow up series (currently as RFC or so) that proposes
to removes the entire *_idx stuff?
