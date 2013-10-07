Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3JGRol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:44:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab3JGRoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:44:39 -0400
Message-ID: <5252F2FA.1020201@redhat.com>
Date: Mon, 07 Oct 2013 13:44:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/63] sched: Set the scan rate proportional to the memory
 usage of the task being scanned
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-18-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-18-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:28 AM, Mel Gorman wrote:
> The NUMA PTE scan rate is controlled with a combination of the
> numa_balancing_scan_period_min, numa_balancing_scan_period_max and
> numa_balancing_scan_size. This scan rate is independent of the size
> of the task and as an aside it is further complicated by the fact that
> numa_balancing_scan_size controls how many pages are marked pte_numa and
> not how much virtual memory is scanned.
> 
> In combination, it is almost impossible to meaningfully tune the min and
> max scan periods and reasoning about performance is complex when the time
> to complete a full scan is is partially a function of the tasks memory
> size. This patch alters the semantic of the min and max tunables to be
> about tuning the length time it takes to complete a scan of a tasks occupied
> virtual address space. Conceptually this is a lot easier to understand. There
> is a "sanity" check to ensure the scan rate is never extremely fast based on
> the amount of virtual memory that should be scanned in a second. The default
> of 2.5G seems arbitrary but it is to have the maximum scan rate after the
> patch roughly match the maximum scan rate before the patch was applied.
> 
> On a similar note, numa_scan_period is in milliseconds and not
> jiffies. Properly placed pages slow the scanning rate but adding 10 jiffies
> to numa_scan_period means that the rate scanning slows depends on HZ which
> is confusing. Get rid of the jiffies_to_msec conversion and treat it as ms.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
