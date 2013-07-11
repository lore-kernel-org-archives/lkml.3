Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab3GKMmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 08:42:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226Ab3GKMmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 08:42:15 -0400
Date: Thu, 11 Jul 2013 13:42:11 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/16] mm: numa: Do not migrate or account for hinting
 faults on the zero page
Message-ID: <20130711124211.GA2355@suse.de>
References: <1373536020-2799-1-git-send-email-mgorman@suse.de>
 <1373536020-2799-5-git-send-email-mgorman@suse.de>
 <20130711112102.GF25631@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130711112102.GF25631@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 01:21:02PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 11, 2013 at 10:46:48AM +0100, Mel Gorman wrote:
> > +++ b/mm/memory.c
> > @@ -3560,8 +3560,13 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
> >  	set_pte_at(mm, addr, ptep, pte);
> >  	update_mmu_cache(vma, addr, ptep);
> >  
> > +	/*
> > +	 * Do not account for faults against the huge zero page. The read-only
> 
> s/huge //
> 

Whoops, thanks. Guess which comment I wrote first?

-- 
Mel Gorman
SUSE Labs
