Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab3JGS6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:58:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab3JGS6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:58:17 -0400
Message-ID: <52530438.9060104@redhat.com>
Date: Mon, 07 Oct 2013 14:58:00 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 32/63] sched: Avoid overloading CPUs on a preferred NUMA
 node
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-33-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-33-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:29 AM, Mel Gorman wrote:
> This patch replaces find_idlest_cpu_node with task_numa_find_cpu.
> find_idlest_cpu_node has two critical limitations. It does not take the
> scheduling class into account when calculating the load and it is unsuitable
> for using when comparing loads between NUMA nodes.
> 
> task_numa_find_cpu uses similar load calculations to wake_affine() when
> selecting the least loaded CPU within a scheduling domain common to the
> source and destimation nodes. It avoids causing CPU load imbalances in
> the machine by refusing to migrate if the relative load on the target
> CPU is higher than the source CPU.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
