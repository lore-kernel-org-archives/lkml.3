Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3IPMhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:37:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49431 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3IPMhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:37:03 -0400
Date: Mon, 16 Sep 2013 14:36:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/50] mm: Account for a THP NUMA hinting update as one
 PTE update
Message-ID: <20130916123645.GD9326@twins.programming.kicks-ass.net>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
 <1378805550-29949-8-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378805550-29949-8-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 10:31:47AM +0100, Mel Gorman wrote:
> A THP PMD update is accounted for as 512 pages updated in vmstat.  This is
> large difference when estimating the cost of automatic NUMA balancing and
> can be misleading when comparing results that had collapsed versus split
> THP. This patch addresses the accounting issue.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  mm/mprotect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 94722a4..2bbb648 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -145,7 +145,7 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
>  				split_huge_page_pmd(vma, addr, pmd);
>  			else if (change_huge_pmd(vma, pmd, addr, newprot,
>  						 prot_numa)) {
> -				pages += HPAGE_PMD_NR;
> +				pages++;

But now you're not counting pages anymore..
