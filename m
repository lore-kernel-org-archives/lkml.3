Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaBGVHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:07:17 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:39994 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbaBGVHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:07:15 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 7 Feb 2014 13:07:05 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: David Rientjes <rientjes@google.com>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH 9/9] mm: Remove ifdef condition in include/linux/mm.h
Message-ID: <20140207210705.GB13604@jtriplet-mobl1>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
 <63adb3b97f2869d4c7e76d17ef4aa76b8cf599f3.1391167128.git.rashika.kheria@gmail.com>
 <alpine.DEB.2.02.1402071304080.4212@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402071304080.4212@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 01:04:47PM -0800, David Rientjes wrote:
> On Fri, 7 Feb 2014, Rashika Kheria wrote:
> 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 1cedd00..5f8348f 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1589,10 +1589,8 @@ static inline int __early_pfn_to_nid(unsigned long pfn)
> >  #else
> >  /* please see mm/page_alloc.c */
> >  extern int __meminit early_pfn_to_nid(unsigned long pfn);
> > -#ifdef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
> >  /* there is a per-arch backend function. */
> >  extern int __meminit __early_pfn_to_nid(unsigned long pfn);
> > -#endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
> >  #endif
> >  
> >  extern void set_dma_reserve(unsigned long new_dma_reserve);
> 
> Wouldn't it be better to just declare the __early_pfn_to_nid() in 
> mm/page_alloc.c to be static?

Won't that break the ability to override that function in
architecture-specific code (as arch/ia64/mm/numa.c does)?

- Josh Triplett
