Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab3JGTMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:12:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab3JGTMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:12:00 -0400
Message-ID: <52530772.3080808@redhat.com>
Date: Mon, 07 Oct 2013 15:11:46 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 47/63] mm: numa: Do not batch handle PMD pages
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-48-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-48-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:29 AM, Mel Gorman wrote:
> With the THP migration races closed it is still possible to occasionally
> see corruption. The problem is related to handling PMD pages in batch.
> When a page fault is handled it can be assumed that the page being
> faulted will also be flushed from the TLB. The same flushing does not
> happen when handling PMD pages in batch. Fixing is straight forward but
> there are a number of reasons not to
> 
> 1. Multiple TLB flushes may have to be sent depending on what pages get
>    migrated
> 2. The handling of PMDs in batch means that faults get accounted to
>    the task that is handling the fault. While care is taken to only
>    mark PMDs where the last CPU and PID match it can still have problems
>    due to PID truncation when matching PIDs.
> 3. Batching on the PMD level may reduce faults but setting pmd_numa
>    requires taking a heavy lock that can contend with THP migration
>    and handling the fault requires the release/acquisition of the PTL
>    for every page migrated. It's still pretty heavy.
> 
> PMD batch handling is not something that people ever have been happy
> with. This patch removes it and later patches will deal with the
> additional fault overhead using more installigent migrate rate adaption.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
