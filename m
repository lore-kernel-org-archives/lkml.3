Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab3GFKp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 06:45:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40679 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab3GFKp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 06:45:27 -0400
Date: Sat, 6 Jul 2013 12:44:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/15] sched: Set preferred NUMA node based on number of
 private faults
Message-ID: <20130706104446.GS18898@dyad.programming.kicks-ass.net>
References: <1373065742-9753-1-git-send-email-mgorman@suse.de>
 <1373065742-9753-14-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373065742-9753-14-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 12:09:00AM +0100, Mel Gorman wrote:
> The third reason is that multiple threads in a process will race each
> other to fault the shared page making the fault information unreliable.

Ingo and I played around with that particular issue for a while and we had a
patch that worked fairly well for cpu bound threads and made sure the
task_numa_work() thing indeed interleaved between the threads and wasn't done
by the same thread every time.

I don't know what the current code does and if that is indeed still an issue.
