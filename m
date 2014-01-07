Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaAGIea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:34:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbaAGIe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:34:29 -0500
Date: Tue, 7 Jan 2014 09:34:25 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Bob Liu <lliubbo@gmail.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bob Liu <bob.liu@oracle.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: could you clarify mm/mempolicy: fix !vma in new_vma_page()
Message-ID: <20140107083425.GB8756@dhcp22.suse.cz>
References: <20140106112422.GA27602@dhcp22.suse.cz>
 <CAA_GA1dNdrG9aQ3UKDA0O=BY721rvseORVkc2+RxUpzysp3rYw@mail.gmail.com>
 <20140106141827.GB27602@dhcp22.suse.cz>
 <52cb81ed.e3d8420a.72a1.ffffea65SMTPIN_ADDED_BROKEN@mx.google.com>
 <52cb83e3.c9903c0a.614e.1751SMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52cb83e3.c9903c0a.614e.1751SMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 07-01-14 12:34:34, Wanpeng Li wrote:
> Cced Sasha,
> On Tue, Jan 07, 2014 at 12:26:13PM +0800, Wanpeng Li wrote:
> >Hi Michal,
> >On Mon, Jan 06, 2014 at 03:18:27PM +0100, Michal Hocko wrote:
> >>On Mon 06-01-14 20:45:54, Bob Liu wrote:
> >>[...]
> >>>  544         if (PageAnon(page)) {
> >>>  545                 struct anon_vma *page__anon_vma = page_anon_vma(page);
> >>>  546                 /*
> >>>  547                  * Note: swapoff's unuse_vma() is more efficient with this
> >>>  548                  * check, and needs it to match anon_vma when KSM is active.
> >>>  549                  */
> >>>  550                 if (!vma->anon_vma || !page__anon_vma ||
> >>>  551                     vma->anon_vma->root != page__anon_vma->root)
> >>>  552                         return -EFAULT;
> >>>  553         } else if (page->mapping && !(vma->vm_flags & VM_NONLINEAR)) {
> >>>  554                 if (!vma->vm_file ||
> >>>  555                     vma->vm_file->f_mapping != page->mapping)
> >>>  556                         return -EFAULT;
> >>>  557         } else
> >>>  558                 return -EFAULT;
> >>> 
> >>> That's the "other conditions" and the reason why we can't use
> >>> BUG_ON(!vma) in new_vma_page().
> >>
> >>Sorry, I wasn't clear with my question. I was interested in which of
> >>these triggered and why only for hugetlb pages?
> >
> >Not just for hugetlb pages, sorry for do two things in one patch. The change 
> >for hugetlb pages is to fix the potential dereference NULL pointer reported 
> >by Dan. http://marc.info/?l=linux-mm&m=137689530323257&w=2 
> >
> >If we should ask Sasha to add more debug information to dump which condition 
> >is failed in page_address_in_vma() for you?

I am always more calm when the removed BUG_ON is properly understood and
justified.
-- 
Michal Hocko
SUSE Labs
