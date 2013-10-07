Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3JGTOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:14:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab3JGTOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:14:22 -0400
Message-ID: <52530800.1070902@redhat.com>
Date: Mon, 07 Oct 2013 15:14:08 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 55/63] sched: numa: Avoid migrating tasks that are placed
 on their preferred node
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-56-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-56-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:29 AM, Mel Gorman wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> This patch classifies scheduler domains and runqueues into types depending
> the number of tasks that are about their NUMA placement and the number
> that are currently running on their preferred node. The types are
> 
> regular: There are tasks running that do not care about their NUMA
> 	placement.
> 
> remote: There are tasks running that care about their placement but are
> 	currently running on a node remote to their ideal placement
> 
> all: No distinction
> 
> To implement this the patch tracks the number of tasks that are optimally
> NUMA placed (rq->nr_preferred_running) and the number of tasks running
> that care about their placement (nr_numa_running). The load balancer
> uses this information to avoid migrating idea placed NUMA tasks as long
> as better options for load balancing exists. For example, it will not
> consider balancing between a group whose tasks are all perfectly placed
> and a group with remote tasks.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
