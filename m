Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab3LKQjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:39:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:35450 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3LKQjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:39:01 -0500
Date: Wed, 11 Dec 2013 17:38:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mel Gorman <mgorman@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: process 'stuck' at exit.
In-Reply-To: <20131211163125.GC24125@suse.de>
Message-ID: <alpine.DEB.2.02.1312111737590.28330@ionos.tec.linutronix.de>
References: <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com> <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de> <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com> <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com> <20131210213431.GA6342@redhat.com> <20131210214143.GG27373@redhat.com> <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com> <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
 <alpine.DEB.2.02.1312102329201.28330@ionos.tec.linutronix.de> <20131211163125.GC24125@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013, Mel Gorman wrote:
> On Tue, Dec 10, 2013 at 11:42:15PM +0100, Thomas Gleixner wrote:
> > Now, if that map is RO, i.e. we took the fallback path then the THP
> > one will fail as it has write=1 unconditionally.
> > 
> >       if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) 
> > 
> 
> Not that it really matters but the naming and comments around that
> particular __get_user_pages_fast call are a little misleading.  The ifdef
> CONFIG_TRANSPARENT_HUGEPAGE in futex.c is there because greater care has
> to be taken against THP splits, not because it is dealing exclusively with
> THP. The PageTail check applies to either hugetlbfs or THPs and similarly
> gup_huge_pmd handles both. The whole path should be very rare for THPs
> considering that THPs exist on MAP_PRIVATE anonymous mappings and how many
> shared futexes exist backed by such mappings? A RO mapping makes that seem
> even more strange because what thread is updating the value the caller is
> waiting on? It seems more like that was a shared futex on a hugetlbfs-backed
> mappings which might explain why the bug was undiscovered for so long.

This is the fshared path. The MAP_PRIVATE path does not do that dance
at all.

Thanks,

	tglx
