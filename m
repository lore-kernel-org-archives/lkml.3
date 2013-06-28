Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab3F1NAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:00:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab3F1NAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:00:07 -0400
Date: Fri, 28 Jun 2013 14:00:03 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] sched: Favour moving tasks towards the preferred node
Message-ID: <20130628130003.GV1875@suse.de>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-6-git-send-email-mgorman@suse.de>
 <20130627145345.GT28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130627145345.GT28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 04:53:45PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 26, 2013 at 03:38:04PM +0100, Mel Gorman wrote:
> > This patch favours moving tasks towards the preferred NUMA node when
> > it has just been selected. Ideally this is self-reinforcing as the
> > longer the the task runs on that node, the more faults it should incur
> > causing task_numa_placement to keep the task running on that node. In
> > reality a big weakness is that the nodes CPUs can be overloaded and it
> > would be more effficient to queue tasks on an idle node and migrate to
> > the new node. This would require additional smarts in the balancer so
> > for now the balancer will simply prefer to place the task on the
> > preferred node for a tunable number of PTE scans.
> 
> This changelog fails to mention why you're adding the settle stuff in
> this patch.

Updated the change.

This patch favours moving tasks towards the preferred NUMA node when it
has just been selected. Ideally this is self-reinforcing as the longer
the task runs on that node, the more faults it should incur causing
task_numa_placement to keep the task running on that node. In reality
a big weakness is that the nodes CPUs can be overloaded and it would be
more efficient to queue tasks on an idle node and migrate to the new node.
This would require additional smarts in the balancer so for now the balancer
will simply prefer to place the task on the preferred node for a PTE scans
which is controlled by the numa_balancing_settle_count sysctl. Once the
settle_count number of scans has complete the schedule is free to place
the task on an alternative node if the load is imbalanced.

-- 
Mel Gorman
SUSE Labs
