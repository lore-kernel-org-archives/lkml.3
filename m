Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbaJUKoC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:44:02 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40596 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbaJUKoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:44:01 -0400
Date: Tue, 21 Oct 2014 12:43:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tglx@linutronix.de,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-mm@kvack.org, "hillf.zj" <hillf.zj@alibaba-inc.com>
Subject: Re: [RFC][PATCH 5/6] mm: Provide speculative fault infrastructure
Message-ID: <20141021104347.GC12706@worktop.programming.kicks-ass.net>
References: <CAJd=RBAF3BS9GvPW+fNB9DNzyHrBZk4qNfU6QKUhNNKTMYkmNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBAF3BS9GvPW+fNB9DNzyHrBZk4qNfU6QKUhNNKTMYkmNQ@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 05:07:56PM +0800, Hillf Danton wrote:
> > +	pte = pte_offset_map(pmd, address);
> > +	fe.entry = ACCESS_ONCE(pte); /* XXX gup_get_pte() */
> 
> I wonder if one char, "*", is missing.
>
> > +	pte_unmap(pte);

Gah yes, last minute edit that. I noticed I missed the pte_unmap() while
doing the changelogs and 'fixed' up the code.
