Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935888Ab3BOPCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:02:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934192Ab3BOPCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:02:08 -0500
Date: Fri, 15 Feb 2013 16:02:05 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Shijie <b32955@freescale.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: introduce __linear_page_index()
Message-ID: <20130215150205.GC31037@dhcp22.suse.cz>
References: <1360047819-6669-1-git-send-email-b32955@freescale.com>
 <20130205132741.1e1a4e04.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205132741.1e1a4e04.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 05-02-13 13:27:41, Andrew Morton wrote:
[...]
> > +static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
> > +					unsigned long address)
> > +{
> >  	if (unlikely(is_vm_hugetlb_page(vma)))
> >  		return linear_hugepage_index(vma, address);
> > -	pgoff = (address - vma->vm_start) >> PAGE_SHIFT;
> > -	pgoff += vma->vm_pgoff;
> > -	return pgoff >> (PAGE_CACHE_SHIFT - PAGE_SHIFT);
> > +	return __linear_page_index(vma, address) >>
> > +				(PAGE_CACHE_SHIFT - PAGE_SHIFT);
> >  }
> 
> I don't think we need bother creating both linear_page_index() and
> __linear_page_index().  Realistically, we won't be supporting
> PAGE_SHIFT!=PAGE_CACHE_SHIFT.  And most (or all?) of the sites which
> you changed should have been using PAGE_CACHE_SHIFT anyway!

Except for hugetlb (huge_pmd_share, unmap_ref_private) which uses
PAGE_SHIFT to get an index into mapping. History proves there was
some confusion about those in the past (36e4f20a fixing 0c176d52). So
__linear_page_index makes some sense here.

-- 
Michal Hocko
SUSE Labs
