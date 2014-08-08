Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaHHIE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 04:04:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:38442 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbaHHIEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 04:04:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,823,1400050800"; 
   d="scan'208";a="573573096"
Date: Fri, 8 Aug 2014 08:02:55 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Segall <bsegall@google.com>,
        Waiman Long <Waiman.Long@hp.com>, Mel Gorman <mgorman@suse.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, fengguang.wu@intel.com
Subject: Re: [PATCH] sched: Reduce contention in update_cfs_rq_blocked_load
Message-ID: <20140808000255.GF2480@intel.com>
References: <1407184118.11407.11.camel@j-VirtualBox>
 <20140804191526.GA2480@intel.com>
 <1407349295.2384.14.camel@j-VirtualBox>
 <20140807180239.GC2480@intel.com>
 <1407471532.8365.18.camel@j-VirtualBox>
 <20140807223007.GD2480@intel.com>
 <20140808071103.GD3935@laptop>
 <20140807231535.GE2480@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807231535.GE2480@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 07:15:35AM +0800, Yuyang Du wrote:
> On Fri, Aug 08, 2014 at 09:11:03AM +0200, Peter Zijlstra wrote:
> > On Fri, Aug 08, 2014 at 06:30:08AM +0800, Yuyang Du wrote:
> > > > > > -----------------------------------------------------
> > > > > >               |   10-90   |  100-1000   |  1100-2000
> > > > > >               |   users   |   users     |   users
> > > > > > -----------------------------------------------------
> > > > > > alltests      |   -3.37%  |  -10.64%    |   -2.25%
> > > > > > -----------------------------------------------------
> > > > > > all_utime     |   +0.33%  |   +3.73%    |   +3.33%
> > > > > > -----------------------------------------------------
> > > > > > compute       |   -5.97%  |   +2.34%    |   +3.22%
> > > > > > -----------------------------------------------------
> > > > > > custom        |  -31.61%  |  -10.29%    |  +15.23%
> > > > > > -----------------------------------------------------
> > > > > > disk          |  +24.64%  |  +28.96%    |  +21.28%
> > > > > > -----------------------------------------------------
> > > > > > fserver       |   -1.35%  |   +4.82%    |   +9.35%
> > > > > > -----------------------------------------------------
> > > > > > high_systime  |   -6.73%  |   -6.28%    |  +12.36%
> > > > > > -----------------------------------------------------
> > > > > > shared        |  -28.31%  |  -19.99%    |   -7.10%
> > > > > > -----------------------------------------------------
> > > > > > short         |  -44.63%  |  -37.48%    |  -33.62%
> > > > > > -----------------------------------------------------
> > 
> > > Thanks a lot, Jason.
> > > 
> > > So for this particular set of workloads on a big machine, I think the
> > > result is mixed and overall "neutral", but I expected the variation probably
> > > could be bigger especially for light workloads.
> > > 
> > > Any comment from the maintainers and others? Ping Peter and Ben, I haven't
> > > heard from you for the 5th version.
> > 
> > Been a bit busy.. but in general I worry about the performance decrease
> > on the lighter loads. I should probably run some workloads on my 2
> > socket and 4 socket machines, but the coming few weeks will be very busy
> > and I'm afraid I'll not get around to it in a timely manner.
> 
> Ok. I understand. From our part, Fengguang's LKP does not include light loads,
> we also need some such tests to confirm this and see what is next.
> 
> Since typical benchmarks would be heavy ones, what do you suggest for light loads?
> 
> Jason, possible you can share some of your workloads?
> 
Just heard from Fengguang, LKP has AIM7, which is not private workload. We will do
it. Thanks, Jason.

+Fengguang
