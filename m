Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab3F1JhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:37:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46604 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3F1Jg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:36:58 -0400
Date: Fri, 28 Jun 2013 11:36:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] sched: Split accounting of NUMA hinting faults that
 pass two-stage filter
Message-ID: <20130628093625.GF29209@dyad.programming.kicks-ass.net>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-8-git-send-email-mgorman@suse.de>
 <20130628070027.GD17195@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628070027.GD17195@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 12:30:27PM +0530, Srikar Dronamraju wrote:
> * Mel Gorman <mgorman@suse.de> [2013-06-26 15:38:06]:
> 
> > Ideally it would be possible to distinguish between NUMA hinting faults
> > that are private to a task and those that are shared. This would require
> > that the last task that accessed a page for a hinting fault would be
> > recorded which would increase the size of struct page. Instead this patch
> > approximates private pages by assuming that faults that pass the two-stage
> > filter are private pages and all others are shared. The preferred NUMA
> > node is then selected based on where the maximum number of approximately
> > private faults were measured.
> 
> Should we consider only private faults for preferred node?

I don't think so; its optimal for the task to be nearest most of its pages;
irrespective of whether they be private or shared.

> I would think if tasks have shared pages then moving all tasks that share
> the same pages to a node where the share pages are around would be
> preferred. No? 

Well no; not if there's only 5 shared pages but 1024 private pages.

> If yes, how does the preferred node logic help to achieve
> the above?

There's no packing logic yet...
