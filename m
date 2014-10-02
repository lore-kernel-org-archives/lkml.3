Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbaJBOLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:11:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:46557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbaJBOLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:11:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,638,1406617200"; 
   d="scan'208";a="481506774"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20141001130523.d7cf46e735089d681194e8e6@linux-foundation.org>
References: <1412163121-4295-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20141001130523.d7cf46e735089d681194e8e6@linux-foundation.org>
Subject: Re: [PATCH 1/3] mm: generalize VM_BUG_ON() macros
Content-Transfer-Encoding: 7bit
Message-Id: <20141002141133.B56A6E00A3@blue.fi.intel.com>
Date: Thu,  2 Oct 2014 17:11:33 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed,  1 Oct 2014 14:31:59 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> 
> > This patch makes VM_BUG_ON() to accept one to three arguments after the
> > condition. Any of these arguments can be page, vma or mm. VM_BUG_ON()
> > will dump info about the argument using appropriate dump_* function.
> > 
> > It's intended to replace separate VM_BUG_ON_PAGE(), VM_BUG_ON_VMA(),
> > VM_BUG_ON_MM() and allows additional use-cases like:
> > 
> >   VM_BUG_ON(cond, vma, page);
> >   VM_BUG_ON(cond, vma, src_page, dst_page);
> >   VM_BUG_ON(cond, mm, src_vma, dst_vma);
> >   ...
> 
> I can't say I'm a fan of this.  We don't do this sort of thing anywhere
> else in the kernel and passing different types to the same thing in
> different places is unusual and exceptional.  We gain very little from
> this so why bother?

We had bug like this: lkml.kernel.org/r/53F487EB.7070703@oracle.com where
it's useful to see more than one structure dumped: vma + page in this
case.

We can keep inventing new macros: VM_BUG_ON_PAGE_AND_VM() for the case.
But why not have one to rule them all? ;)

-- 
 Kirill A. Shutemov
