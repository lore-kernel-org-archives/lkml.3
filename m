Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab3LLXxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:53:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab3LLXxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:53:50 -0500
Date: Thu, 12 Dec 2013 23:53:46 +0000
From: Mel Gorman <mgorman@suse.de>
To: Alex Shi <alex.shi@linaro.org>
Cc: H Peter Anvin <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: mm: Clean up inconsistencies when flushing TLB
 ranges
Message-ID: <20131212235237.GK11295@suse.de>
References: <1386849309-22584-1-git-send-email-mgorman@suse.de>
 <1386849309-22584-2-git-send-email-mgorman@suse.de>
 <52A9C145.9050706@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <52A9C145.9050706@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 09:59:33PM +0800, Alex Shi wrote:
> On 12/12/2013 07:55 PM, Mel Gorman wrote:
> > NR_TLB_LOCAL_FLUSH_ALL is not always accounted for correctly and the
> > comparison with total_vm is done before taking tlb_flushall_shift into
> > account. Clean it up.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> Reviewed-by: Alex Shi

Thanks.

> > ---
> >  arch/x86/mm/tlb.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> > index ae699b3..09b8cb8 100644
> > --- a/arch/x86/mm/tlb.c
> > +++ b/arch/x86/mm/tlb.c
> > @@ -189,6 +189,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
> >  {
> >  	unsigned long addr;
> >  	unsigned act_entries, tlb_entries = 0;
> > +	unsigned long nr_base_pages;
> >  
> >  	preempt_disable();
> >  	if (current->active_mm != mm)
> > @@ -210,18 +211,17 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
> >  		tlb_entries = tlb_lli_4k[ENTRIES];
> >  	else
> >  		tlb_entries = tlb_lld_4k[ENTRIES];
> > +
> >  	/* Assume all of TLB entries was occupied by this task */
> 
> the benchmark break this assumption?

No, but it's a small benchmark with very little else running at the
time. It's an assumption that would only hold true on dedicated machines
to a single application. It would not hold true on desktops, multi-tier
server applications etc.

-- 
Mel Gorman
SUSE Labs
