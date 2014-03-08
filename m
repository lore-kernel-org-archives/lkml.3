Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaCHT6D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 14:58:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbaCHT6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 14:58:01 -0500
Date: Sat, 8 Mar 2014 20:57:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Davidlohr Bueso <davi@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm: per-thread vma caching
Message-ID: <20140308195705.GA588@redhat.com>
References: <1393537704.2899.3.camel@buesod1.americas.hpqcorp.net> <20140308184040.GA29602@redhat.com> <CA+55aFw88xiY+o5FE6VtHNkpUZDK3FPt31oCpNsgn1BH7wAPZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw88xiY+o5FE6VtHNkpUZDK3FPt31oCpNsgn1BH7wAPZw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

looks like I removed lkml somehow, resend...

On 03/08, Linus Torvalds wrote:
>
> On Sat, Mar 8, 2014 at 10:40 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > It seems this should be moved into copy_mm(), CLONE_VM needs to invalidate
> > ->vmacache too.
>
> No it doesn't. CLONE_VM doesn't change any of the vma lists,

Sure. But another thread or CLONE_VM task can do vmacache_invalidate(),
hit vmacache_seqnum == 0 and call vmacache_flush_all() to solve the
problem with potential overflow.

> so
> there's no reason to invalidate anything.
>
> > dup_task_struct() also copies vmacache_seqnum/vmacache, but the new thread
> > is not yet visible to vmacache_flush_all().
>
> So either the new task struct will share the mm, in which case the
> cache entries are fine

Not if they should be flushed by vmacache_flush_all() above.

Oleg.

