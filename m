Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3F1KM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:12:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50757 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab3F1KM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:12:56 -0400
Date: Fri, 28 Jun 2013 15:42:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] sched: Split accounting of NUMA hinting faults that
 pass two-stage filter
Message-ID: <20130628101245.GD8362@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-8-git-send-email-mgorman@suse.de>
 <20130628070027.GD17195@linux.vnet.ibm.com>
 <20130628093625.GF29209@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130628093625.GF29209@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062810-0320-0000-0000-00000015EF51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > > Ideally it would be possible to distinguish between NUMA hinting faults
> > > that are private to a task and those that are shared. This would require
> > > that the last task that accessed a page for a hinting fault would be
> > > recorded which would increase the size of struct page. Instead this patch
> > > approximates private pages by assuming that faults that pass the two-stage
> > > filter are private pages and all others are shared. The preferred NUMA
> > > node is then selected based on where the maximum number of approximately
> > > private faults were measured.
> > 
> > Should we consider only private faults for preferred node?
> 
> I don't think so; its optimal for the task to be nearest most of its pages;
> irrespective of whether they be private or shared.

Then the preferred node should have been chosen based on both the
private and shared faults and not just private faults.

> 
> > I would think if tasks have shared pages then moving all tasks that share
> > the same pages to a node where the share pages are around would be
> > preferred. No? 
> 
> Well no; not if there's only 5 shared pages but 1024 private pages.

Yes, agree, but should we try to give the shared pages some additional weightage?

-- 
Thanks and Regards
Srikar Dronamraju

