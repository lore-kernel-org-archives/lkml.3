Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab3EHLg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 07:36:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59267 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3EHLg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 07:36:26 -0400
Date: Wed, 8 May 2013 13:34:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Alex Shi <alex.shi@intel.com>, Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 3/7] sched: set initial value of runnable avg for new
 forked task
Message-ID: <20130508113442.GB6803@dyad.programming.kicks-ass.net>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
 <1367804711-30308-4-git-send-email-alex.shi@intel.com>
 <CAPM31RJg7t8f1H-dZwzP1c-0HHb_=8twidX74gS2NfyQhHUhCw@mail.gmail.com>
 <5187760D.8060900@intel.com>
 <CAPM31RKiCfSZ=hJ9P7WOH6AC8uj6b06mEM6K0WCTYXC7OJAq7A@mail.gmail.com>
 <51886460.3020009@intel.com>
 <CAPM31RLsip-PMY73oq58gyi42EQ+-upmPpMQFkukVBX6LTwtCw@mail.gmail.com>
 <20130507095715.GE4068@e103034-lin>
 <5188DFEF.6010403@intel.com>
 <CAPM31R+x3h0b_r4uFkg_SMnkp0AWA6QRAQuDRducycHnFdG5Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31R+x3h0b_r4uFkg_SMnkp0AWA6QRAQuDRducycHnFdG5Xw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 04:20:55AM -0700, Paul Turner wrote:
> Yes, 1024 was only intended as a starting point.  We could also
> arbitrarily pick something larger, the key is that we pick
> _something_.
> 
> If we wanted to be more exacting about it we could just give them a
> sched_slice() worth; this would have a few obvious "nice" properties
> (pun intended).

Oh I see I misunderstood again :/ Its not about the effective load but weight
of the initial effective load wrt adjustment.

Previous schedulers didn't have this aspect at all, so no experience from me
here. Paul would be the one, since he's ran longest with this stuff.

That said, I would tend to keep it shorter rather than longer so that it would
adjust quicker to whatever it really wanted to be.

Morten says the load is unstable specifically on loaded systems. I would think
this is because we'd experience scheduling latency, we're runnable more pushing
things up. But if we're really an idle task at heart we'd not run again for a
long while, pushing things down again.

So on that point Paul's suggestion of maybe starting with __sched_slice() might
make sense because it increases the weight of the initial avg with nr_running.

Not sure really, we'll have to play and see what works best for a number of
workloads.
