Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab3GaLZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:25:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab3GaLZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:25:15 -0400
Date: Wed, 31 Jul 2013 12:25:10 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm, numa: Sanitize task_numa_fault() callsites
Message-ID: <20130731112510.GS2296@suse.de>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <20130725103845.GN27075@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130725103845.GN27075@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 12:38:45PM +0200, Peter Zijlstra wrote:
> 
> Subject: mm, numa: Sanitize task_numa_fault() callsites
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Mon Jul 22 10:42:38 CEST 2013
> 
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

Agreed. To allow the scheduler parts to still be evaluated in proper
isolation I moved this patch to much earlier in the series.

-- 
Mel Gorman
SUSE Labs
