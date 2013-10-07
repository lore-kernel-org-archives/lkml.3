Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab3JGRYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:24:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab3JGRYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:24:45 -0400
Message-ID: <5252EE4A.1060904@redhat.com>
Date: Mon, 07 Oct 2013 13:24:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/63] sched: numa: Mitigate chance that same task always
 updates PTEs
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-14-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-14-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:28 AM, Mel Gorman wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> With a trace_printk("working\n"); right after the cmpxchg in
> task_numa_work() we can see that of a 4 thread process, its always the
> same task winning the race and doing the protection change.
> 
> This is a problem since the task doing the protection change has a
> penalty for taking faults -- it is busy when marking the PTEs. If its
> always the same task the ->numa_faults[] get severely skewed.
> 
> Avoid this by delaying the task doing the protection change such that
> it is unlikely to win the privilege again.

> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
