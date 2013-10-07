Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3JGTKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:10:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab3JGTKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:10:22 -0400
Message-ID: <525306DE.4090102@redhat.com>
Date: Mon, 07 Oct 2013 15:09:18 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 43/63] sched: numa: Use {cpu, pid} to create task groups
 for shared faults
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-44-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-44-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:29 AM, Mel Gorman wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> While parallel applications tend to align their data on the cache
> boundary, they tend not to align on the page or THP boundary.
> Consequently tasks that partition their data can still "false-share"
> pages presenting a problem for optimal NUMA placement.
> 
> This patch uses NUMA hinting faults to chain tasks together into
> numa_groups. As well as storing the NID a task was running on when
> accessing a page a truncated representation of the faulting PID is
> stored. If subsequent faults are from different PIDs it is reasonable
> to assume that those two tasks share a page and are candidates for
> being grouped together. Note that this patch makes no scheduling
> decisions based on the grouping information.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
