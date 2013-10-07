Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab3JGOCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 10:02:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab3JGOCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 10:02:31 -0400
Message-ID: <5252BEE4.20707@redhat.com>
Date: Mon, 07 Oct 2013 10:02:12 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/63] mm: numa: Sanitize task_numa_fault() callsites
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-8-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-8-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:28 AM, Mel Gorman wrote:
> There are three callers of task_numa_fault():
> 
>  - do_huge_pmd_numa_page():
>      Accounts against the current node, not the node where the
>      page resides, unless we migrated, in which case it accounts
>      against the node we migrated to.
> 
>  - do_numa_page():
>      Accounts against the current node, not the node where the
>      page resides, unless we migrated, in which case it accounts
>      against the node we migrated to.
> 
>  - do_pmd_numa_page():
>      Accounts not at all when the page isn't migrated, otherwise
>      accounts against the node we migrated towards.
> 
> This seems wrong to me; all three sites should have the same
> sementaics, furthermore we should accounts against where the page
> really is, we already know where the task is.
> 
> So modify all three sites to always account; we did after all receive
> the fault; and always account to where the page is after migration,
> regardless of success.
> 
> They all still differ on when they clear the PTE/PMD; ideally that
> would get sorted too.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
