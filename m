Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbaHHHLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:11:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46884 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbaHHHLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:11:11 -0400
Date: Fri, 8 Aug 2014 09:11:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Segall <bsegall@google.com>,
        Waiman Long <Waiman.Long@hp.com>, Mel Gorman <mgorman@suse.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>
Subject: Re: [PATCH] sched: Reduce contention in update_cfs_rq_blocked_load
Message-ID: <20140808071103.GD3935@laptop>
References: <1407184118.11407.11.camel@j-VirtualBox>
 <20140804191526.GA2480@intel.com>
 <1407349295.2384.14.camel@j-VirtualBox>
 <20140807180239.GC2480@intel.com>
 <1407471532.8365.18.camel@j-VirtualBox>
 <20140807223007.GD2480@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807223007.GD2480@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 06:30:08AM +0800, Yuyang Du wrote:
> > > > -----------------------------------------------------
> > > >               |   10-90   |  100-1000   |  1100-2000
> > > >               |   users   |   users     |   users
> > > > -----------------------------------------------------
> > > > alltests      |   -3.37%  |  -10.64%    |   -2.25%
> > > > -----------------------------------------------------
> > > > all_utime     |   +0.33%  |   +3.73%    |   +3.33%
> > > > -----------------------------------------------------
> > > > compute       |   -5.97%  |   +2.34%    |   +3.22%
> > > > -----------------------------------------------------
> > > > custom        |  -31.61%  |  -10.29%    |  +15.23%
> > > > -----------------------------------------------------
> > > > disk          |  +24.64%  |  +28.96%    |  +21.28%
> > > > -----------------------------------------------------
> > > > fserver       |   -1.35%  |   +4.82%    |   +9.35%
> > > > -----------------------------------------------------
> > > > high_systime  |   -6.73%  |   -6.28%    |  +12.36%
> > > > -----------------------------------------------------
> > > > shared        |  -28.31%  |  -19.99%    |   -7.10%
> > > > -----------------------------------------------------
> > > > short         |  -44.63%  |  -37.48%    |  -33.62%
> > > > -----------------------------------------------------

> Thanks a lot, Jason.
> 
> So for this particular set of workloads on a big machine, I think the
> result is mixed and overall "neutral", but I expected the variation probably
> could be bigger especially for light workloads.
> 
> Any comment from the maintainers and others? Ping Peter and Ben, I haven't
> heard from you for the 5th version.

Been a bit busy.. but in general I worry about the performance decrease
on the lighter loads. I should probably run some workloads on my 2
socket and 4 socket machines, but the coming few weeks will be very busy
and I'm afraid I'll not get around to it in a timely manner.
