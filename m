Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaCGAwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:52:14 -0500
Received: from g4t3427.houston.hp.com ([15.201.208.55]:34861 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaCGAwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:52:13 -0500
Message-ID: <1394153488.2555.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 1/7] x86: mm: clean up tlb flushing code
From: Davidlohr Bueso <davidlohr@hp.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        ak@linux.intel.com, kirill.shutemov@linux.intel.com, mgorman@suse.de,
        alex.shi@linaro.org, x86@kernel.org, linux-mm@kvack.org,
        dave.hansen@linux.intel.com
Date: Thu, 06 Mar 2014 16:51:28 -0800
In-Reply-To: <1394151380.2555.3.camel@buesod1.americas.hpqcorp.net>
References: <20140306004519.BBD70A1A@viggo.jf.intel.com>
	 <20140306004521.5D13DC05@viggo.jf.intel.com>
	 <1394151380.2555.3.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 16:16 -0800, Davidlohr Bueso wrote:
> On Wed, 2014-03-05 at 16:45 -0800, Dave Hansen wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> > 
> > The
> > 
> > 	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
> > 
> > line of code is not exactly the easiest to audit, especially when
> > it ends up at two different indentation levels.  This eliminates
> > one of the the copy-n-paste versions.  It also gives us a unified
> > exit point for each path through this function.  We need this in
> > a minute for our tracepoint.
> > 
> > 
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > ---
> > 
> >  b/arch/x86/mm/tlb.c |   23 +++++++++++------------
> >  1 file changed, 11 insertions(+), 12 deletions(-)
> > 
> > diff -puN arch/x86/mm/tlb.c~simplify-tlb-code arch/x86/mm/tlb.c
> > --- a/arch/x86/mm/tlb.c~simplify-tlb-code	2014-03-05 16:10:09.607047728 -0800
> > +++ b/arch/x86/mm/tlb.c	2014-03-05 16:10:09.610047866 -0800
> > @@ -161,23 +161,24 @@ void flush_tlb_current_task(void)
> >  void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
> >  				unsigned long end, unsigned long vmflag)
> >  {
> > +	int need_flush_others_all = 1;
> 
> nit: this can be bool.

never mind, you get rid of it later.

