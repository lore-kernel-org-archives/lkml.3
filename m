Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbaCSCiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 22:38:03 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:44804 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaCSCiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 22:38:01 -0400
Date: Tue, 18 Mar 2014 19:37:01 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bob Liu <bob.liu@oracle.com>, Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: bad rss-counter message in 3.14rc5
In-Reply-To: <CA+55aFxVG7HLmsvCzoiA7PBRPvX3utRfyVGrBs6gVLZ-fUCuPQ@mail.gmail.com>
Message-ID: <alpine.LSU.2.11.1403181928370.3499@eggly.anvils>
References: <20140311045109.GB12551@redhat.com> <20140310220158.7e8b7f2a.akpm@linux-foundation.org> <20140311053017.GB14329@redhat.com> <20140311132024.GC32390@moon> <531F0E39.9020100@oracle.com> <20140311134158.GD32390@moon> <20140311142817.GA26517@redhat.com>
 <20140311143750.GE32390@moon> <20140311171045.GA4693@redhat.com> <20140311173603.GG32390@moon> <20140311173917.GB4693@redhat.com> <alpine.LSU.2.11.1403181703470.7055@eggly.anvils> <CA+55aFx0ZyCVrkosgTongBrNX6mJM4B8+QZQE1p0okk8ubbv7g@mail.gmail.com>
 <alpine.LSU.2.11.1403181848380.3318@eggly.anvils> <CA+55aFxVG7HLmsvCzoiA7PBRPvX3utRfyVGrBs6gVLZ-fUCuPQ@mail.gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Linus Torvalds wrote:
> On Tue, Mar 18, 2014 at 7:06 PM, Hugh Dickins <hughd@google.com> wrote:
> >
> > I'd love that, if we can get away with it now: depends very
> > much on whether we then turn out to break userspace or not.
> 
> Right. I suspect we can, though, but it's one of those "we can try it
> and see". Remind me early in the 3.15 merge window, and we can just
> turn the "force" case into an error case and see if anybody hollers.

Super, I'll do that, thanks.

For 3.15, and probably 3.16 too, we should keep in place whatever
partial accommodations we have for the case (such as allowing for
anon and swap in fremap's zap_pte), in case we do need to revert;
but clean those away later on.  (Not many, I think: it was mainly
a guilty secret that VM accounting didn't really hold together.)

> 
> > If I remember correctly, it's been that way since early days,
> > in case ptrace were used to put a breakpoint into a MAP_SHARED
> > mapping of an executable: to prevent that modification from
> > reaching the file, if the file happened to be opened O_RDWR.
> > Usually it's not open for writing, and mapped MAP_PRIVATE anyway.
> 
> Yes, it's been that way since the very beginning, I think it goes back
> pretty much as far as MAP_SHARED does.
> 
> We used to play lots of games wrt MAP_SHARED - in fact I think we used
> to silently turn a MAP_SHARED RO mapping into MAP_PRIVATE because for
> the longest time there was no "true" writable MAP_SHARED at all, but
> we did have a coherent MAP_PRIVATE and something like the indexer for
> nntpd wanted a read-only shared mapping of the nntp spool or something
> like that. I forget the details, it's a _loong_ time ago.
> 
> So the whole "force turns a MAP_SHARED page into MAP_PRIVATE" all used
> to make a lot more sense in that kind of situation, when MAP_SHARED vs
> MAP_PRIVATE was much less of a black-and-white thing.
> 
> I really suspect nobody cares wrt ptrace, especially since presumably
> other systems haven't had those kinds of games (although who knows -
> HP-UX in particular had some of the shittiest mmap() implementations
> on the planet - it made even the original Linux mmap hacks look like a
> thing of pure beauty in comparison).

:)  That fits with what I heard of HP-UX mmap,
but I never had the pleasure of dealing with it.

Hugh
