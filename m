Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab3JGTHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:07:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756491Ab3JGTHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:07:32 -0400
Message-ID: <52530665.5060805@redhat.com>
Date: Mon, 07 Oct 2013 15:07:17 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 39/63] sched: numa: Use a system-wide search to find swap/migration
 candidates
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-40-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-40-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:29 AM, Mel Gorman wrote:
> This patch implements a system-wide search for swap/migration candidates
> based on total NUMA hinting faults. It has a balance limit, however it
> doesn't properly consider total node balance.
> 
> In the old scheme a task selected a preferred node based on the highest
> number of private faults recorded on the node. In this scheme, the preferred
> node is based on the total number of faults. If the preferred node for a
> task changes then task_numa_migrate will search the whole system looking
> for tasks to swap with that would improve both the overall compute
> balance and minimise the expected number of remote NUMA hinting faults.
> 
> Not there is no guarantee that the node the source task is placed
> on by task_numa_migrate() has any relationship to the newly selected
> task->numa_preferred_nid due to compute overloading.
> 
> [riel@redhat.com: Do not swap with tasks that cannot run on source cpu]
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
