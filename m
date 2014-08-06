Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbaHFSVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:21:41 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:42259 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaHFSVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:21:39 -0400
Message-ID: <1407349295.2384.14.camel@j-VirtualBox>
Subject: Re: [PATCH] sched: Reduce contention in update_cfs_rq_blocked_load
From: Jason Low <jason.low2@hp.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Segall <bsegall@google.com>,
        Waiman Long <Waiman.Long@hp.com>, Mel Gorman <mgorman@suse.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>, Scott J Norton <scott.norton@hp.com>
Date: Wed, 06 Aug 2014 11:21:35 -0700
In-Reply-To: <20140804191526.GA2480@intel.com>
References: <1407184118.11407.11.camel@j-VirtualBox>
	 <20140804191526.GA2480@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-05 at 03:15 +0800, Yuyang Du wrote:
> Hi Jason,
> 
> I am not sure whether you noticed my latest work: rewriting per entity load average
> 
> http://article.gmane.org/gmane.linux.kernel/1760754
> http://article.gmane.org/gmane.linux.kernel/1760755
> http://article.gmane.org/gmane.linux.kernel/1760757
> http://article.gmane.org/gmane.linux.kernel/1760756
> 
> which simply does not track blocked load average at all. Are you interested in
> testing the patchset with the workload you have?

Hi Yuyang,

I ran these tests with most of the AIM7 workloads to compare its
performance between a 3.16 kernel and the kernel with these patches
applied.

The table below contains the percent difference between the baseline
kernel and the kernel with the patches at various user counts. A
positive percent means the kernel with the patches performed better,
while a negative percent means the baseline performed better.

Based on these numbers, for many of the workloads, the change was
beneficial in those highly contended, while it had - impact in many
of the lightly/moderately contended case (10 to 90 users).

-----------------------------------------------------
              |   10-90   |  100-1000   |  1100-2000
              |   users   |   users     |   users
-----------------------------------------------------
alltests      |   -3.37%  |  -10.64%    |   -2.25%
-----------------------------------------------------
all_utime     |   +0.33%  |   +3.73%    |   +3.33%
-----------------------------------------------------
compute       |   -5.97%  |   +2.34%    |   +3.22%
-----------------------------------------------------
custom        |  -31.61%  |  -10.29%    |  +15.23%
-----------------------------------------------------
disk          |  +24.64%  |  +28.96%    |  +21.28%
-----------------------------------------------------
fserver       |   -1.35%  |   +4.82%    |   +9.35%
-----------------------------------------------------
high_systime  |   -6.73%  |   -6.28%    |  +12.36%
-----------------------------------------------------
shared        |  -28.31%  |  -19.99%    |   -7.10%
-----------------------------------------------------
short         |  -44.63%  |  -37.48%    |  -33.62%
-----------------------------------------------------


