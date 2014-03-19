Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbaCSC5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 22:57:03 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:33818 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaCSC5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 22:57:01 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1403181928370.3499@eggly.anvils>
References: <20140311045109.GB12551@redhat.com>
	<20140310220158.7e8b7f2a.akpm@linux-foundation.org>
	<20140311053017.GB14329@redhat.com>
	<20140311132024.GC32390@moon>
	<531F0E39.9020100@oracle.com>
	<20140311134158.GD32390@moon>
	<20140311142817.GA26517@redhat.com>
	<20140311143750.GE32390@moon>
	<20140311171045.GA4693@redhat.com>
	<20140311173603.GG32390@moon>
	<20140311173917.GB4693@redhat.com>
	<alpine.LSU.2.11.1403181703470.7055@eggly.anvils>
	<CA+55aFx0ZyCVrkosgTongBrNX6mJM4B8+QZQE1p0okk8ubbv7g@mail.gmail.com>
	<alpine.LSU.2.11.1403181848380.3318@eggly.anvils>
	<CA+55aFxVG7HLmsvCzoiA7PBRPvX3utRfyVGrBs6gVLZ-fUCuPQ@mail.gmail.com>
	<alpine.LSU.2.11.1403181928370.3499@eggly.anvils>
Date: Tue, 18 Mar 2014 19:57:00 -0700
X-Google-Sender-Auth: Pn_gr7WW8EM-J_jhDu24QaoPyjs
Message-ID: <CA+55aFyjXdfsGniSHvCg83KCB-BD4SYNrJ+dcpr-8bnHsoet_Q@mail.gmail.com>
Subject: Re: bad rss-counter message in 3.14rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Dave Jones <davej@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bob Liu <bob.liu@oracle.com>, Konstantin Khlebnikov <koct9i@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 7:37 PM, Hugh Dickins <hughd@google.com> wrote:
>
> For 3.15, and probably 3.16 too, we should keep in place whatever
> partial accommodations we have for the case (such as allowing for
> anon and swap in fremap's zap_pte), in case we do need to revert;
> but clean those away later on.  (Not many, I think: it was mainly
> a guilty secret that VM accounting didn't really hold together.)

Absolutely. See if it works to just stop doing that special COW, and
then later on, if we have decided "nobody even noticed", we can remove
the hacks we have to support the fact that shared mappings sometimes
have anon pages in them.

> :)  That fits with what I heard of HP-UX mmap,
> but I never had the pleasure of dealing with it.

They had purely virtually indexed caches, making coherency
"interesting". Together with a VM based on some really old BSD VM code
that everybody else had thrown out, and that didn't allow you to unmap
things partially etc. So HPUX mmap really didn't work, not even for
non-shared mmap's.

I think they fixed the interfaces in HP-UX 11. But not being coherent
meant that the shared mappings tended to still have trouble. nntp
largely died, but was replaced with the cyrus imapd that played
similar games.

At least out mmap was always coherent. Even in MAP_PRIVATE, and with
regards to both write() system calls and other mmap PROT_WRITE users.

Except when we had bugs. Shared mmap really isn't very simple to get right.

                 Linus
