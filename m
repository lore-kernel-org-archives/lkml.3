Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbaHHCFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 22:05:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:5085 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbaHHCE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 22:04:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,821,1400050800"; 
   d="scan'208";a="466316403"
Date: Fri, 8 Aug 2014 02:02:39 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Jason Low <jason.low2@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Segall <bsegall@google.com>,
        Waiman Long <Waiman.Long@hp.com>, Mel Gorman <mgorman@suse.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>, Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH] sched: Reduce contention in update_cfs_rq_blocked_load
Message-ID: <20140807180239.GC2480@intel.com>
References: <1407184118.11407.11.camel@j-VirtualBox>
 <20140804191526.GA2480@intel.com>
 <1407349295.2384.14.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407349295.2384.14.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 11:21:35AM -0700, Jason Low wrote:
> I ran these tests with most of the AIM7 workloads to compare its
> performance between a 3.16 kernel and the kernel with these patches
> applied.
> 
> The table below contains the percent difference between the baseline
> kernel and the kernel with the patches at various user counts. A
> positive percent means the kernel with the patches performed better,
> while a negative percent means the baseline performed better.
> 
> Based on these numbers, for many of the workloads, the change was
> beneficial in those highly contended, while it had - impact in many
> of the lightly/moderately contended case (10 to 90 users).
> 
> -----------------------------------------------------
>               |   10-90   |  100-1000   |  1100-2000
>               |   users   |   users     |   users
> -----------------------------------------------------
> alltests      |   -3.37%  |  -10.64%    |   -2.25%
> -----------------------------------------------------
> all_utime     |   +0.33%  |   +3.73%    |   +3.33%
> -----------------------------------------------------
> compute       |   -5.97%  |   +2.34%    |   +3.22%
> -----------------------------------------------------
> custom        |  -31.61%  |  -10.29%    |  +15.23%
> -----------------------------------------------------
> disk          |  +24.64%  |  +28.96%    |  +21.28%
> -----------------------------------------------------
> fserver       |   -1.35%  |   +4.82%    |   +9.35%
> -----------------------------------------------------
> high_systime  |   -6.73%  |   -6.28%    |  +12.36%
> -----------------------------------------------------
> shared        |  -28.31%  |  -19.99%    |   -7.10%
> -----------------------------------------------------
> short         |  -44.63%  |  -37.48%    |  -33.62%
> -----------------------------------------------------
> 
Thanks, Jason. Sorry for late response.

What about the variation of the tests? The machine you test on?

Yuyang
