Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab3G3JEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:04:07 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35949 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3G3JEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:04:01 -0400
Date: Tue, 30 Jul 2013 14:33:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 00/10] Improve numa scheduling by consolidating tasks
Message-ID: <20130730090345.GA22201@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1375170505-5967-1-git-send-email-srikar@linux.vnet.ibm.com>
 <20130730081755.GF3008@twins.programming.kicks-ass.net>
 <20130730082001.GG3008@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130730082001.GG3008@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073009-2398-0000-0000-000000DE5DCA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2013-07-30 10:20:01]:

> On Tue, Jul 30, 2013 at 10:17:55AM +0200, Peter Zijlstra wrote:
> > On Tue, Jul 30, 2013 at 01:18:15PM +0530, Srikar Dronamraju wrote:
> > > Here is an approach that looks to consolidate workloads across nodes.
> > > This results in much improved performance. Again I would assume this work
> > > is complementary to Mel's work with numa faulting.
> > 
> > I highly dislike the use of task weights here. It seems completely
> > unrelated to the problem at hand.
> 
> I also don't particularly like the fact that it's purely process based.
> The faults information we have gives much richer task relations.
> 

With just pure fault information based approach, I am not seeing any
major improvement in tasks/memory consolidation. I still see memory
spread across different nodes and tasks getting ping-ponged to different
nodes. And if there are multiple unrelated processes, then we see a mix
of tasks of different processes in each of the node.

This spreading of load as per my observation, isn't helping the
performance. This is esp true with bigger boxes and would take this as a
hint that we need to consolidate tasks for better performance.

Now I can just use the number of tasks rather than task weights as I do
with the current patchset. But I don't think that would be ideal either.
Esp this wouldn't work with Fair share scheduling.

For example: lets say there are 2 vm's running similar loads on a 2 node
machine. We would get the best performance if we could easily segregate
the load. I know all problems cannot be generalized into just this set.
My thinking is to get atleast these set of problems solved.

Do you see any alternatives other than numa faults/task weights that we
could use to better consolidate tasks?

-- 
Thanks and Regards
Srikar Dronamraju

