Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbaDHWvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 18:51:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252AbaDHWvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 18:51:04 -0400
Date: Tue, 8 Apr 2014 15:51:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mtosatti@redhat.com, aarcange@redhat.com,
        mgorman@suse.de, andi@firstfloor.org, davidlohr@hp.com,
        rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        yinghai@kernel.org, riel@redhat.com
Subject: Re: [PATCH 4/4] hugetlb: add support for gigantic page allocation
 at runtime
Message-Id: <20140408155102.d55e3b798681e316d957f383@linux-foundation.org>
In-Reply-To: <20140407144935.259d4301@redhat.com>
References: <1396462128-32626-1-git-send-email-lcapitulino@redhat.com>
	<1396462128-32626-5-git-send-email-lcapitulino@redhat.com>
	<1396893509-x52fgnka@n-horiguchi@ah.jp.nec.com>
	<20140407144935.259d4301@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2014 14:49:35 -0400 Luiz Capitulino <lcapitulino@redhat.com> wrote:

> > > ---
> > >  arch/x86/include/asm/hugetlb.h |  10 +++
> > >  mm/hugetlb.c                   | 177 ++++++++++++++++++++++++++++++++++++++---
> > >  2 files changed, 176 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/hugetlb.h b/arch/x86/include/asm/hugetlb.h
> > > index a809121..2b262f7 100644
> > > --- a/arch/x86/include/asm/hugetlb.h
> > > +++ b/arch/x86/include/asm/hugetlb.h
> > > @@ -91,6 +91,16 @@ static inline void arch_release_hugepage(struct page *page)
> > >  {
> > >  }
> > >  
> > > +static inline int arch_prepare_gigantic_page(struct page *page)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > > +static inline void arch_release_gigantic_page(struct page *page)
> > > +{
> > > +}
> > > +
> > > +
> > >  static inline void arch_clear_hugepage_flags(struct page *page)
> > >  {
> > >  }
> > 
> > These are defined only on arch/x86, but called in generic code.
> > Does it cause build failure on other archs?
> 
> Hmm, probably. The problem here is that I'm unable to test this
> code in other archs. So I think the best solution for the first
> merge is to make the build of this feature conditional to x86_64?
> Then the first person interested in making this work in other
> archs add the generic code. Sounds reasonable?

These functions don't actually do anything so if and when other
architectures come along to implement this feature, their developers
won't know what you were thinking when you added them.  So how about
some code comments to explain their roles and responsibilities?

Or just delete them altogether and let people add them (or something
similar) if and when the need arises.  It's hard to tell when one lacks
telepathic powers, sigh.
