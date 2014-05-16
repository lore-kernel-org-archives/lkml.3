Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992494AbaEPTis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:38:48 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:48104 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992428AbaEPTir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:38:47 -0400
Date: Fri, 16 May 2014 22:38:00 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Minchan Kim <minchan@kernel.org>
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
Message-ID: <20140516193800.GA7273@node.dhcp.inet.fi>
References: <1399857988-2880-1-git-send-email-minchan@kernel.org>
 <20140515154657.GA2720@cmpxchg.org>
 <20140516063427.GC27599@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516063427.GC27599@bbox>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 03:34:27PM +0900, Minchan Kim wrote:
> > > +static inline unsigned long lazyfree_pmd_range(struct mmu_gather *tlb,
> > > +				struct vm_area_struct *vma, pud_t *pud,
> > > +				unsigned long addr, unsigned long end)
> > > +{
> > > +	pmd_t *pmd;
> > > +	unsigned long next;
> > > +
> > > +	pmd = pmd_offset(pud, addr);
> > > +	do {
> > > +		next = pmd_addr_end(addr, end);
> > > +		if (pmd_trans_huge(*pmd))
> > > +			split_huge_page_pmd(vma, addr, pmd);
> > 
> > /* XXX */ as well? :)
> 
> You meant huge page unit lazyfree rather than 4K page unit?
> If so, I will add.

Please, free huge page if range cover it. 

-- 
 Kirill A. Shutemov
