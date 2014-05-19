Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaESDV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 23:21:59 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62292 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaESDV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 23:21:58 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 19 May 2014 12:24:41 +0900
From: Minchan Kim <minchan@kernel.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dave Hansen <dave.hansen@intel.com>,
        John Stultz <john.stultz@linaro.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>
Subject: Re: [PATCH v6] mm: support madvise(MADV_FREE)
Message-ID: <20140519032441.GB13248@bbox>
References: <1399857988-2880-1-git-send-email-minchan@kernel.org>
 <20140515154657.GA2720@cmpxchg.org>
 <20140516063427.GC27599@bbox>
 <20140516193800.GA7273@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516193800.GA7273@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 10:38:00PM +0300, Kirill A. Shutemov wrote:
> On Fri, May 16, 2014 at 03:34:27PM +0900, Minchan Kim wrote:
> > > > +static inline unsigned long lazyfree_pmd_range(struct mmu_gather *tlb,
> > > > +				struct vm_area_struct *vma, pud_t *pud,
> > > > +				unsigned long addr, unsigned long end)
> > > > +{
> > > > +	pmd_t *pmd;
> > > > +	unsigned long next;
> > > > +
> > > > +	pmd = pmd_offset(pud, addr);
> > > > +	do {
> > > > +		next = pmd_addr_end(addr, end);
> > > > +		if (pmd_trans_huge(*pmd))
> > > > +			split_huge_page_pmd(vma, addr, pmd);
> > > 
> > > /* XXX */ as well? :)
> > 
> > You meant huge page unit lazyfree rather than 4K page unit?
> > If so, I will add.
> 
> Please, free huge page if range cover it. 


Yeb, We could do further patches if current patch's design is done
from reviewers.

Thanks.

> 
> -- 
>  Kirill A. Shutemov
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
