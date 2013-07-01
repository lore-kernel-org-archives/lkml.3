Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3GAFj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 01:39:57 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49066 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab3GAFj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 01:39:56 -0400
Date: Mon, 1 Jul 2013 11:09:47 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Basic scheduler support for automatic NUMA balancing
Message-ID: <20130701053947.GQ8362@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <20130628135422.GA21895@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130628135422.GA21895@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070105-7282-0000-0000-000018D4E8BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srikar Dronamraju <srikar@linux.vnet.ibm.com> [2013-06-28 19:24:22]:

> * Mel Gorman <mgorman@suse.de> [2013-06-26 15:37:59]:
> 
> > It's several months overdue and everything was quiet after 3.8 came out
> > but I recently had a chance to revisit automatic NUMA balancing for a few
> > days. I looked at basic scheduler integration resulting in the following
> > small series. Much of the following is heavily based on the numacore series
> > which in itself takes part of the autonuma series from back in November. In
> > particular it borrows heavily from Peter Ziljstra's work in "sched, numa,
> > mm: Add adaptive NUMA affinity support" but deviates too much to preserve
> > Signed-off-bys. As before, if the relevant authors are ok with it I'll
> > add Signed-off-bys (or add them yourselves if you pick the patches up).
> 
> 
> Here is a snapshot of the results of running autonuma-benchmark running on 8
> node 64 cpu system with hyper threading disabled. Ran 5 iterations for each
> setup
> 
> 	KernelVersion: 3.9.0-mainline_v39+()
> 				Testcase:      Min      Max      Avg
> 				  numa01:  1784.16  1864.15  1800.16
> 				  numa02:    32.07    32.72    32.59
> 
> 	KernelVersion: 3.9.0-mainline_v39+() + mel's patches
> 				Testcase:      Min      Max      Avg  %Change
> 				  numa01:  1752.48  1859.60  1785.60    0.82%
> 				  numa02:    47.21    60.58    53.43  -39.00%
> 
> So numa02 case; we see a degradation of around 39%.
> 

I reran the tests again 

KernelVersion: 3.9.0-mainline_v39+()
                        Testcase:      Min      Max      Avg
                          numa01:  1784.16  1864.15  1800.16
             numa01_THREAD_ALLOC:   293.75   315.35   311.03
                          numa02:    32.07    32.72    32.59
                      numa02_SMT:    39.27    39.79    39.69

KernelVersion: 3.9.0-mainline_v39+() + your patches
                        Testcase:      Min      Max      Avg  %Change
                          numa01:  1720.40  1876.89  1767.75    1.83%
             numa01_THREAD_ALLOC:   464.34   554.82   496.64  -37.37%
                          numa02:    52.02    58.57    56.21  -42.02%
                      numa02_SMT:    42.07    52.64    47.33  -16.14%


-- 
Thanks and Regards
Srikar Dronamraju

