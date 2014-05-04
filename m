Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaEDUjD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 16:39:03 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60218 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaEDUjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 16:39:02 -0400
Date: Sun, 4 May 2014 13:37:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Richard Weinberger <richard.weinberger@gmail.com>
cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [3.15rc1] BUG at mm/filemap.c:202!
In-Reply-To: <CAFLxGvxPV9+BgP=CVEp4kLbedOYBEui9uYddNTDix=ENrrusoQ@mail.gmail.com>
Message-ID: <alpine.LSU.2.11.1405041311130.3230@eggly.anvils>
References: <20140415190936.GA24654@redhat.com> <alpine.LSU.2.11.1404161239320.6778@eggly.anvils> <CAFLxGvxZxWf6nzJ5cXM--b02axz9u8UL_MTUyo3WgLPvbpCFAg@mail.gmail.com> <CAFLxGvxPV9+BgP=CVEp4kLbedOYBEui9uYddNTDix=ENrrusoQ@mail.gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2014, Richard Weinberger wrote:
> On Thu, May 1, 2014 at 6:20 PM, Richard Weinberger
> <richard.weinberger@gmail.com> wrote:
> > On Wed, Apr 16, 2014 at 10:40 PM, Hugh Dickins <hughd@google.com> wrote:
> >>
> >> Help!
> >
> > Using a trinity as of today I'm able to trigger this bug on UML within seconds.
> > If you want me to test patch, I can help.
> >
> > I'm also observing one strange fact, I can trigger this on any kernel version.
> > So far I've managed UML to crash on 3.0 to 3.15-rc...
> 
> After digging deeper into UML's mmu and tlb code I've found issues and
> fixed them.
> 
> But I'm still facing this issue. Although triggering the BUG_ON() is
> not so easy as before
> I can trigger "BUG: Bad rss-counter ..." very easily.
> Now the interesting fact, with my UML mmu and flb fixes applied it
> happens only on kernels >= 3.14.
> If it helps I can try to bisect it.

Thanks a lot for trying, but from other mail it looks like your
bisection got blown off course ;(

I expect for the moment you'll want to concentrate on getting UML's
TLB flushing back on track with 3.15-rc.

Once you have that sorted out, I wouldn't be surprised if the same
changes turn out to fix your "Bad rss-counter"s on 3.14 also.

If not, and if you do still have time to bisect back between 3.13 and
3.14 to find where things went wrong, it will be a bit tedious in that
you would probably have to apply

887843961c4b "mm: fix bad rss-counter if remap_file_pages raced migration"
7e09e738afd2 "mm: fix swapops.h:131 bug if remap_file_pages raced migration"

at each stage, to avoid those now-known bugs which trinity became rather
good at triggering.  Perhaps other fixes needed, those the two I remember.

Please don't worry if you don't have time for this, that's understandable.

Or is UML so contrary that one of those commits actually brings on the
problem for you?

As to the BUG_ON(page_mapped(page)), I still have nothing to suggest.

Hugh
