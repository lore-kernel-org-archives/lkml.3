Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbaGHTF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:05:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198AbaGHTFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:05:24 -0400
Date: Tue, 8 Jul 2014 15:03:26 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>,
        Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Kees Cook <kees@outflux.net>
Subject: Re: [PATCH v3 1/3] mm: introduce fincore()
Message-ID: <20140708190326.GA28595@nhori>
References: <1404756006-23794-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1404756006-23794-2-git-send-email-n-horiguchi@ah.jp.nec.com>
 <53BAEE95.50807@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BAEE95.50807@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 12:01:41PM -0700, Dave Hansen wrote:
> > +/*
> > + * You can control how the buffer in userspace is filled with this mode
> > + * parameters:
> 
> I agree that we don't have any good mechanisms for looking at the page
> cache from userspace.  I've hacked some things up using mincore() and
> they weren't pretty, so I welcome _something_ like this.
> 
> But, is this trying to do too many things at once?  Do we have solid use
> cases spelled out for each of these modes?  Have we thought out how they
> will be used in practice?
> 
> The biggest question for me, though, is whether we want to start
> designing these per-page interfaces to consider different page sizes, or
> whether we're going to just continue to pretend that the entire world is
> 4k pages.  Using FINCORE_BMAP on 1GB hugetlbfs files would be a bit
> silly, for instance.

I didn't answer this question, sorry.

In my option, hugetlbfs pages should be handled as one hugepage (not as
many 4kB pages) to avoid lots of meaningless data transfer, as you pointed
out. And the current patch already works like that.

Thanks,
Naoya Horiguchi
